-- ======================================================================
-- Positive Ad Channels
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Uber
-- Access     : Premium
-- ID         : 10013
-- URL        : https://platform.stratascratch.com/coding/10013-positive-ad-channels
-- ======================================================================

/*
Find the advertising channel with the smallest maximum yearly spending that still brings in more than 1500 customers each year.
*/

-- Tables:
--   uber_advertising(advertising_channel text, customers_acquired bigint, money_spent bigint, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH yearly_stats AS (
    SELECT
        channel,
        year,
        SUM(spending) AS yearly_spending,
        SUM(customers) AS yearly_customers
    FROM advertising
    GROUP BY channel, year
),
channel_summary AS (
    SELECT
        channel,
        MAX(yearly_spending) AS max_yearly_spending,
        MIN(yearly_customers) AS min_yearly_customers  -- ensure ALL years exceed 1500
    FROM yearly_stats
    GROUP BY channel
)
SELECT
    channel,
    max_yearly_spending
FROM channel_summary
WHERE min_yearly_customers > 1500
ORDER BY max_yearly_spending ASC
LIMIT 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    channel,
    MAX(yearly_spending) AS max_yearly_spending
FROM (
    SELECT
        channel,
        year,
        SUM(spending) AS yearly_spending,
        SUM(customers) AS yearly_customers
    FROM advertising
    GROUP BY channel, year
) AS yearly_data
GROUP BY channel
HAVING MIN(yearly_customers) > 1500  -- every year must have > 1500 customers
ORDER BY max_yearly_spending ASC
LIMIT 1;
