-- ======================================================================
-- Book Sales
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Amazon
-- Access     : Premium
-- ID         : 2128
-- URL        : https://platform.stratascratch.com/coding/2128-book-sales
-- ======================================================================

/*
Calculate the total revenue made per book. Output the book ID and total sales per book. In case there is a book that has never been sold, include it in your output with a value of 0.
*/

-- Tables:
--   amazon_books(book_id text, book_title text, unit_price bigint)
--   amazon_books_order_details(book_id text, order_details_id text, order_id text, quantity bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT 
    b.book_id,
    COALESCE(SUM(o.quantity * o.unit_price), 0) AS total_revenue
FROM books b
LEFT JOIN orders o ON b.book_id = o.book_id
GROUP BY b.book_id
ORDER BY b.book_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    b.book_id,
    COALESCE(
        (SELECT SUM(o.quantity * o.unit_price)
         FROM orders o
         WHERE o.book_id = b.book_id),
        0
    ) AS total_revenue
FROM books b
ORDER BY b.book_id;
