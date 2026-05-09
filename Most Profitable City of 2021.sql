-- ======================================================================
-- Most Profitable City of 2021
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Lyft
-- Access     : Premium
-- ID         : 2137
-- URL        : https://platform.stratascratch.com/coding/2137-most-profitable-city-of-2021
-- ======================================================================

/*
It's the end-of-year review, and you've been tasked with identifying the city with the most profitable month in 2021.




The output should provide the city, the most profitable month, and the profit.
*/

-- Tables:
--   lyft_orders(city text, country text, customer_id text, driver_id text, order_id bigint)
--   lyft_payment_details(order_date date, order_fare double precision, order_id bigint, promo_code boolean)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_profit AS (
    SELECT
        city,
        EXTRACT(MONTH FROM date) AS month,
        SUM(profit) AS total_profit,
        RANK() OVER (PARTITION BY city ORDER BY SUM(profit) DESC) AS rnk
    FROM sales
    WHERE EXTRACT(YEAR FROM date) = 2021
    GROUP BY city, EXTRACT(MONTH FROM date)
),
city_best_month AS (
    SELECT
        city,
        month,
        total_profit,
        RANK() OVER (ORDER BY total_profit DESC) AS overall_rnk
    FROM monthly_profit
    WHERE rnk = 1
)
SELECT
    city,
    month,
    total_profit AS profit
FROM city_best_month
WHERE overall_rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    city,
    month,
    profit
FROM (
    SELECT
        city,
        EXTRACT(MONTH FROM date) AS month,
        SUM(profit) AS profit
    FROM sales
    WHERE EXTRACT(YEAR FROM date) = 2021
    GROUP BY city, EXTRACT(MONTH FROM date)
) city_monthly
WHERE profit = (
    -- Find the single highest monthly profit across all cities
    SELECT MAX(monthly_total)
    FROM (
        SELECT SUM(profit) AS monthly_total
        FROM sales
        WHERE EXTRACT(YEAR FROM date) = 2021
        GROUP BY city, EXTRACT(MONTH FROM date)
    ) all_monthly
);
