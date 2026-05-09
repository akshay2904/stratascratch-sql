-- ======================================================================
-- City With The Highest and Lowest Income Variance
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Postmates
-- Access     : Premium
-- ID         : 2015
-- URL        : https://platform.stratascratch.com/coding/2015-city-with-the-highest-and-lowest-income-variance
-- ======================================================================

/*
What cities recorded the largest growth and biggest drop in order amount between March 11, 2019, and April 11, 2019. Just compare order amounts on those two dates. Your output should include the names of the cities and the amount of growth/drop.
*/

-- Tables:
--   postmates_orders(amount double precision, city_id bigint, courier_id bigint, customer_id bigint, id bigint, order_timestamp_utc timestamp without time zone, seller_id bigint)
--   postmates_markets(id bigint, name text, timezone text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH daily_city_orders AS (
    SELECT
        city,
        DATE(order_date) AS order_day,
        SUM(order_total) AS total_amount
    FROM orders
    WHERE DATE(order_date) IN ('2019-03-11', '2019-04-11')
    GROUP BY city, DATE(order_date)
),
pivoted AS (
    SELECT
        city,
        MAX(CASE WHEN order_day = '2019-03-11' THEN total_amount ELSE 0 END) AS march_amount,
        MAX(CASE WHEN order_day = '2019-04-11' THEN total_amount ELSE 0 END) AS april_amount
    FROM daily_city_orders
    GROUP BY city
),
changes AS (
    SELECT
        city,
        april_amount - march_amount AS change_amount
    FROM pivoted
)
-- Union largest growth and biggest drop
SELECT city, change_amount
FROM changes
WHERE change_amount = (SELECT MAX(change_amount) FROM changes)
UNION ALL
SELECT city, change_amount
FROM changes
WHERE change_amount = (SELECT MIN(change_amount) FROM changes);

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT city, change_amount
FROM (
    SELECT
        city,
        (
            SELECT COALESCE(SUM(o2.order_total), 0)
            FROM orders o2
            WHERE DATE(o2.order_date) = '2019-04-11'
              AND o2.city = o1.city
        ) -
        (
            SELECT COALESCE(SUM(o3.order_total), 0)
            FROM orders o3
            WHERE DATE(o3.order_date) = '2019-03-11'
              AND o3.city = o1.city
        ) AS change_amount
    FROM orders o1
    WHERE DATE(o1.order_date) IN ('2019-03-11', '2019-04-11')
    GROUP BY city
) city_changes
WHERE change_amount = (
    SELECT MAX(sub.change_amount)
    FROM (
        SELECT
            city,
            (
                SELECT COALESCE(SUM(o2.order_total), 0)
                FROM orders o2
                WHERE DATE(o2.order_date) = '2019-04-11'
                  AND o2.city = o1.city
            ) -
            (
                SELECT COALESCE(SUM(o3.order_total), 0)
                FROM orders o3
                WHERE DATE(o3.order_date) = '2019-03-11'
                  AND o3.city = o1.city
            ) AS change_amount
        FROM orders o1
        WHERE DATE(o1.order_date) IN ('2019-03-11', '2019-04-11')
        GROUP BY city
    ) sub
)
OR change_amount = (
    SELECT MIN(sub.change_amount)
    FROM (
        SELECT
            city,
            (
                SELECT COALESCE(SUM(o2.order_total), 0)
                FROM orders o2
                WHERE DATE(o2.order_date) = '2019-04-11'
                  AND o2.city = o1.city
            ) -
            (
                SELECT COALESCE(SUM(o3.order_total), 0)
                FROM orders o3
                WHERE DATE(o3.order_date) = '2019-03-11'
                  AND o3.city = o1.city
            ) AS change_amount
        FROM orders o1
        WHERE DATE(o1.order_date) IN ('2019-03-11', '2019-04-11')
        GROUP BY city
    ) sub
);
