-- ======================================================================
-- Favorite Host Nationality
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Airbnb
-- Access     : Premium
-- ID         : 10073
-- URL        : https://platform.stratascratch.com/coding/10073-favorite-host-nationality
-- ======================================================================

/*
For each guest reviewer, find the nationality of the reviewer’s favorite host based on the guest’s highest review score given to a host. Output the user ID of the guest along with their favorite host’s nationality. In case there is more than one favorite host from the same country, list that country only once (remove duplicates).




Both the from_user and to_user columns are user IDs.
*/

-- Tables:
--   airbnb_reviews(from_type text, from_user bigint, review_score bigint, to_type text, to_user bigint)
--   airbnb_hosts(age bigint, gender text, host_id bigint, nationality text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH max_scores AS (
    -- For each guest, find their maximum review score given to any host
    SELECT
        from_user,
        MAX(review_score) AS max_score
    FROM
        airbnb_reviews
    WHERE
        from_type = 'guest'
    GROUP BY
        from_user
),
top_hosts AS (
    -- Get all host records where the guest gave their max score
    SELECT DISTINCT
        r.from_user AS guest_id,
        r.to_user   AS host_id
    FROM
        airbnb_reviews r
    JOIN max_scores ms
        ON r.from_user = ms.from_user
       AND r.review_score = ms.max_score
    WHERE
        r.from_type = 'guest'
)
-- Join to get host nationality, deduplicate by (guest, nationality)
SELECT DISTINCT
    th.guest_id,
    u.nationality
FROM
    top_hosts th
JOIN airbnb_users u
    ON th.host_id = u.id
ORDER BY
    th.guest_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT DISTINCT
    r.from_user AS guest_id,
    u.nationality
FROM
    airbnb_reviews r
JOIN airbnb_users u
    ON r.to_user = u.id
WHERE
    r.from_type = 'guest'
    AND r.review_score = (
        -- Subquery: max score this guest has ever given to a host
        SELECT MAX(r2.review_score)
        FROM airbnb_reviews r2
        WHERE r2.from_user = r.from_user
          AND r2.from_type = 'guest'
    )
ORDER BY
    guest_id;
