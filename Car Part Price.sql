-- ======================================================================
-- Car Part Price
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Tesla, Amazon, Ebay
-- Access     : Premium
-- ID         : 10570
-- URL        : https://platform.stratascratch.com/coding/10570-car-part-price
-- ======================================================================

/*
An automotive parts supplier maintains a database of car part prices across different model years. As parts are redesigned or manufacturing costs change, prices fluctuate from year to year. The procurement team needs to analyze these price trends to identify which parts have seen the most significant price increases or decreases.




Calculate the price change for each car part compared to its previous model year. The price change should show the difference in dollars (current price minus previous price). For the first occurrence of each part, the price change should be NULL since there's no prior data to compare against. Return all columns from the original table plus a column showing the change from the previous model year.




If the dataset contains duplicates, remove them before calculating price changes, keeping only one entry per unique car_part_id, model_year combination. Note that some parts may have gaps in their model year sequences. In these cases, calculate the price change against whichever entry comes immediately before in the dataset, regardless of how many years have passed.
*/

-- Tables:
--   car_parts(car_part_id text, model_year bigint, price double precision)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH deduped AS (
    -- Remove duplicates, keeping one row per (car_part_id, model_year)
    SELECT DISTINCT ON (car_part_id, model_year)
        car_part_id,
        model_year,
        price
    FROM car_parts
    ORDER BY car_part_id, model_year
)
SELECT
    car_part_id,
    model_year,
    price,
    price - LAG(price) OVER (
        PARTITION BY car_part_id
        ORDER BY model_year
    ) AS price_change
FROM deduped
ORDER BY car_part_id, model_year;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH deduped AS (
    -- Remove duplicates by selecting min price (or any deterministic value)
    SELECT
        car_part_id,
        model_year,
        MIN(price) AS price
    FROM car_parts
    GROUP BY car_part_id, model_year
),
ranked AS (
    -- Assign a sequential rank within each part ordered by model_year
    SELECT
        d1.car_part_id,
        d1.model_year,
        d1.price,
        -- Count how many earlier years exist for this part to simulate row number
        (SELECT COUNT(*)
         FROM deduped d2
         WHERE d2.car_part_id = d1.car_part_id
           AND d2.model_year < d1.model_year) AS prior_count
    FROM deduped d1
),
prev_price AS (
    -- For each row, find the immediately preceding model year's price
    SELECT
        r.car_part_id,
        r.model_year,
        r.price,
        -- Get price of the row that is exactly one step behind (max year < current year)
        (SELECT d.price
         FROM deduped d
         WHERE d.car_part_id = r.car_part_id
           AND d.model_year = (
               SELECT MAX(d2.model_year)
               FROM deduped d2
               WHERE d2.car_part_id = r.car_part_id
                 AND d2.model_year < r.model_year
           )
        ) AS prev_price
    FROM ranked r
)
SELECT
    car_part_id,
    model_year,
    price,
    -- NULL when no previous year exists (prior_count = 0)
    CASE
        WHEN prev_price IS NULL THEN NULL
        ELSE price - prev_price
    END AS price_change
FROM prev_price
ORDER BY car_part_id, model_year;
