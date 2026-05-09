-- ======================================================================
-- Employees' Years In Service
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Uber
-- Access     : Premium
-- ID         : 2042
-- URL        : https://platform.stratascratch.com/coding/2042-employees-years-in-service
-- ======================================================================

/*
Find employees who have worked for Uber for more than 2 years (730 days) and check to see if they're still part of the company. Output 'Yes' if they are and 'No' if they are not. Use May 1, 2021 as your date of reference when calculating whether they have worked for more than 2 years since their hire date.
Output the first name, last name, whether or not the employee is still working for Uber, and the number of years at the company.
*/

-- Tables:
--   uber_employees(first_name text, hire_date date, id bigint, last_name text, salary bigint, termination_date date)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- ============================================================

SELECT 
    first_name,
    last_name,
    CASE WHEN termination_date IS NULL THEN 'Yes' ELSE 'No' END AS still_employed,
    -- Calculate full years from hire_date to May 1, 2021
    EXTRACT(YEAR FROM AGE('2021-05-01'::date, hire_date))::int AS years_at_company
FROM uber_employees
WHERE hire_date <= '2021-05-01'::date - INTERVAL '730 days';

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- ============================================================

SELECT 
    first_name,
    last_name,
    CASE 
        WHEN termination_date IS NULL THEN 'Yes' 
        ELSE 'No' 
    END AS still_employed,
    -- Days difference divided by 365 for approximate years
    FLOOR(('2021-05-01'::date - hire_date) / 365.0)::int AS years_at_company
FROM uber_employees
WHERE ('2021-05-01'::date - hire_date) > 730;
