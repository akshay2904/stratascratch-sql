-- ======================================================================
-- Find the countries with the most positive reviews
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Airbnb
-- Access     : Premium
-- ID         : 9879
-- URL        : https://platform.stratascratch.com/coding/9879-find-the-countries-with-the-most-positive-reviews
-- ======================================================================

/*
Find the countries whose reviewers give positive reviews. Positive reviews are all reviews where review text is different than "No Positive".




Output all countries along with the number of positive reviews and sort records based on the number of positive reviews in descending order. Leave out the countries with no positive reviews.
*/

-- Tables:
--   hotel_reviews(additional_number_of_scoring bigint, average_score double precision, days_since_review text, hotel_address text, hotel_name text, lat double precision, lng double precision, negative_review text, positive_review text, review_date date, review_total_negative_word_counts bigint, review_total_positive_word_counts bigint, reviewer_nationality text, reviewer_score double precision, tags text, total_number_of_reviews bigint, total_number_of_reviews_reviewer_has_given bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT 
    h.country,
    COUNT(*) AS positive_reviews
FROM reviews r
JOIN hotels h ON r.hotel_id = h.hotel_id
WHERE r.review_text_positive <> 'No Positive'
GROUP BY h.country
ORDER BY positive_reviews DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    h.country,
    (
        SELECT COUNT(*)
        FROM reviews r
        WHERE r.hotel_id = h.hotel_id
          AND r.review_text_positive <> 'No Positive'
    ) AS positive_reviews
FROM hotels h
GROUP BY h.country
HAVING (
    SELECT COUNT(*)
    FROM reviews r
    WHERE r.hotel_id IN (
        SELECT hotel_id FROM hotels WHERE country = h.country
    )
    AND r.review_text_positive <> 'No Positive'
) > 0
ORDER BY positive_reviews DESC;
