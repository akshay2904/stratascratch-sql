-- ======================================================================
-- Algorithm Performance
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Meta
-- Access     : Premium
-- ID         : 10350
-- URL        : https://platform.stratascratch.com/coding/10350-algorithm-performance
-- ======================================================================

/*
Meta/Facebook is developing a search algorithm that will allow users to search through their post history. You have been assigned to evaluate the performance of this algorithm.




We have a table with the user's search term, search result positions, and whether or not the user clicked on the search result.




Write a query that assigns ratings to the searches in the following way:

•	If the search was not clicked for any term, assign the search with rating=1

•	If the search was clicked but the top position of clicked terms was outside the top 3 positions, assign the search a rating=2

•	If the search was clicked and the top position of a clicked term was in the top 3 positions, assign the search a rating=3




As a search ID can contain more than one search term, select the highest rating for that search ID. Output the search ID and its highest rating.




Example: The search_id 1 was clicked (clicked = 1) and its position is outside of the top 3 positions (search_results_position = 5), therefore its rating is 2.
*/

-- Tables:
--   fb_search_events(clicked bigint, search_id bigint, search_results_position bigint, search_term text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH search_ratings AS (
    SELECT
        search_id,
        search_term,
        -- Determine rating per search_term group
        CASE
            WHEN MAX(clicked) = 0 THEN 1  -- never clicked
            WHEN MAX(clicked) = 1 AND MIN(CASE WHEN clicked = 1 THEN search_results_position END) > 3 THEN 2  -- clicked but not in top 3
            WHEN MAX(clicked) = 1 AND MIN(CASE WHEN clicked = 1 THEN search_results_position END) <= 3 THEN 3  -- clicked in top 3
        END AS rating
    FROM facebook_searches
    GROUP BY search_id, search_term
)
SELECT
    search_id,
    MAX(rating) AS rating  -- highest rating per search_id
FROM search_ratings
GROUP BY search_id
ORDER BY search_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    search_id,
    MAX(rating) AS rating
FROM (
    -- Rating 1: search_term was never clicked
    SELECT
        search_id,
        search_term,
        1 AS rating
    FROM facebook_searches
    GROUP BY search_id, search_term
    HAVING MAX(clicked) = 0

    UNION ALL

    -- Rating 2: clicked but best clicked position is outside top 3
    SELECT
        search_id,
        search_term,
        2 AS rating
    FROM facebook_searches
    GROUP BY search_id, search_term
    HAVING MAX(clicked) = 1
       AND MIN(CASE WHEN clicked = 1 THEN search_results_position END) > 3

    UNION ALL

    -- Rating 3: clicked and best clicked position is within top 3
    SELECT
        search_id,
        search_term,
        3 AS rating
    FROM facebook_searches
    GROUP BY search_id, search_term
    HAVING MAX(clicked) = 1
       AND MIN(CASE WHEN clicked = 1 THEN search_results_position END) <= 3
) AS term_ratings
GROUP BY search_id
ORDER BY search_id;
