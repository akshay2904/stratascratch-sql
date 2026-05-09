-- ======================================================================
-- First and Last Day Promotion Results
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Meta
-- Access     : Premium
-- ID         : 2120
-- URL        : https://platform.stratascratch.com/coding/2120-first-and-last-day
-- ======================================================================

/*
The marketing team is evaluating the performance of their previously ran promotions. They are particularly interested in comparing the number of transactions on the first and last day of each promotion.




Segment the results by promotion and calculate the percentage of total transactions that occurred on these days.




Your output should include the promotion ID, the percentage of transactions on the first day, and the percentage of transactions on the last day.
*/

-- Tables:
--   online_sales_promotions(cost bigint, end_date date, media_type text, promotion_id bigint, start_date date)
--   online_orders(cost_in_dollars bigint, customer_id bigint, date_sold date, product_id bigint, promotion_id bigint, units_sold bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH promotion_bounds AS (
    SELECT
        p.promotion_id,
        MIN(t.transaction_date) AS first_day,
        MAX(t.transaction_date) AS last_day,
        COUNT(*)                AS total_transactions
    FROM promotions p
    JOIN transactions t ON t.promotion_id = p.promotion_id
    GROUP BY p.promotion_id
),
daily_counts AS (
    SELECT
        t.promotion_id,
        t.transaction_date,
        COUNT(*) AS day_transactions
    FROM transactions t
    GROUP BY t.promotion_id, t.transaction_date
)
SELECT
    pb.promotion_id,
    ROUND(
        100.0 * MAX(CASE WHEN dc.transaction_date = pb.first_day THEN dc.day_transactions END)
              / pb.total_transactions, 2
    ) AS first_day_pct,
    ROUND(
        100.0 * MAX(CASE WHEN dc.transaction_date = pb.last_day  THEN dc.day_transactions END)
              / pb.total_transactions, 2
    ) AS last_day_pct
FROM promotion_bounds pb
JOIN daily_counts dc ON dc.promotion_id = pb.promotion_id
WHERE dc.transaction_date = pb.first_day
   OR dc.transaction_date = pb.last_day
GROUP BY pb.promotion_id, pb.total_transactions;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    t.promotion_id,
    ROUND(
        100.0
        * SUM(CASE WHEN t.transaction_date = bounds.first_day THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS first_day_pct,
    ROUND(
        100.0
        * SUM(CASE WHEN t.transaction_date = bounds.last_day  THEN 1 ELSE 0 END)
        / COUNT(*), 2
    ) AS last_day_pct
FROM transactions t
JOIN (
    SELECT
        promotion_id,
        MIN(transaction_date) AS first_day,
        MAX(transaction_date) AS last_day
    FROM transactions
    GROUP BY promotion_id
) AS bounds ON bounds.promotion_id = t.promotion_id
GROUP BY t.promotion_id;
