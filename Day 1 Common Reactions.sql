-- ======================================================================
-- Day 1 Common Reactions
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 9773
-- URL        : https://platform.stratascratch.com/coding/9773-day-1-common-reactions
-- ======================================================================

/*
Find the most common reaction for day 1 by counting the number of occurrences for each reaction. Output the reaction alongside its number of occurrences.
*/

-- Tables:
--   facebook_reactions(date_day bigint, friend bigint, post_id bigint, poster bigint, reaction text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH reaction_counts AS (
    SELECT 
        reaction,
        COUNT(*) AS occurrences,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS rnk
    FROM facebook_reactions
    WHERE day = 1
    GROUP BY reaction
)
SELECT reaction, occurrences
FROM reaction_counts
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT reaction, COUNT(*) AS occurrences
FROM facebook_reactions
WHERE day = 1
GROUP BY reaction
HAVING COUNT(*) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM facebook_reactions
        WHERE day = 1
        GROUP BY reaction
    ) sub
);
