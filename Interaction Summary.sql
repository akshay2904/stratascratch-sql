-- ======================================================================
-- Interaction Summary
-- ======================================================================
-- Difficulty : Medium
-- Companies  : IBM
-- Access     : Premium
-- ID         : 10542
-- URL        : https://platform.stratascratch.com/coding/10542-interaction-summary
-- ======================================================================

/*
Calculate the total number of interactions and the total number of contents created for each customer. Include all interaction types and content types in your calculations.




Your output should include the customer's ID, the total number of interactions, and the total number of content items.
*/

-- Tables:
--   customer_interactions(customer_id bigint, interaction_date date, interaction_id bigint, interaction_type text)
--   user_content(content_id bigint, content_text text, content_type text, customer_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH interaction_counts AS (
    SELECT customer_id, COUNT(*) AS total_interactions
    FROM interactions
    GROUP BY customer_id
),
content_counts AS (
    SELECT customer_id, COUNT(*) AS total_contents
    FROM contents
    GROUP BY customer_id
),
all_customers AS (
    SELECT customer_id FROM interaction_counts
    UNION
    SELECT customer_id FROM content_counts
)
SELECT
    ac.customer_id,
    COALESCE(ic.total_interactions, 0) AS total_interactions,
    COALESCE(cc.total_contents, 0) AS total_contents
FROM all_customers ac
LEFT JOIN interaction_counts ic ON ac.customer_id = ic.customer_id
LEFT JOIN content_counts cc ON ac.customer_id = cc.customer_id
ORDER BY ac.customer_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    c.customer_id,
    COALESCE(
        (SELECT COUNT(*) FROM interactions i WHERE i.customer_id = c.customer_id), 0
    ) AS total_interactions,
    COALESCE(
        (SELECT COUNT(*) FROM contents ct WHERE ct.customer_id = c.customer_id), 0
    ) AS total_contents
FROM (
    SELECT customer_id FROM interactions
    UNION
    SELECT customer_id FROM contents
) c
ORDER BY c.customer_id;
