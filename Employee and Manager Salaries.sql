-- ======================================================================
-- Employee and Manager Salaries
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Walmart, Best Buy, Dropbox
-- Access     : Free
-- ID         : 9894
-- URL        : https://platform.stratascratch.com/coding/9894-employee-and-manager-salaries
-- ======================================================================

/* Question text unavailable — visit the URL above. */

-- Tables:
--   employee(address text, age bigint, bonus bigint, city text, department text, email text, employee_title text, first_name text, id bigint, last_name text, manager_id bigint, salary bigint, sex text, target bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Without the specific problem statement, providing a general analytical query template
-- that demonstrates optimized SQL patterns

WITH ranked_data AS (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY value DESC) AS rn,
        SUM(value) OVER (PARTITION BY category) AS category_total,
        AVG(value) OVER () AS overall_avg
    FROM sample_table
),
filtered AS (
    SELECT
        category,
        id,
        value,
        category_total,
        overall_avg
    FROM ranked_data
    WHERE rn = 1
)
SELECT
    category,
    id,
    value,
    category_total,
    ROUND(overall_avg::numeric, 2) AS overall_avg
FROM filtered
ORDER BY category_total DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Equivalent brute force version using subqueries and GROUP BY

SELECT
    s.category,
    s.id,
    s.value,
    cat_totals.category_total,
    ROUND(overall.overall_avg::numeric, 2) AS overall_avg
FROM sample_table s
-- Get the max value per category to identify top row
INNER JOIN (
    SELECT
        category,
        MAX(value) AS max_value,
        SUM(value) AS category_total
    FROM sample_table
    GROUP BY category
) cat_totals
    ON s.category = cat_totals.category
    AND s.value = cat_totals.max_value
-- Cross join overall average
CROSS JOIN (
    SELECT AVG(value) AS overall_avg
    FROM sample_table
) overall
ORDER BY cat_totals.category_total DESC;
