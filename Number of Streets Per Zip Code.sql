-- ======================================================================
-- Number of Streets Per Zip Code
-- ======================================================================
-- Difficulty : Medium
-- Companies  : City of San Francisco
-- Access     : Premium
-- ID         : 10182
-- URL        : https://platform.stratascratch.com/coding/10182-number-of-streets-per-zip-code
-- ======================================================================

/*
Count the number of unique street names for each postal code in the business dataset. Use only the first word of the street name, case insensitive (e.g., "FOLSOM" and "Folsom" are the same). If the structure is reversed (e.g., "Pier 39" and "39 Pier"), count them as the same street. Output the results with postal codes, ordered by the number of streets (descending) and postal code (ascending).
*/

-- Tables:
--   sf_restaurant_health_violations(business_address text, business_city text, business_id bigint, business_latitude double precision, business_location text, business_longitude double precision, business_name text, business_phone_number double precision, business_postal_code double precision, business_state text, inspection_date date, inspection_id text, inspection_score double precision, inspection_type text, risk_category text, violation_description text, violation_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH normalized AS (
    SELECT
        postal_code,
        -- Extract first word of street name, lowercased
        LOWER(SPLIT_PART(TRIM(address), ' ', 1)) AS first_word
    FROM business
    WHERE postal_code IS NOT NULL
      AND address IS NOT NULL
      AND TRIM(address) <> ''
),
-- Handle reversed structure: sort the first word and a numeric-check token
-- If first word is numeric, swap with second word to normalize "39 Pier" -> "pier"
deduplicated AS (
    SELECT
        postal_code,
        CASE
            -- If first word is purely numeric, use the second word as the canonical key
            WHEN first_word ~ '^\d+$' THEN LOWER(SPLIT_PART(TRIM(address), ' ', 2))
            ELSE first_word
        END AS canonical_street
    FROM normalized
    JOIN business b ON b.postal_code = normalized.postal_code  -- re-access address
),
-- Actually redo this cleanly with a single pass
canonical AS (
    SELECT
        postal_code,
        CASE
            WHEN LOWER(SPLIT_PART(TRIM(address), ' ', 1)) ~ '^\d+$'
                THEN LOWER(SPLIT_PART(TRIM(address), ' ', 2))
            ELSE LOWER(SPLIT_PART(TRIM(address), ' ', 1))
        END AS canonical_street
    FROM business
    WHERE postal_code IS NOT NULL
      AND address IS NOT NULL
      AND TRIM(address) <> ''
),
street_counts AS (
    SELECT
        postal_code,
        COUNT(DISTINCT canonical_street) AS num_streets
    FROM canonical
    GROUP BY postal_code
)
SELECT
    postal_code,
    num_streets
FROM street_counts
ORDER BY num_streets DESC, postal_code ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    postal_code,
    COUNT(DISTINCT
        CASE
            -- If the first word of address is numeric, use the second word instead
            WHEN LOWER(SPLIT_PART(TRIM(address), ' ', 1)) ~ '^\d+$'
                THEN LOWER(SPLIT_PART(TRIM(address), ' ', 2))
            ELSE
                LOWER(SPLIT_PART(TRIM(address), ' ', 1))
        END
    ) AS num_streets
FROM business
WHERE postal_code IS NOT NULL
  AND address IS NOT NULL
  AND TRIM(address) <> ''
GROUP BY postal_code
ORDER BY num_streets DESC, postal_code ASC;
