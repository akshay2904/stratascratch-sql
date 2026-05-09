-- ======================================================================
-- Successful Customer Sign Up Responses
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Amazon, Shopify
-- Access     : Premium
-- ID         : 2152
-- URL        : https://platform.stratascratch.com/coding/2152-successful-customer-sign-up-responses
-- ======================================================================

/*
It's time to find out who is the top employee. You've been tasked with finding the employee (or employees, in the case of a tie) who have received the most votes.




A vote is recorded when a customer leaves their 10-digit phone number in the free text customer_response column of their sign up response (occurrence of any number sequence with exactly 10 digits is considered as a phone number)




Output the top employee and the number of customer responses that left a number.
*/

-- Tables:
--   customer_responses(customer_response text, employee_id bigint, response_date timestamp without time zone)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH vote_counts AS (
    SELECT 
        employee_id,
        COUNT(*) AS vote_count,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM customer_responses
    WHERE customer_response ~ '\b\d{10}\b'  -- exactly 10 consecutive digits
    GROUP BY employee_id
)
SELECT 
    e.employee_id,
    e.employee_name,
    vc.vote_count
FROM vote_counts vc
JOIN employees e ON e.employee_id = vc.employee_id
WHERE vc.rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    e.employee_id,
    e.employee_name,
    counts.vote_count
FROM employees e
JOIN (
    SELECT 
        employee_id,
        COUNT(*) AS vote_count
    FROM customer_responses
    WHERE customer_response ~ '\b\d{10}\b'
    GROUP BY employee_id
) counts ON e.employee_id = counts.employee_id
WHERE counts.vote_count = (
    SELECT MAX(vote_count)
    FROM (
        SELECT COUNT(*) AS vote_count
        FROM customer_responses
        WHERE customer_response ~ '\b\d{10}\b'
        GROUP BY employee_id
    ) sub
);
