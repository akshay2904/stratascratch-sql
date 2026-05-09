-- ======================================================================
-- Daily Revenue
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Meta, Amazon, Shopify
-- Access     : Premium
-- ID         : 10568
-- URL        : https://platform.stratascratch.com/coding/10568-daily-revenue
-- ======================================================================

/*
You work as a data analyst for an e-commerce platform. The sales team needs to understand the net revenue performance of Product ID 'PROD-2891' in the US market for purchases made during a recent two-week period. The dataset contains purchases and refunds. Refunds link to their original purchase via the original_transaction_id field.




Calculate daily net revenue for April 15-28, 2025. Include completed purchases of PROD-2891 made in the US during that period, and any completed refunds linked to those purchases, regardless of when the refund was processed or which country is recorded on the refund row. Show zero for days with no activity. Return transaction_date and daily_net_revenue.
*/

-- Tables:
--   product_sales(amount double precision, country text, original_transaction_id text, product_id text, status text, transaction_date date, transaction_id text, type text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH date_spine AS (
    -- Generate all dates in the two-week window
    SELECT generate_series(
        '2025-04-15'::date,
        '2025-04-28'::date,
        INTERVAL '1 day'
    )::date AS transaction_date
),

-- Identify qualifying purchases: completed, PROD-2891, US, within the window
qualifying_purchases AS (
    SELECT
        transaction_id,
        transaction_date::date AS transaction_date,
        amount
    FROM transactions
    WHERE product_id             = 'PROD-2891'
      AND country                = 'US'
      AND transaction_type       = 'purchase'
      AND status                 = 'completed'
      AND transaction_date::date BETWEEN '2025-04-15' AND '2025-04-28'
),

-- Completed refunds tied to any qualifying purchase
-- Refund is booked on the *purchase* date (per net-revenue-by-purchase-day logic)
qualifying_refunds AS (
    SELECT
        qp.transaction_date,          -- attribute refund to the original purchase date
        t.amount                      -- refund amounts are typically negative or will be subtracted
    FROM transactions t
    INNER JOIN qualifying_purchases qp
           ON t.original_transaction_id = qp.transaction_id
    WHERE t.transaction_type = 'refund'
      AND t.status           = 'completed'
),

daily_activity AS (
    -- Purchase revenue
    SELECT transaction_date, amount AS net_amount
    FROM qualifying_purchases

    UNION ALL

    -- Refund revenue (subtracted via negative amounts or explicit sign flip)
    SELECT transaction_date, -ABS(amount) AS net_amount
    FROM qualifying_refunds
)

SELECT
    ds.transaction_date,
    COALESCE(SUM(da.net_amount), 0) AS daily_net_revenue
FROM date_spine ds
LEFT JOIN daily_activity da
       ON da.transaction_date = ds.transaction_date
GROUP BY ds.transaction_date
ORDER BY ds.transaction_date;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    gs.transaction_date,
    COALESCE(
        (
            -- Sum of completed purchases on this day
            SELECT SUM(p.amount)
            FROM transactions p
            WHERE p.product_id             = 'PROD-2891'
              AND p.country                = 'US'
              AND p.transaction_type       = 'purchase'
              AND p.status                 = 'completed'
              AND p.transaction_date::date = gs.transaction_date
        ), 0)
    -
    COALESCE(
        (
            -- Sum of completed refunds linked to qualifying purchases on this day
            SELECT SUM(ABS(r.amount))
            FROM transactions r
            WHERE r.transaction_type       = 'refund'
              AND r.status                 = 'completed'
              AND r.original_transaction_id IN (
                    SELECT p2.transaction_id
                    FROM transactions p2
                    WHERE p2.product_id             = 'PROD-2891'
                      AND p2.country                = 'US'
                      AND p2.transaction_type       = 'purchase'
                      AND p2.status                 = 'completed'
                      AND p2.transaction_date::date = gs.transaction_date  -- refund attributed to purchase date
                )
        ), 0)
    AS daily_net_revenue
FROM (
    -- Brute-force date generation via a fixed-range subquery
    SELECT generate_series(
        '2025-04-15'::date,
        '2025-04-28'::date,
        INTERVAL '1 day'
    )::date AS transaction_date
) gs
ORDER BY gs.transaction_date;
