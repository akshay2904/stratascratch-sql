-- ======================================================================
-- Clicked Vs Non-Clicked Search Results
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 10288
-- URL        : https://platform.stratascratch.com/coding/10288-clicked-vs-non-clicked-search-results
-- ======================================================================

/*
The question asks you to calculate two percentages based on search result records. For the first percentage, find the percentage of records where a search result was clicked on in the top 3 positions. Records that were clicked will have clicked = 1. Use the search_results_position to find the position of the search result. For the second percentage: find the percentage of records that were not clicked on in the top 3 positions. Both percentages are calculated with respect to the total number of search result records and should be output in the same row as two columns.
*/

-- Tables:
--   fb_search_events(clicked bigint, search_id bigint, search_results_position bigint, search_term text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT
    ROUND(
        100.0 * SUM(CASE WHEN search_results_position <= 3 AND clicked = 1 THEN 1 ELSE 0 END) 
        / COUNT(*), 2
    ) AS clicked_top3_pct,
    ROUND(
        100.0 * SUM(CASE WHEN search_results_position <= 3 AND clicked = 0 THEN 1 ELSE 0 END) 
        / COUNT(*), 2
    ) AS not_clicked_top3_pct
FROM search_results;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    ROUND(
        100.0 * (
            SELECT COUNT(*) 
            FROM search_results 
            WHERE search_results_position <= 3 
              AND clicked = 1
        ) / (SELECT COUNT(*) FROM search_results), 2
    ) AS clicked_top3_pct,
    ROUND(
        100.0 * (
            SELECT COUNT(*) 
            FROM search_results 
            WHERE search_results_position <= 3 
              AND clicked = 0
        ) / (SELECT COUNT(*) FROM search_results), 2
    ) AS not_clicked_top3_pct;
