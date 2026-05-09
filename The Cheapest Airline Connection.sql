-- ======================================================================
-- The Cheapest Airline Connection
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Delta Airlines
-- Access     : Premium
-- ID         : 2008
-- URL        : https://platform.stratascratch.com/coding/2008-the-cheapest-airline-connection
-- ======================================================================

/*
COMPANY X employees are trying to find the cheapest flights to upcoming conferences.




When people fly long distances, a direct city-to-city flight is often more expensive than taking two flights with a stop in a hub city. Travelers might save even more money by breaking the trip into three flights with two stops. But for the purposes of this challenge, let's assume that no one is willing to stop three times. The table contains the following columns:

•   id - the unique ID of the flight;

•   origin - the origin city of the current flight;

•   destination - the destination city of the current flight;

•    cost - the cost of current flight.




Your task is to produce a trips table listing the cheapest possible trips between all origin-destination pairs present in the dataset, considering routes with up to two stops.




This table should have the columns origin, destination, and min_price (cheapest one). Sort the output table by origin, then by destination.




The cities are all represented by three-letter uppercase abbreviations.




Note: A flight from SFO to JFK is considered different from a flight from JFK to SFO.
*/

-- Tables:
--   da_flights(cost bigint, destination text, id bigint, origin text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH
-- Direct flights (0 stops)
direct AS (
    SELECT origin, destination, cost AS total_cost
    FROM flights
),
-- One-stop flights (1 intermediate city)
one_stop AS (
    SELECT f1.origin, f2.destination, f1.cost + f2.cost AS total_cost
    FROM flights f1
    JOIN flights f2
        ON f1.destination = f2.origin
        AND f1.origin <> f2.destination  -- avoid going back to origin
),
-- Two-stop flights (2 intermediate cities)
two_stop AS (
    SELECT f1.origin, f3.destination, f1.cost + f2.cost + f3.cost AS total_cost
    FROM flights f1
    JOIN flights f2
        ON f1.destination = f2.origin
        AND f1.origin <> f2.destination
    JOIN flights f3
        ON f2.destination = f3.origin
        AND f3.destination <> f1.origin  -- avoid returning to origin
        AND f3.destination <> f1.destination -- avoid revisiting first stop
),
-- Union all possible routes
all_routes AS (
    SELECT origin, destination, total_cost FROM direct
    UNION ALL
    SELECT origin, destination, total_cost FROM one_stop
    UNION ALL
    SELECT origin, destination, total_cost FROM two_stop
),
-- Find minimum cost per origin-destination pair, excluding same city pairs
ranked AS (
    SELECT
        origin,
        destination,
        MIN(total_cost) AS min_price
    FROM all_routes
    WHERE origin <> destination
    GROUP BY origin, destination
)
SELECT origin, destination, min_price
FROM ranked
ORDER BY origin, destination;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    combined.origin,
    combined.destination,
    MIN(combined.total_cost) AS min_price
FROM (
    -- Direct flights
    SELECT
        origin,
        destination,
        cost AS total_cost
    FROM flights
    WHERE origin <> destination

    UNION ALL

    -- One-stop flights
    SELECT
        f1.origin,
        f2.destination,
        f1.cost + f2.cost AS total_cost
    FROM flights f1, flights f2
    WHERE f1.destination = f2.origin
      AND f1.origin <> f2.destination
      AND f1.origin <> f1.destination
      AND f2.origin <> f2.destination

    UNION ALL

    -- Two-stop flights
    SELECT
        f1.origin,
        f3.destination,
        f1.cost + f2.cost + f3.cost AS total_cost
    FROM flights f1, flights f2, flights f3
    WHERE f1.destination = f2.origin
      AND f2.destination = f3.origin
      AND f1.origin <> f2.destination   -- don't loop back to start at stop 1
      AND f1.origin <> f3.destination   -- don't loop back to start at stop 2
      AND f1.destination <> f3.destination -- stops must be different cities
) AS combined
GROUP BY combined.origin, combined.destination
ORDER BY combined.origin, combined.destination;
