-- ======================================================================
-- Premium Accounts
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta, Asana
-- Access     : Premium
-- ID         : 2097
-- URL        : https://platform.stratascratch.com/coding/2097-premium-acounts
-- ======================================================================

/*
You have a dataset that records daily active users for each premium account. A premium account appears in the data every day as long as it remains premium. However, some premium accounts may be temporarily discounted, meaning they are not actively paying — this is indicated by a final_price of 0.




For each date, count the number of premium accounts that were actively paying on that day. Then, track how many of those same accounts are still premium and actively paying exactly 7 days later, if that later date exists in the dataset. Return results for the first 7 dates in the dataset.




Output three columns:

•   The date of initial calculation.

•   The number of premium accounts that were actively paying on that day.

•   The number of those accounts that remain premium and are still paying after 7 days.
*/

-- Tables:
--   premium_accounts_by_day(account_id text, entry_date date, final_price bigint, plan_size bigint, users_visited_7d bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_dates AS (
    -- Get distinct dates ranked chronologically
    SELECT DISTINCT
        entry_date,
        RANK() OVER (ORDER BY entry_date) AS date_rank
    FROM premium_accounts_by_day
),
first_7_dates AS (
    SELECT entry_date
    FROM ranked_dates
    WHERE date_rank <= 7
),
paying_accounts AS (
    -- Accounts actively paying (final_price > 0) for each date
    SELECT
        p.entry_date,
        p.account_id
    FROM premium_accounts_by_day p
    INNER JOIN first_7_dates f ON p.entry_date = f.entry_date
    WHERE p.final_price > 0
)
SELECT
    pa.entry_date,
    COUNT(DISTINCT pa.account_id)           AS premium_paid_accounts,
    COUNT(DISTINCT pa7.account_id)          AS premium_paid_accounts_after_7_days
FROM paying_accounts pa
LEFT JOIN premium_accounts_by_day pa7
    ON  pa.account_id  = pa7.account_id
    AND pa7.entry_date = pa.entry_date + INTERVAL '7 days'
    AND pa7.final_price > 0
GROUP BY pa.entry_date
ORDER BY pa.entry_date;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    base.entry_date,
    COUNT(DISTINCT base.account_id)         AS premium_paid_accounts,
    COUNT(DISTINCT future.account_id)       AS premium_paid_accounts_after_7_days
FROM premium_accounts_by_day base
LEFT JOIN premium_accounts_by_day future
    ON  base.account_id  = future.account_id
    AND future.entry_date = base.entry_date + INTERVAL '7 days'
    AND future.final_price > 0
WHERE
    -- Only consider the first 7 dates in the dataset
    base.entry_date IN (
        SELECT DISTINCT entry_date
        FROM premium_accounts_by_day
        ORDER BY entry_date
        LIMIT 7
    )
    -- Only accounts actively paying on the base date
    AND base.final_price > 0
GROUP BY base.entry_date
ORDER BY base.entry_date;
