-- ======================================================================
-- Find the scores of 4 quartiles of each company
-- ======================================================================
-- Difficulty : Hard
-- Companies  : City of Los Angeles
-- Access     : Premium
-- ID         : 9713
-- URL        : https://platform.stratascratch.com/coding/9713-find-the-scores-of-4-quartiles-of-each-company
-- ======================================================================

/*
Find the scores of 4 quartiles of each company

Output the company's owner name along with the corresponding score of each quartile.

Order records based on the average score of all quartiles in ascending order.
*/

-- Tables:
--   los_angeles_restaurant_health_inspections(activity_date date, employee_id text, facility_address text, facility_city text, facility_id text, facility_name text, facility_state text, facility_zip text, grade text, owner_id text, owner_name text, pe_description text, program_element_pe bigint, program_name text, program_status text, record_id text, score bigint, serial_number text, service_code bigint, service_description text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH quartile_scores AS (
    SELECT
        owner,
        score,
        NTILE(4) OVER (PARTITION BY owner ORDER BY score) AS quartile
    FROM linkedin_posts
),
quartile_agg AS (
    SELECT
        owner,
        MAX(CASE WHEN quartile = 1 THEN score END) AS Q1,
        MAX(CASE WHEN quartile = 2 THEN score END) AS Q2,
        MAX(CASE WHEN quartile = 3 THEN score END) AS Q3,
        MAX(CASE WHEN quartile = 4 THEN score END) AS Q4,
        AVG(score) AS avg_score
    FROM quartile_scores
    GROUP BY owner
)
SELECT
    owner,
    Q1,
    Q2,
    Q3,
    Q4
FROM quartile_agg
ORDER BY avg_score ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    owner,
    MAX(CASE WHEN quartile = 1 THEN score END) AS Q1,
    MAX(CASE WHEN quartile = 2 THEN score END) AS Q2,
    MAX(CASE WHEN quartile = 3 THEN score END) AS Q3,
    MAX(CASE WHEN quartile = 4 THEN score END) AS Q4
FROM (
    SELECT
        owner,
        score,
        NTILE(4) OVER (PARTITION BY owner ORDER BY score) AS quartile
    FROM linkedin_posts
) ranked
GROUP BY owner
ORDER BY (
    SELECT AVG(score)
    FROM linkedin_posts lp
    WHERE lp.owner = ranked.owner
) ASC;
