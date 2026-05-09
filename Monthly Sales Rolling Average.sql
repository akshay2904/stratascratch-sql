-- ======================================================================
-- Monthly Sales Rolling Average
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Amazon
-- Access     : Premium
-- ID         : 2148
-- URL        : https://platform.stratascratch.com/coding/2148-monthly-sales-rolling-average
-- ======================================================================

/*
You have been asked to calculate the cumulative average for monthly book sales in 2022.




A cumulative average updates each month using all months up to that point (e.g., February uses January+February divided by 2; March uses January–March divided by 3; and so on). This is not a fixed-window rolling average.




Output the month, the sales for that month, and an extra column containing the rolling average rounded to the nearest whole number.
*/

-- Tables:
--   amazon_books(book_id text, book_title text, unit_price bigint)
--   book_orders(book_id text, order_date date, order_id bigint, quantity bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    month,
    sales,
    ROUND(AVG(sales) OVER (ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)) AS cumulative_avg
FROM bookings
WHERE EXTRACT(YEAR FROM month) = 2022
ORDER BY month;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    b1.month,
    b1.sales,
    ROUND(
        (SELECT AVG(b2.sales)
         FROM bookings b2
         WHERE EXTRACT(YEAR FROM b2.month) = 2022
           AND b2.month <= b1.month)
    ) AS cumulative_avg
FROM bookings b1
WHERE EXTRACT(YEAR FROM b1.month) = 2022
ORDER BY b1.month;
