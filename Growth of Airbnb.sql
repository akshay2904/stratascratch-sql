-- ======================================================================
-- Growth of Airbnb
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Airbnb
-- Access     : Premium
-- ID         : 9637
-- URL        : https://platform.stratascratch.com/coding/9637-growth-of-airbnb
-- ======================================================================

/*
Calculate Airbnb's annual growth rate using the number of registered hosts as the key metric. The growth rate is determined by:




Growth Rate = ((Number of hosts registered in the current year - number of hosts registered in the previous year) / number of hosts registered in the previous year) * 100




Output the year, number of hosts in the current year, number of hosts in the previous year, and the growth rate. Round the growth rate to the nearest percent. Sort the results in ascending order by year.




Assume that the dataset consists only of unique hosts, meaning there are no duplicate hosts listed.
*/

-- Tables:
--   airbnb_search_details(accommodates bigint, amenities text, bathrooms bigint, bed_type text, bedrooms bigint, beds bigint, cancellation_policy text, city text, cleaning_fee boolean, host_identity_verified text, host_response_rate text, host_since date, id bigint, neighbourhood text, number_of_reviews bigint, price double precision, property_type text, review_scores_rating double precision, room_type text, zipcode bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH yearly_hosts AS (
    SELECT
        EXTRACT(YEAR FROM host_since)::INT AS year,
        COUNT(*) AS num_hosts
    FROM airbnb_search_details
    WHERE host_since IS NOT NULL
    GROUP BY EXTRACT(YEAR FROM host_since)
)
SELECT
    year,
    num_hosts AS current_year_hosts,
    LAG(num_hosts) OVER (ORDER BY year) AS prev_year_hosts,
    ROUND(
        (num_hosts - LAG(num_hosts) OVER (ORDER BY year))::NUMERIC
        / LAG(num_hosts) OVER (ORDER BY year) * 100
    ) AS growth_rate
FROM yearly_hosts
ORDER BY year;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

WITH yearly_hosts AS (
    SELECT
        EXTRACT(YEAR FROM host_since)::INT AS year,
        COUNT(*) AS num_hosts
    FROM airbnb_search_details
    WHERE host_since IS NOT NULL
    GROUP BY EXTRACT(YEAR FROM host_since)
)
SELECT
    curr.year,
    curr.num_hosts AS current_year_hosts,
    prev.num_hosts AS prev_year_hosts,
    ROUND(
        (curr.num_hosts - prev.num_hosts)::NUMERIC
        / prev.num_hosts * 100
    ) AS growth_rate
FROM yearly_hosts curr
JOIN yearly_hosts prev
    ON curr.year = prev.year + 1
ORDER BY curr.year;
