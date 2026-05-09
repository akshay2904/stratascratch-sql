-- ======================================================================
-- Find the average age of guests reviewed by each host
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Airbnb
-- Access     : Premium
-- ID         : 10074
-- URL        : https://platform.stratascratch.com/coding/10074-find-the-average-age-of-guests-reviewed-by-each-host
-- ======================================================================

/*
Find the average age of guests reviewed by each host.
Output the user along with the average age.
*/

-- Tables:
--   airbnb_reviews(from_type text, from_user bigint, review_score bigint, to_type text, to_user bigint)
--   airbnb_guests(age bigint, gender text, guest_id bigint, nationality text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH host_guest_ages AS (
    SELECT 
        r.from_user_id AS host_id,
        AVG(u.age) OVER (PARTITION BY r.from_user_id) AS avg_guest_age
    FROM airbnb_reviews r
    JOIN airbnb_users u 
        ON r.to_user_id = u.user_id
    WHERE r.from_type = 'host'  -- host is reviewing a guest
)
SELECT DISTINCT
    host_id,
    avg_guest_age
FROM host_guest_ages;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    r.from_user_id AS host_id,
    AVG(u.age) AS avg_guest_age
FROM airbnb_reviews r
JOIN airbnb_users u 
    ON r.to_user_id = u.user_id
WHERE r.from_type = 'host'  -- only rows where a host reviewed a guest
GROUP BY r.from_user_id;
