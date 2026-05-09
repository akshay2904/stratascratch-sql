-- ======================================================================
-- Wine Variety Revenues
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Wine Magazine
-- Access     : Premium
-- ID         : 10033
-- URL        : https://platform.stratascratch.com/coding/10033-wine-variety-revenues
-- ======================================================================

/*
You have a dataset containing information about wines, including their regions, varieties, and prices. Some wines have two regions listed (region_1 and region_2). Calculate the total cost of wines for each combination of region and variety, using both region columns.




Because there are two regions listed, first combine the data from both region columns, making sure to remove any duplicate entries and excluding any records with missing prices or regions. Then, sum the prices for each unique combination of region and variety and present the results, showing the region, variety, and total price. Order the final result from the highest total price to the lowest.
*/

-- Tables:
--   winemag_p1(country text, description text, designation text, id bigint, points bigint, price double precision, province text, region_1 text, region_2 text, variety text, winery text)


-- Write your SQL solution below:
