-- ======================================================================
-- Top 2 Sales Time Combinations
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Tesla
-- Access     : Premium
-- ID         : 2154
-- URL        : https://platform.stratascratch.com/coding/2154-top-2-busiest-sales-days
-- ======================================================================

/*
The company you are working for wants to anticipate their staffing needs by identifying their top two busiest times of the week. To find this, each day should be segmented into differents parts using following criteria:





Morning: Before 12 p.m. (not inclusive)


Early afternoon: 12 -15 p.m.


Late afternoon: after 15 p.m. (not inclusive)





Your output should include the day and time of day combination for the two busiest times, i.e. the combinations with the most orders, along with the number of orders (e.g. top two results could be Friday Late afternoon with 12 orders and Sunday Morning with 10 orders). The company has also requested that the day be displayed in text format (i.e. Monday).




Note: In the event of a tie in ranking, all results should be displayed.
*/

-- Tables:
--   sales_log(order_id bigint, product_id bigint, timestamp timestamp without time zone)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH time_segments AS (
    SELECT
        TO_CHAR(order_date, 'Day') AS day_name,
        EXTRACT(DOW FROM order_date) AS day_num, -- for ordering days properly
        CASE
            WHEN EXTRACT(HOUR FROM order_date) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM order_date) BETWEEN 12 AND 15 THEN 'Early afternoon'
            ELSE 'Late afternoon'
        END AS time_of_day
    FROM orders
),
order_counts AS (
    SELECT
        TRIM(day_name) AS day_name,
        time_of_day,
        COUNT(*) AS num_orders
    FROM time_segments
    GROUP BY day_name, day_num, time_of_day
),
ranked AS (
    SELECT
        day_name,
        time_of_day,
        num_orders,
        DENSE_RANK() OVER (ORDER BY num_orders DESC) AS rnk
    FROM order_counts
)
SELECT
    day_name,
    time_of_day,
    num_orders
FROM ranked
WHERE rnk <= 2;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    TRIM(TO_CHAR(order_date, 'Day')) AS day_name,
    CASE
        WHEN EXTRACT(HOUR FROM order_date) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM order_date) BETWEEN 12 AND 15 THEN 'Early afternoon'
        ELSE 'Late afternoon'
    END AS time_of_day,
    COUNT(*) AS num_orders
FROM orders
GROUP BY
    TRIM(TO_CHAR(order_date, 'Day')),
    CASE
        WHEN EXTRACT(HOUR FROM order_date) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM order_date) BETWEEN 12 AND 15 THEN 'Early afternoon'
        ELSE 'Late afternoon'
    END
HAVING COUNT(*) >= (
    -- find the count threshold that corresponds to the 2nd highest count
    SELECT MIN(top_counts.num_orders)
    FROM (
        SELECT COUNT(*) AS num_orders
        FROM orders
        GROUP BY
            TRIM(TO_CHAR(order_date, 'Day')),
            CASE
                WHEN EXTRACT(HOUR FROM order_date) < 12 THEN 'Morning'
                WHEN EXTRACT(HOUR FROM order_date) BETWEEN 12 AND 15 THEN 'Early afternoon'
                ELSE 'Late afternoon'
            END
        ORDER BY num_orders DESC
        LIMIT 2
    ) AS top_counts
)
ORDER BY num_orders DESC;
