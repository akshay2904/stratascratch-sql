-- ======================================================================
-- Third Highest Total Transaction
-- ======================================================================
-- Difficulty : Medium
-- Companies  : American Express
-- Access     : Premium
-- ID         : 2140
-- URL        : https://platform.stratascratch.com/coding/2140-third-highest-total-transaction
-- ======================================================================

/*
American Express is reviewing their customers' transactions, and you have been tasked with locating the customer who has the third highest total transaction amount.




The output should include the customer's id, as well as their first name and last name. For ranking the customers, use type of ranking with no gaps between subsequent ranks.
*/

-- Tables:
--   customers(address text, city text, first_name text, id bigint, last_name text, phone_number text)
--   card_orders(cust_id bigint, order_date text, order_details text, order_id bigint, total_order_cost bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_customers AS (
    SELECT
        c.id,
        c.first_name,
        c.last_name,
        SUM(t.total_amount) AS total_spent,
        DENSE_RANK() OVER (ORDER BY SUM(t.total_amount) DESC) AS rnk
    FROM customers c
    JOIN transactions t ON c.id = t.customer_id
    GROUP BY c.id, c.first_name, c.last_name
)
SELECT
    id,
    first_name,
    last_name
FROM ranked_customers
WHERE rnk = 3;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    c.id,
    c.first_name,
    c.last_name
FROM customers c
JOIN transactions t ON c.id = t.customer_id
GROUP BY c.id, c.first_name, c.last_name
HAVING SUM(t.total_amount) = (
    -- Get the 3rd distinct total amount value using OFFSET
    SELECT DISTINCT total_amount_sum
    FROM (
        SELECT
            customer_id,
            SUM(total_amount) AS total_amount_sum
        FROM transactions
        GROUP BY customer_id
    ) customer_totals
    ORDER BY total_amount_sum DESC
    LIMIT 1 OFFSET 2  -- OFFSET 2 gives us the 3rd highest distinct value
);
