-- ======================================================================
-- Common Interests Amongst Users
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Meta
-- Access     : Premium
-- ID         : 9776
-- URL        : https://platform.stratascratch.com/coding/9776-common-interests-amongst-users
-- ======================================================================

/*
Count the subpopulations across datasets. Assume that a subpopulation is a group of users sharing a common interest (ex: Basketball, Food). Output the percentage of overlapping interests for two posters along with those poster's IDs. Calculate the percentage from the number of poster's interests. The poster column in the dataset refers to the user that posted the comment.
*/

-- Tables:
--   facebook_posts(post_date date, post_id bigint, post_keywords text, post_text text, poster bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH user_interests AS (
    -- Get distinct user-interest pairs
    SELECT DISTINCT poster, interest
    FROM public.comments
),
user_interest_counts AS (
    -- Count total interests per user
    SELECT poster, COUNT(interest) AS total_interests
    FROM user_interests
    GROUP BY poster
),
interest_pairs AS (
    -- Self-join to find overlapping interests between pairs of users
    SELECT 
        a.poster AS poster_a,
        b.poster AS poster_b,
        COUNT(*) AS shared_interests
    FROM user_interests a
    JOIN user_interests b 
        ON a.interest = b.interest 
        AND a.poster < b.poster  -- avoid duplicates and self-pairs
    GROUP BY a.poster, b.poster
)
SELECT 
    ip.poster_a,
    ip.poster_b,
    ip.shared_interests,
    ca.total_interests AS poster_a_interests,
    cb.total_interests AS poster_b_interests,
    -- Percentage of overlap relative to total unique interests between both posters
    ROUND(
        100.0 * ip.shared_interests / 
        (ca.total_interests + cb.total_interests - ip.shared_interests), 
    2) AS overlap_percentage
FROM interest_pairs ip
JOIN user_interest_counts ca ON ip.poster_a = ca.poster
JOIN user_interest_counts cb ON ip.poster_b = cb.poster
ORDER BY overlap_percentage DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    a.poster AS poster_a,
    b.poster AS poster_b,
    COUNT(*) AS shared_interests,
    -- Total interests for poster_a
    (SELECT COUNT(DISTINCT c1.interest) 
     FROM public.comments c1 
     WHERE c1.poster = a.poster) AS poster_a_interests,
    -- Total interests for poster_b
    (SELECT COUNT(DISTINCT c2.interest) 
     FROM public.comments c2 
     WHERE c2.poster = b.poster) AS poster_b_interests,
    -- Overlap percentage using union count (total unique interests across both)
    ROUND(
        100.0 * COUNT(*) / (
            (SELECT COUNT(DISTINCT c1.interest) FROM public.comments c1 WHERE c1.poster = a.poster) +
            (SELECT COUNT(DISTINCT c2.interest) FROM public.comments c2 WHERE c2.poster = b.poster) -
            COUNT(*)
        ), 
    2) AS overlap_percentage
FROM 
    (SELECT DISTINCT poster, interest FROM public.comments) a
JOIN 
    (SELECT DISTINCT poster, interest FROM public.comments) b
    ON a.interest = b.interest 
    AND a.poster < b.poster  -- ensure unique pairs only
GROUP BY 
    a.poster, b.poster
ORDER BY 
    overlap_percentage DESC;
