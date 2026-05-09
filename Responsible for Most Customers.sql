-- ======================================================================
-- Responsible for Most Customers
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Asana, Workday, Amazon
-- Access     : Premium
-- ID         : 2108
-- URL        : https://platform.stratascratch.com/coding/2108-responsible-for-most-customers
-- ======================================================================

/*
Each Employee is assigned one territory and is responsible for the Customers from this territory. There may be multiple employees assigned to the same territory.
Write a query to get the Employees who are responsible for the maximum number of Customers. Output the Employee ID and the number of Customers.
*/

-- Tables:
--   map_employee_territory(empl_id text, territory_id text)
--   map_customer_territory(cust_id text, territory_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH employee_customer_counts AS (
    SELECT
        et.employeeid,
        COUNT(DISTINCT c.customerid) AS customer_count
    FROM employeeterritories et
    JOIN territories t ON et.territoryid = t.territoryid
    JOIN customers c ON c.region = t.regionid  -- link customers to territory/region
    GROUP BY et.employeeid
),
ranked AS (
    SELECT
        employeeid,
        customer_count,
        RANK() OVER (ORDER BY customer_count DESC) AS rnk
    FROM employee_customer_counts
)
SELECT
    employeeid,
    customer_count AS num_customers
FROM ranked
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    et.employeeid,
    COUNT(DISTINCT c.customerid) AS num_customers
FROM employeeterritories et
JOIN territories t ON et.territoryid = t.territoryid
JOIN customers c ON c.region = t.regionid
GROUP BY et.employeeid
HAVING COUNT(DISTINCT c.customerid) = (
    -- subquery to find the maximum customer count across all employees
    SELECT MAX(emp_counts.cnt)
    FROM (
        SELECT
            et2.employeeid,
            COUNT(DISTINCT c2.customerid) AS cnt
        FROM employeeterritories et2
        JOIN territories t2 ON et2.territoryid = t2.territoryid
        JOIN customers c2 ON c2.region = t2.regionid
        GROUP BY et2.employeeid
    ) AS emp_counts
);
