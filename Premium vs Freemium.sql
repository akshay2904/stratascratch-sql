-- ======================================================================
-- Premium vs Freemium
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Microsoft
-- Access     : Premium
-- ID         : 10300
-- URL        : https://platform.stratascratch.com/coding/10300-premium-vs-freemium
-- ======================================================================

/*
Find the total number of downloads for paying and non-paying users by date. Include only records where non-paying customers have more downloads than paying customers. The output should be sorted by earliest date first and contain 3 columns date, non-paying downloads, paying downloads. Hint: In Oracle you should use "date" when referring to date column (reserved keyword).
*/

-- Tables:
--   ms_user_dimension(acc_id bigint, user_id bigint)
--   ms_acc_dimension(acc_id bigint, paying_customer text)
--   ms_download_facts(date date, downloads bigint, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH daily_downloads AS (
    SELECT
        date,
        SUM(CASE WHEN paying_customer = 'yes' THEN downloads ELSE 0 END) AS paying_downloads,
        SUM(CASE WHEN paying_customer = 'no'  THEN downloads ELSE 0 END) AS non_paying_downloads
    FROM ms_user_dimension u
    JOIN ms_acc_dimension a ON u.acc_id = a.acc_id
    JOIN ms_download_facts d ON u.user_id = d.user_id
    GROUP BY date
)
SELECT
    date,
    non_paying_downloads,
    paying_downloads
FROM daily_downloads
WHERE non_paying_downloads > paying_downloads
ORDER BY date ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    d.date,
    SUM(CASE WHEN a.paying_customer = 'no'  THEN d.downloads ELSE 0 END) AS non_paying_downloads,
    SUM(CASE WHEN a.paying_customer = 'yes' THEN d.downloads ELSE 0 END) AS paying_downloads
FROM ms_download_facts d
JOIN ms_user_dimension u ON d.user_id = u.user_id
JOIN ms_acc_dimension a  ON u.acc_id = a.acc_id
GROUP BY d.date
HAVING SUM(CASE WHEN a.paying_customer = 'no'  THEN d.downloads ELSE 0 END)
     > SUM(CASE WHEN a.paying_customer = 'yes' THEN d.downloads ELSE 0 END)
ORDER BY d.date ASC;
