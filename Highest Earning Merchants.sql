-- ======================================================================
-- Highest Earning Merchants
-- ======================================================================
-- Difficulty : Hard
-- Companies  : DoorDash
-- Access     : Premium
-- ID         : 2094
-- URL        : https://platform.stratascratch.com/coding/2094-highest-earning-merchants
-- ======================================================================

/*
For each day, you have been asked to find a merchant who earned the most money on the day before.




Before comparing totals between merchants, round the total amounts to the nearest 2 decimals places.




Your output should include the date in the format 'YYYY-MM-DD' and the merchant's name, but only for days where data from the previous day is available.




Note: In the case of multiple merchants having the same highest shared amount, your output should include all the names in different rows.
*/

-- Tables:
--   order_details(customer_id bigint, id bigint, merchant_id bigint, n_items bigint, order_timestamp timestamp without time zone, total_amount_earned double precision)
--   merchant_details(category text, id bigint, name text, zipcode bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH daily_totals AS (
    SELECT
        transaction_date::date AS txn_date,
        merchant_id,
        ROUND(SUM(amount)::numeric, 2) AS total_amount
    FROM transactions
    GROUP BY transaction_date::date, merchant_id
),
ranked AS (
    SELECT
        txn_date,
        merchant_id,
        total_amount,
        RANK() OVER (PARTITION BY txn_date ORDER BY total_amount DESC) AS rnk
    FROM daily_totals
),
prev_day_winners AS (
    SELECT
        txn_date AS prev_date,
        merchant_id,
        total_amount
    FROM ranked
    WHERE rnk = 1
)
SELECT
    TO_CHAR(d.txn_date, 'YYYY-MM-DD') AS date,
    m.merchant_name
FROM daily_totals d
-- Join to get the winner from the previous day
JOIN prev_day_winners p
    ON d.txn_date = p.prev_date + INTERVAL '1 day'
JOIN merchants m
    ON p.merchant_id = m.id
GROUP BY d.txn_date, p.prev_date, m.merchant_name
ORDER BY d.txn_date;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH daily_totals AS (
    SELECT
        transaction_date::date AS txn_date,
        merchant_id,
        ROUND(SUM(amount)::numeric, 2) AS total_amount
    FROM transactions
    GROUP BY transaction_date::date, merchant_id
),
max_per_day AS (
    -- Find the maximum total per day
    SELECT
        txn_date,
        MAX(total_amount) AS max_total
    FROM daily_totals
    GROUP BY txn_date
),
winners AS (
    -- Find all merchants who achieved the max total on each day
    SELECT
        dt.txn_date,
        dt.merchant_id,
        dt.total_amount
    FROM daily_totals dt
    JOIN max_per_day mpd
        ON dt.txn_date = mpd.txn_date
        AND dt.total_amount = mpd.max_total
)
SELECT
    TO_CHAR(curr_days.txn_date, 'YYYY-MM-DD') AS date,
    m.merchant_name
FROM (SELECT DISTINCT txn_date FROM daily_totals) curr_days
-- Only include days where the previous day exists in the data
JOIN winners w
    ON w.txn_date = curr_days.txn_date - INTERVAL '1 day'
JOIN merchants m
    ON w.merchant_id = m.id
ORDER BY curr_days.txn_date;
