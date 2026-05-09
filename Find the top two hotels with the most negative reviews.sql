-- ======================================================================
-- Find the top two hotels with the most negative reviews
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Tripadvisor, Expedia, Airbnb
-- Access     : Premium
-- ID         : 9876
-- URL        : https://platform.stratascratch.com/coding/9876-find-the-top-ten-hotels-with-the-most-negative-reviews-in-summer-june-aug
-- ======================================================================

/*
Find the top two hotels with the most negative reviews.

Output the hotel name along with the corresponding number of negative reviews. Negative reviews are all the reviews with text under negative review different than "No Negative"

Sort records based on the number of negative reviews in descending order.
*/

-- Tables:
--   hotel_reviews(additional_number_of_scoring bigint, average_score double precision, days_since_review text, hotel_address text, hotel_name text, lat double precision, lng double precision, negative_review text, positive_review text, review_date date, review_total_negative_word_counts bigint, review_total_positive_word_counts bigint, reviewer_nationality text, reviewer_score double precision, tags text, total_number_of_reviews bigint, total_number_of_reviews_reviewer_has_given bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked AS (
    SELECT
        hotel_name,
        COUNT(*) AS num_negative_reviews,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM hotel_reviews
    WHERE negative_review <> 'No Negative'
    GROUP BY hotel_name
)
SELECT hotel_name, num_negative_reviews
FROM ranked
WHERE rnk <= 2
ORDER BY num_negative_reviews DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT hotel_name, COUNT(*) AS num_negative_reviews
FROM hotel_reviews
WHERE negative_review <> 'No Negative'
GROUP BY hotel_name
ORDER BY num_negative_reviews DESC
LIMIT 2;
