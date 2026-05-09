-- ======================================================================
-- Find the number of employees who received the bonus and who didn't
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Dell, Microsoft
-- Access     : Premium
-- ID         : 10081
-- URL        : https://platform.stratascratch.com/coding/10081-find-the-number-of-employees-who-received-the-bonus-and-who-didnt
-- ======================================================================

/*
Find the number of employees who received the bonus and who didn't. Bonus values in employee table are corrupted so you should use  values from the bonus table. Be aware of the fact that employee can receive more than one bonus.

Output value inside has_bonus column (1 if they had bonus, 0 if not) along with the corresponding number of employees for each.
*/

-- Tables:
--   employee(address text, age bigint, bonus bigint, city text, department text, email text, employee_title text, first_name text, id bigint, last_name text, manager_id bigint, salary bigint, sex text, target bigint)
--   bonus(bonus_amount bigint, bonus_date date, worker_ref_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- ============================================================

WITH employee_bonus AS (
    SELECT
        e.id,
        CASE WHEN MAX(b.worker_ref_id) IS NOT NULL THEN 1 ELSE 0 END AS has_bonus
    FROM employee e
    LEFT JOIN bonus b ON e.id = b.worker_ref_id
    GROUP BY e.id
)
SELECT
    has_bonus,
    COUNT(*) AS number_of_employees
FROM employee_bonus
GROUP BY has_bonus
ORDER BY has_bonus DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- ============================================================

SELECT
    has_bonus,
    COUNT(*) AS number_of_employees
FROM (
    SELECT
        e.id,
        CASE
            WHEN e.id IN (SELECT DISTINCT worker_ref_id FROM bonus) THEN 1
            ELSE 0
        END AS has_bonus
    FROM employee e
) subq
GROUP BY has_bonus
ORDER BY has_bonus DESC;
