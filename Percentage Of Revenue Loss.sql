-- ======================================================================
-- Percentage Of Revenue Loss
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Uber
-- Access     : Premium
-- ID         : 2048
-- URL        : https://platform.stratascratch.com/coding/2048-percentage-of-revenue-loss
-- ======================================================================

/*
For each service, calculate the percentage of incomplete orders along with the percentage of revenue loss from incomplete orders relative to total revenue.




Your output should include:




•  The name of the service

•  The percentage of incomplete orders

•  The percentage of revenue loss from incomplete orders
*/

-- Tables:
--   uber_orders(monetary_value double precision, number_of_orders bigint, order_date date, service_name text, status_of_order text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH order_stats AS (
    SELECT
        s.service_name,
        COUNT(o.order_id)                                                        AS total_orders,
        COUNT(o.order_id) FILTER (WHERE o.status != 'complete')                  AS incomplete_orders,
        SUM(o.total_amount)                                                      AS total_revenue,
        SUM(o.total_amount) FILTER (WHERE o.status != 'complete')                AS lost_revenue
    FROM services s
    LEFT JOIN orders o ON s.service_id = o.service_id
    GROUP BY s.service_name
)
SELECT
    service_name,
    ROUND(
        CASE WHEN total_orders = 0 THEN 0
             ELSE incomplete_orders * 100.0 / total_orders
        END, 2
    ) AS pct_incomplete_orders,
    ROUND(
        CASE WHEN total_revenue = 0 OR total_revenue IS NULL THEN 0
             ELSE lost_revenue * 100.0 / total_revenue
        END, 2
    ) AS pct_revenue_loss
FROM order_stats
ORDER BY pct_revenue_loss DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    s.service_name,
    ROUND(
        CASE
            WHEN (SELECT COUNT(*) FROM orders o WHERE o.service_id = s.service_id) = 0 THEN 0
            ELSE (
                SELECT COUNT(*) FROM orders o
                WHERE o.service_id = s.service_id AND o.status != 'complete'
            ) * 100.0 /
            (SELECT COUNT(*) FROM orders o WHERE o.service_id = s.service_id)
        END, 2
    ) AS pct_incomplete_orders,
    ROUND(
        CASE
            WHEN (SELECT SUM(total_amount) FROM orders o WHERE o.service_id = s.service_id) IS NULL
              OR (SELECT SUM(total_amount) FROM orders o WHERE o.service_id = s.service_id) = 0 THEN 0
            ELSE (
                SELECT COALESCE(SUM(total_amount), 0) FROM orders o
                WHERE o.service_id = s.service_id AND o.status != 'complete'
            ) * 100.0 /
            (SELECT SUM(total_amount) FROM orders o WHERE o.service_id = s.service_id)
        END, 2
    ) AS pct_revenue_loss
FROM services s
ORDER BY pct_revenue_loss DESC;
