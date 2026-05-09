-- ======================================================================
-- Advertising Channel Effectiveness
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Uber
-- Access     : Premium
-- ID         : 10012
-- URL        : https://platform.stratascratch.com/coding/10012-advertising-channel-effectiveness
-- ======================================================================

/*
Find the effectiveness of each advertising channel in the period from 2017 to 2018 (both included). The effectiveness is calculated as the ratio of total money spent to total customers aquired.




Output the advertising channel along with corresponding effectiveness.
*/

-- Tables:
--   uber_advertising(advertising_channel text, customers_acquired bigint, money_spent bigint, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT 
    advertising_channel,
    SUM(money_spent) / NULLIF(SUM(customers_acquired), 0) AS effectiveness
FROM marketing_channels
WHERE EXTRACT(YEAR FROM date) BETWEEN 2017 AND 2018
GROUP BY advertising_channel;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    advertising_channel,
    total_money / NULLIF(total_customers, 0) AS effectiveness
FROM (
    SELECT 
        advertising_channel,
        SUM(money_spent) AS total_money,
        SUM(customers_acquired) AS total_customers
    FROM marketing_channels
    WHERE date >= '2017-01-01' AND date <= '2018-12-31'
    GROUP BY advertising_channel
) subq;
