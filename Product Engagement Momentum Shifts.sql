-- ======================================================================
-- Product Engagement Momentum Shifts
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Visa
-- Access     : Premium
-- ID         : 10564
-- URL        : https://platform.stratascratch.com/coding/10564-product-engagement-momentum-shifts
-- ======================================================================

/*
Identify all products that experienced a turnaround in user engagement: at least 3 consecutive months of declining monthly active users followed by at least 3 consecutive months of growth.




For each product that matches this pattern, return the product name, the month when the decline started, the month when growth resumed, and the growth ratio from the lowest point to the most recent peak, calculated as: (peak_users - lowest_users) / lowest_users.
*/

-- Tables:
--   product_engagement(month_start date, monthly_active_users bigint, product_id bigint, product_name text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_activity AS (
    -- Aggregate monthly active users per product
    SELECT
        product_id,
        DATE_TRUNC('month', activity_date) AS month,
        COUNT(DISTINCT user_id) AS mau
    FROM user_activity
    GROUP BY product_id, DATE_TRUNC('month', activity_date)
),
with_lag AS (
    SELECT
        product_id,
        month,
        mau,
        LAG(mau) OVER (PARTITION BY product_id ORDER BY month) AS prev_mau
    FROM monthly_activity
),
direction AS (
    -- +1 = growth month, -1 = decline month, 0 = flat
    SELECT
        product_id,
        month,
        mau,
        CASE
            WHEN prev_mau IS NULL THEN NULL
            WHEN mau < prev_mau THEN -1
            WHEN mau > prev_mau THEN  1
            ELSE 0
        END AS dir
    FROM with_lag
),
-- Assign streak groups using gaps-and-islands
streak_groups AS (
    SELECT
        product_id,
        month,
        mau,
        dir,
        SUM(CASE WHEN dir IS DISTINCT FROM LAG(dir) OVER (PARTITION BY product_id ORDER BY month) THEN 1 ELSE 0 END)
            OVER (PARTITION BY product_id ORDER BY month) AS grp
    FROM direction
    WHERE dir IS NOT NULL
),
streak_stats AS (
    SELECT
        product_id,
        dir,
        grp,
        MIN(month)  AS streak_start,
        MAX(month)  AS streak_end,
        COUNT(*)    AS streak_len,
        MIN(mau)    AS min_mau,   -- lowest during decline
        MAX(mau)    AS max_mau    -- peak during growth
    FROM streak_groups
    GROUP BY product_id, dir, grp
),
decline_streaks AS (
    SELECT * FROM streak_stats WHERE dir = -1 AND streak_len >= 3
),
growth_streaks  AS (
    SELECT * FROM streak_stats WHERE dir =  1 AND streak_len >= 3
),
turnarounds AS (
    SELECT
        d.product_id,
        d.streak_start                          AS decline_start,
        g.streak_start                          AS growth_start,
        d.min_mau                               AS lowest_users,
        g.max_mau                               AS peak_users,
        -- Ensure growth streak immediately follows the decline streak
        ROW_NUMBER() OVER (
            PARTITION BY d.product_id, d.grp
            ORDER BY g.streak_start
        ) AS rn
    FROM decline_streaks d
    JOIN growth_streaks  g
        ON d.product_id = g.product_id
        -- growth streak starts the month right after decline ended
        AND g.streak_start = d.streak_end + INTERVAL '1 month'
)
SELECT
    p.product_name,
    t.decline_start,
    t.growth_start,
    ROUND(
        (t.peak_users - t.lowest_users)::NUMERIC / NULLIF(t.lowest_users, 0),
        4
    ) AS growth_ratio
FROM turnarounds t
JOIN products p ON p.product_id = t.product_id
WHERE t.rn = 1   -- one result per decline-streak match
ORDER BY p.product_name, t.decline_start;


-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH monthly_activity AS (
    SELECT
        product_id,
        DATE_TRUNC('month', activity_date) AS month,
        COUNT(DISTINCT user_id) AS mau
    FROM user_activity
    GROUP BY product_id, DATE_TRUNC('month', activity_date)
),
-- Self-join to compare consecutive months
consecutive AS (
    SELECT
        a.product_id,
        a.month      AS month_curr,
        a.mau        AS mau_curr,
        b.month      AS month_prev,
        b.mau        AS mau_prev,
        CASE
            WHEN a.mau < b.mau THEN -1
            WHEN a.mau > b.mau THEN  1
            ELSE 0
        END AS dir
    FROM monthly_activity a
    JOIN monthly_activity b
        ON a.product_id = b.product_id
        AND a.month = b.month + INTERVAL '1 month'
),
-- Find months that are the START of a decline run of >=3
-- i.e., this month is decline AND next 2 are also decline
decline_starts AS (
    SELECT DISTINCT
        c1.product_id,
        c1.month_curr AS decline_start
    FROM consecutive c1
    JOIN consecutive c2
        ON c1.product_id = c2.product_id
        AND c2.month_curr = c1.month_curr + INTERVAL '1 month'
    JOIN consecutive c3
        ON c1.product_id = c3.product_id
        AND c3.month_curr = c1.month_curr + INTERVAL '2 months'
    WHERE c1.dir = -1 AND c2.dir = -1 AND c3.dir = -1
),
-- Find months that are the START of a growth run of >=3
growth_starts AS (
    SELECT DISTINCT
        c1.product_id,
        c1.month_curr AS growth_start
    FROM consecutive c1
    JOIN consecutive c2
        ON c1.product_id = c2.product_id
        AND c2.month_curr = c1.month_curr + INTERVAL '1 month'
    JOIN consecutive c3
        ON c1.product_id = c3.product_id
        AND c3.month_curr = c1.month_curr + INTERVAL '2 months'
    WHERE c1.dir = 1 AND c2.dir = 1 AND c3.dir = 1
),
-- Find the end of each qualifying decline run
-- (last consecutive month that is still declining)
decline_runs AS (
    SELECT
        ds.product_id,
        ds.decline_start,
        MAX(c.month_curr) AS decline_end
    FROM decline_starts ds
    JOIN consecutive c
        ON ds.product_id = c.product_id
        AND c.month_curr >= ds.decline_start
        AND c.dir = -1
        -- only months contiguous with the start
        AND NOT EXISTS (
            SELECT 1 FROM consecutive cx
            WHERE cx.product_id = c.product_id
              AND cx.month_curr > ds.decline_start
              AND cx.month_curr <= c.month_curr
              AND cx.dir <> -1
        )
    GROUP BY ds.product_id, ds.decline_start
),
-- Pair each decline run with the immediately following growth run
turnarounds AS (
    SELECT
        dr.product_id,
        dr.decline_start,
        gs.growth_start
    FROM decline_runs dr
    JOIN growth_starts gs
        ON dr.product_id = gs.product_id
        AND gs.growth_start = dr.decline_end + INTERVAL '1 month'
),
-- Lowest MAU: minimum over the decline + transition month (just before growth)
lowest AS (
    SELECT
        t.product_id,
        t.decline_start,
        t.growth_start,
        MIN(ma.mau) AS lowest_users
    FROM turnarounds t
    JOIN monthly_activity ma
        ON ma.product_id = t.product_id
        AND ma.month >= t.decline_start
        AND ma.month <  t.growth_start
    GROUP BY t.product_id, t.decline_start, t.growth_start
),
-- Peak MAU: maximum over the growth run (3+ months from growth start onward)
peak AS (
    SELECT
        t.product_id,
        t.decline_start,
        t.growth_start,
