-- ======================================================================
-- Product Transaction Count
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Nvidia, Microsoft
-- Access     : Premium
-- ID         : 10163
-- URL        : https://platform.stratascratch.com/coding/10163-product-transaction-count
-- ======================================================================

/*
Find the number of transactions that occurred for each product. Output the product name along with the corresponding number of transactions and order records by the product id in ascending order. You can ignore products without transactions.
*/

-- Tables:
--   excel_sql_inventory_data(current_inventory bigint, price_unit double precision, product_id bigint, product_name text, product_type text, unit text, wholesale double precision)
--   excel_sql_transaction_data(product_id bigint, time timestamp without time zone, transaction_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    p.name AS product_name,
    COUNT(t.id) AS transaction_count
FROM products p
JOIN transactions t ON p.id = t.product_id
GROUP BY p.id, p.name
ORDER BY p.id ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    p.name AS product_name,
    (
        SELECT COUNT(*)
        FROM transactions t
        WHERE t.product_id = p.id
    ) AS transaction_count
FROM products p
WHERE p.id IN (
    SELECT DISTINCT product_id
    FROM transactions
)
ORDER BY p.id ASC;
