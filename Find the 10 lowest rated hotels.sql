-- ======================================================================
-- Find the 10 lowest rated hotels.
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google, Airbnb
-- Access     : Premium
-- ID         : 9875
-- URL        : https://platform.stratascratch.com/coding/9875-find-the-ten-hotels-with-the-lowest-ratings
-- ======================================================================

/*
Find the 10 lowest rated hotels based on the score already provided for each hotel in the dataset. Output the hotel name along with that score. If multiple hotels are tied at the cutoff, include all tied hotels.
*/

-- Tables:
--   hotel_reviews(additional_number_of_scoring bigint, average_score double precision, days_since_review text, hotel_address text, hotel_name text, lat double precision, lng double precision, negative_review text, positive_review text, review_date date, review_total_negative_word_counts bigint, review_total_positive_word_counts bigint, reviewer_nationality text, reviewer_score double precision, tags text, total_number_of_reviews bigint, total_number_of_reviews_reviewer_has_given bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_hotels AS (
    SELECT
        hotel_name,
        score,
        DENSE_RANK() OVER (ORDER BY score ASC) AS rnk
    FROM hotels
)
SELECT
    hotel_name,
    score
FROM ranked_hotels
WHERE rnk <= 10
ORDER BY score ASC, hotel_name;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    hotel_name,
    score
FROM hotels
WHERE score <= (
    -- Find the 10th lowest distinct score
    SELECT MIN(cutoff_score)
    FROM (
        SELECT DISTINCT score AS cutoff_score
        FROM hotels
        ORDER BY score ASC
        LIMIT 10
    ) AS top10_scores
)
ORDER BY score ASC, hotel_name;
