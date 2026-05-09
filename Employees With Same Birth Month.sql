-- ======================================================================
-- Employees With Same Birth Month
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Block
-- Access     : Premium
-- ID         : 10355
-- URL        : https://platform.stratascratch.com/coding/10355-employees-with-same-birth-month
-- ======================================================================

/*
Identify the number of employees within each department that share the same birth month. Return the result as a table with one row per department and one column per month (Month_1 to Month_12). If a month has no employees born in it within a specific department, report this month as having 0 employees. The profession column stores the department names of each employee.
*/

-- Tables:
--   employee_list(birth_month bigint, birthday date, employee_id bigint, first_name text, last_name text, profession text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_counts AS (
    SELECT
        profession AS department,
        EXTRACT(MONTH FROM dob)::INT AS birth_month,
        COUNT(*) AS emp_count
    FROM employees
    GROUP BY profession, EXTRACT(MONTH FROM dob)::INT
)
SELECT
    department,
    COALESCE(SUM(CASE WHEN birth_month = 1  THEN emp_count END), 0) AS Month_1,
    COALESCE(SUM(CASE WHEN birth_month = 2  THEN emp_count END), 0) AS Month_2,
    COALESCE(SUM(CASE WHEN birth_month = 3  THEN emp_count END), 0) AS Month_3,
    COALESCE(SUM(CASE WHEN birth_month = 4  THEN emp_count END), 0) AS Month_4,
    COALESCE(SUM(CASE WHEN birth_month = 5  THEN emp_count END), 0) AS Month_5,
    COALESCE(SUM(CASE WHEN birth_month = 6  THEN emp_count END), 0) AS Month_6,
    COALESCE(SUM(CASE WHEN birth_month = 7  THEN emp_count END), 0) AS Month_7,
    COALESCE(SUM(CASE WHEN birth_month = 8  THEN emp_count END), 0) AS Month_8,
    COALESCE(SUM(CASE WHEN birth_month = 9  THEN emp_count END), 0) AS Month_9,
    COALESCE(SUM(CASE WHEN birth_month = 10 THEN emp_count END), 0) AS Month_10,
    COALESCE(SUM(CASE WHEN birth_month = 11 THEN emp_count END), 0) AS Month_11,
    COALESCE(SUM(CASE WHEN birth_month = 12 THEN emp_count END), 0) AS Month_12
FROM monthly_counts
GROUP BY department
ORDER BY department;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    profession AS department,
    -- Count employees born in each calendar month using inline subquery style
    SUM(CASE WHEN EXTRACT(MONTH FROM dob) = 1  THEN 1 ELSE 0 END) AS Month_1,
    SUM(CASE WHEN EXTRACT(MONTH FROM dob) = 2  THEN 1 ELSE 0 END) AS Month_2,
    SUM(CASE WHEN EXTRACT(MONTH FROM dob) = 3  THEN 1 ELSE 0 END) AS Month_3,
    SUM(CASE WHEN EXTRACT(MONTH FROM dob) = 4  THEN 1 ELSE 0 END) AS Month_4,
    SUM(CASE WHEN EXTRACT(MONTH FROM dob) = 5  THEN 1 ELSE 0 END) AS Month_5,
    SUM(CASE WHEN EXTRACT(MONTH FROM dob) = 6  THEN 1 ELSE 0 END) AS Month_6,
    SUM(CASE WHEN EXTRACT(MONTH FROM dob) = 7  THEN 1 ELSE 0 END) AS Month_7,
    SUM(CASE WHEN EXTRACT(MONTH FROM dob) = 8  THEN 1 ELSE 0 END) AS Month_8,
    SUM(CASE WHEN EXTRACT(MONTH FROM dob) = 9  THEN 1 ELSE 0 END) AS Month_9,
    SUM(CASE WHEN EXTRACT(MONTH FROM dob) = 10 THEN 1 ELSE 0 END) AS Month_10,
    SUM(CASE WHEN EXTRACT(MONTH FROM dob) = 11 THEN 1 ELSE 0 END) AS Month_11,
    SUM(CASE WHEN EXTRACT(MONTH FROM dob) = 12 THEN 1 ELSE 0 END) AS Month_12
FROM employees
GROUP BY profession
ORDER BY profession;
