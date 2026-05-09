-- ======================================================================
-- Best Selling Item
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Ebay, Best Buy, Amazon
-- Access     : Free
-- ID         : 10172
-- URL        : https://platform.stratascratch.com/coding/10172-best-selling-item
-- ======================================================================

/*
Find the best-selling item for each month (no need to separate months by year). The best-selling item is determined by the highest total sales amount, calculated as: total_paid = unitprice * quantity. A negative quantity indicates a return or cancellation (the invoice number begins with 'C'. To calculate sales, ignore returns and cancellations. Output the month, description of the item, and the total amount paid.
*/

-- Tables:
--   online_retail(country text, customerid double precision, description text, invoicedate date, invoiceno text, quantity bigint, stockcode text, unitprice double precision)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH monthly_sales AS (
    SELECT
        EXTRACT(MONTH FROM invoicedate)::INT AS month,
        description,
        SUM(unitprice * quantity) AS total_paid
    FROM invoices
    WHERE invoiceno NOT LIKE 'C%'  -- exclude cancellations/returns
      AND quantity > 0             -- extra guard for negative quantities
    GROUP BY month, description
),
ranked AS (
    SELECT
        month,
        description,
        total_paid,
        RANK() OVER (PARTITION BY month ORDER BY total_paid DESC) AS rnk
    FROM monthly_sales
)
SELECT
    month,
    description,
    total_paid
FROM ranked
WHERE rnk = 1
ORDER BY month;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    ms.month,
    ms.description,
    ms.total_paid
FROM (
    SELECT
        EXTRACT(MONTH FROM invoicedate)::INT AS month,
        description,
        SUM(unitprice * quantity) AS total_paid
    FROM invoices
    WHERE invoiceno NOT LIKE 'C%'
      AND quantity > 0
    GROUP BY EXTRACT(MONTH FROM invoicedate)::INT, description
) AS ms
-- keep only rows where total_paid equals the max for that month
WHERE ms.total_paid = (
    SELECT MAX(sub.total_paid)
    FROM (
        SELECT
            EXTRACT(MONTH FROM invoicedate)::INT AS month,
            SUM(unitprice * quantity) AS total_paid
        FROM invoices
        WHERE invoiceno NOT LIKE 'C%'
          AND quantity > 0
        GROUP BY EXTRACT(MONTH FROM invoicedate)::INT, description
    ) AS sub
    WHERE sub.month = ms.month
)
ORDER BY ms.month;
