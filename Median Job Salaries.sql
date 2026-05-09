-- ======================================================================
-- Median Job Salaries
-- ======================================================================
-- Difficulty : Hard
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 9983
-- URL        : https://platform.stratascratch.com/coding/9983-median-job-salaries
-- ======================================================================

/*
Find the median total pay for each job. Output the job title and the corresponding total pay, and sort the results from highest total pay to lowest.
*/

-- Tables:
--   sf_public_salaries(agency text, basepay double precision, benefits double precision, employeename text, id bigint, jobtitle text, notes double precision, otherpay double precision, overtimepay double precision, status text, totalpay double precision, totalpaybenefits double precision, year bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT
        jobtitle,
        totalpay,
        ROW_NUMBER() OVER (PARTITION BY jobtitle ORDER BY totalpay) AS rn,
        COUNT(*) OVER (PARTITION BY jobtitle) AS cnt
    FROM salaries
),
median_calc AS (
    SELECT
        jobtitle,
        AVG(totalpay) AS median_totalpay
    FROM ranked
    -- For odd count: middle row; for even count: two middle rows averaged
    WHERE rn IN (FLOOR((cnt + 1.0) / 2), CEIL((cnt + 1.0) / 2))
    GROUP BY jobtitle
)
SELECT
    jobtitle,
    median_totalpay AS totalpay
FROM median_calc
ORDER BY median_totalpay DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    jobtitle,
    AVG(totalpay) AS totalpay
FROM (
    SELECT
        s1.jobtitle,
        s1.totalpay,
        (SELECT COUNT(*) FROM salaries s2
         WHERE s2.jobtitle = s1.jobtitle AND s2.totalpay <= s1.totalpay) AS cnt_lte,
        (SELECT COUNT(*) FROM salaries s2
         WHERE s2.jobtitle = s1.jobtitle) AS total_cnt
    FROM salaries s1
) sub
-- Keep only the median row(s): rows where count <= value covers at least half,
-- and count < value covers less than half
WHERE cnt_lte >= CEIL(total_cnt / 2.0)
  AND (total_cnt - cnt_lte) < CEIL(total_cnt / 2.0)
GROUP BY jobtitle
ORDER BY AVG(totalpay) DESC;
