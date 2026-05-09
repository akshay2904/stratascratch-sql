-- ======================================================================
-- Cookbook Recipes
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Ebay, Amazon
-- Access     : Premium
-- ID         : 2089
-- URL        : https://platform.stratascratch.com/coding/2089-cookbook-recipes
-- ======================================================================

/*
You are given a table containing recipe titles and their corresponding page numbers from a cookbook. Your task is to format the data to represent how recipes are distributed across double-page spreads in the book.




Each spread consists of two pages:




⦁   The left page (even-numbered) and its corresponding recipe title (if any).

⦁   The right page (odd-numbered) and its corresponding recipe title (if any).




The output table should contain the following three columns:




⦁   left_page_number – The even-numbered page that starts each double-page spread.

⦁   left_title – The title of the recipe on the left page (if available).

⦁   right_title – The title of the recipe on the right page (if available).




For the  k-th  row (starting from 0):




⦁   The  left_page_number  should be 2 × k.

⦁   The  left_title  should be the title from page 2 × k, or NULL if there is no recipe on that page.

⦁   The  right_title  should be the title from page 2 × k + 1, or NULL if there is no recipe on that page.




Each page contains at most one recipe and  if a page does not contain a recipe, the corresponding title should be NULL. Page 0 (the inside cover) is always empty and included in the output. Only include spreads where at least one of the two pages has a recipe.
*/

-- Tables:
--   cookbook_titles(page_number bigint, title text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH page_pairs AS (
    SELECT
        -- Determine the left (even) page for each recipe's spread
        CASE WHEN page_number % 2 = 0 THEN page_number
             ELSE page_number - 1
        END AS left_page_number,
        CASE WHEN page_number % 2 = 0 THEN title ELSE NULL END AS left_title,
        CASE WHEN page_number % 2 = 1 THEN title ELSE NULL END AS right_title
    FROM recipes
),
spreads AS (
    SELECT
        left_page_number,
        MAX(left_title)  AS left_title,
        MAX(right_title) AS right_title
    FROM page_pairs
    GROUP BY left_page_number
)
SELECT
    left_page_number,
    left_title,
    right_title
FROM spreads
-- Include spread if at least one page has a recipe
WHERE left_title IS NOT NULL OR right_title IS NOT NULL
ORDER BY left_page_number;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    even_pages.left_page_number,
    (SELECT r.title
     FROM recipes r
     WHERE r.page_number = even_pages.left_page_number
     LIMIT 1) AS left_title,
    (SELECT r.title
     FROM recipes r
     WHERE r.page_number = even_pages.left_page_number + 1
     LIMIT 1) AS right_title
FROM (
    -- Generate all unique left (even) page numbers from existing recipe pages
    SELECT DISTINCT
        CASE WHEN page_number % 2 = 0 THEN page_number
             ELSE page_number - 1
        END AS left_page_number
    FROM recipes
) AS even_pages
-- Keep only spreads where at least one page has a recipe
WHERE
    EXISTS (SELECT 1 FROM recipes r WHERE r.page_number = even_pages.left_page_number)
    OR
    EXISTS (SELECT 1 FROM recipes r WHERE r.page_number = even_pages.left_page_number + 1)
ORDER BY even_pages.left_page_number;
