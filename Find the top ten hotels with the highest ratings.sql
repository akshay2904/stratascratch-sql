-- ======================================================================
-- Find the top ten hotels with the highest ratings
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google, Expedia, Airbnb
-- Access     : Premium
-- ID         : 9874
-- URL        : https://platform.stratascratch.com/coding/9874-find-the-top-ten-hotels-with-the-highest-ratings
-- ======================================================================

/*
Find the top ten hotels with the highest ratings. Each row in the dataset represents a review entry, and some hotels may appear multiple times. The average_score column reflects the average rating for the hotel, not the individual reviewer's score.

Output the hotel name along with the corresponding average score. Sort records based on the average score in descending order.
*/

-- Tables:
--   hotel_reviews(additional_number_of_scoring bigint, average_score double precision, days_since_review text, hotel_address text, hotel_name text, lat double precision, lng double precision, negative_review text, positive_review text, review_date date, review_total_negative_word_counts bigint, review_total_positive_word_counts bigint, reviewer_nationality text, reviewer_score double precision, tags text, total_number_of_reviews bigint, total_number_of_reviews_reviewer_has_given bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH distinct_hotels AS (
    SELECT DISTINCT hotel_name, average_score
    FROM hotels
),
ranked AS (
    SELECT hotel_name, average_score,
           RANK() OVER (ORDER BY average_score DESC) AS rnk
    FROM distinct_hotels
)
SELECT hotel_name, average_score
FROM ranked
WHERE rnk <= 10
ORDER BY average_score DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT hotel_name, MAX(average_score) AS average_score
FROM hotels
GROUP BY hotel_name
ORDER BY average_score DESC
LIMIT 10;
