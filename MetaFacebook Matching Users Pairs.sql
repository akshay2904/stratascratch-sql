-- ======================================================================
-- Meta/Facebook Matching Users Pairs
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Free
-- ID         : 10085
-- URL        : https://platform.stratascratch.com/coding/10085-facebook-matching-users-pairs
-- ======================================================================

/*
Find matching pairs of Meta/Facebook employees such that they are both of the same nation, different age, same gender, and at different seniority levels.

Output ids of paired employees.
*/

-- Tables:
--   facebook_employees(age bigint, gender text, id bigint, is_senior boolean, location text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH meta_employees AS (
    SELECT id, nationality, age, sex, seniority
    FROM facebook_employees
)
SELECT 
    e1.id AS employee1_id,
    e2.id AS employee2_id
FROM meta_employees e1
JOIN meta_employees e2
    ON e1.nationality = e2.nationality   -- same nation
    AND e1.sex        = e2.sex           -- same gender
    AND e1.age       <> e2.age           -- different age
    AND e1.seniority <> e2.seniority     -- different seniority level
    AND e1.id < e2.id                    -- avoid duplicate/mirror pairs

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    e1.id AS employee1_id,
    e2.id AS employee2_id
FROM facebook_employees e1,
     facebook_employees e2
WHERE e1.nationality = e2.nationality   -- same nation
  AND e1.sex         = e2.sex           -- same gender
  AND e1.age        <> e2.age           -- different age
  AND e1.seniority  <> e2.seniority     -- different seniority level
  AND e1.id < e2.id                     -- avoid duplicate/mirror pairs
