-- ======================================================================
-- Countries With Most Negative Reviews
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google, Airbnb
-- Access     : Premium
-- ID         : 9878
-- URL        : https://platform.stratascratch.com/coding/9878-countries-with-most-negative-reviews
-- ======================================================================

/*
Find the countries whose citizens made the highest number of negative reviews. Output the country along with the number of negative reviews and sort records based on the number of negative reviews in descending order. Review is not negative if value negative value column equals to "No Negative". You can ignore countries with no negative reviews.
*/

-- Tables:
--   hotel_reviews(additional_number_of_scoring bigint, average_score double precision, days_since_review text, hotel_address text, hotel_name text, lat double precision, lng double precision, negative_review text, positive_review text, review_date date, review_total_negative_word_counts bigint, review_total_positive_word_counts bigint, reviewer_nationality text, reviewer_score double precision, tags text, total_number_of_reviews bigint, total_number_of_reviews_reviewer_has_given bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH negative_reviews AS (
    SELECT 
        r.reviewer_nationality,
        COUNT(*) AS num_negative_reviews
    FROM hotel_reviews r
    WHERE TRIM(r.negative_review) <> 'No Negative'
    GROUP BY r.reviewer_nationality
)
SELECT 
    reviewer_nationality,
    num_negative_reviews
FROM negative_reviews
ORDER BY num_negative_reviews DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    reviewer_nationality,
    COUNT(*) AS num_negative_reviews
FROM hotel_reviews
WHERE TRIM(negative_review) <> 'No Negative'
GROUP BY reviewer_nationality
HAVING COUNT(*) > 0
ORDER BY num_negative_reviews DESC;
