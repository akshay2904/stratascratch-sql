-- ======================================================================
-- Average Age of Claims by Gender
-- ======================================================================
-- Difficulty : Medium
-- Companies  : CVS Health
-- Access     : Premium
-- ID         : 2139
-- URL        : https://platform.stratascratch.com/coding/2139-average-age-of-claims-by-gender
-- ======================================================================

/*
You have been asked to calculate the average age by gender of people who filed more than 1 claim in 2021.




The output should include the gender and average age rounded to the nearest whole number.
*/

-- Tables:
--   cvs_claims(account_id text, claim_id bigint, date_accepted date, date_rejected date, date_submitted date)
--   cvs_accounts(account_id text, age bigint, gender text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH claim_counts AS (
    SELECT 
        p.gender,
        p.age,
        COUNT(c.claim_id) OVER (PARTITION BY c.account_id) AS claim_count
    FROM cvs_accounts p
    JOIN cvs_claims c 
        ON p.account_id = c.account_id
    WHERE EXTRACT(YEAR FROM c.date_submitted) = 2021
),
filtered AS (
    SELECT gender, age
    FROM claim_counts
    WHERE claim_count > 1
)
SELECT 
    gender,
    ROUND(AVG(age)) AS average_age
FROM filtered
GROUP BY gender;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    p.gender,
    ROUND(AVG(p.age)) AS average_age
FROM cvs_accounts p
WHERE p.account_id IN (
    SELECT account_id
    FROM cvs_claims
    WHERE EXTRACT(YEAR FROM date_submitted) = 2021
    GROUP BY account_id
    HAVING COUNT(claim_id) > 1
)
GROUP BY p.gender;
