-- ======================================================================
-- Google Fit User Tracking
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Google
-- Access     : Premium
-- ID         : 10067
-- URL        : https://platform.stratascratch.com/coding/10067-google-fit-user-tracking
-- ======================================================================

/*
Find the average session distance travelled by Google Fit users based on GPS location data. Calculate the distance for two scenarios:





Taking into consideration the curvature of the earth


Taking into consideration the curvature of the earth as a flat surface





Assume one session distance is the distance between the biggest and the smallest step. If the session has only one step id, discard it from the calculation. Assume that session can't span over multiple days.

Output the average session distances calculated in the two scenarios and the difference between them.




Formula to calculate the distance with the curvature of the earth:





𝑅
=
6371
R=6371


𝜙
1
=
𝑙
𝑎
𝑡
1
×
𝜋
180
ϕ
1
	​

=lat
1
	​

×
180
π
	​



𝜙
2
=
𝑙
𝑎
𝑡
2
×
𝜋
180
ϕ
2
	​

=lat
2
	​

×
180
π
	​



𝑑
=
arccos
⁡
(
sin
⁡
𝜙
1
×
sin
⁡
𝜙
2
+
cos
⁡
𝜙
1
×
cos
⁡
𝜙
2
×
cos
⁡
(
𝑙
𝑜
𝑛
𝑔
𝑖
𝑡
𝑢
𝑑
𝑒
2
×
(
𝜋
/
180
)
−
𝑙
𝑜
𝑛
𝑔
𝑖
𝑡
𝑢
𝑑
𝑒
1
×
(
𝜋
/
180
)
)
)
×
𝑅
d=arccos(sinϕ
1
	​

×sinϕ
2
	​

+cosϕ
1
	​

×cosϕ
2
	​

×cos(longitude2×(π/180)−longitude1×(π/180)))×R





Formula to calculate distance on a flat surface:





𝐷
=
111
D=111


𝑑
=
(
𝑙
𝑎
𝑡
2
−
𝑙
𝑎
𝑡
1
)
2
+
(
𝑙
𝑜
𝑛
2
−
𝑙
𝑜
𝑛
1
)
2
×
𝐷
d=
(lat
2
	​

−lat
1
	​

)
2
+(lon
2
	​

−lon
1
	​

)
2
	​

×D
*/

-- Tables:
--   google_fit_location(altitude double precision, day bigint, latitude double precision, longitude double precision, session_id bigint, step_id bigint, user_id text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH session_extremes AS (
    -- Get min and max step_id per session, filter out single-step sessions
    SELECT
        session_id,
        MIN(step_id) AS min_step,
        MAX(step_id) AS max_step,
        COUNT(DISTINCT step_id) AS step_count
    FROM googlefit
    GROUP BY session_id
    HAVING COUNT(DISTINCT step_id) > 1
),
coords AS (
    -- Join to get lat/lon for both min and max step in each session
    SELECT
        se.session_id,
        g_min.latitude  AS lat1,
        g_min.longitude AS lon1,
        g_max.latitude  AS lat2,
        g_max.longitude AS lon2
    FROM session_extremes se
    JOIN googlefit g_min
        ON g_min.session_id = se.session_id AND g_min.step_id = se.min_step
    JOIN googlefit g_max
        ON g_max.session_id = se.session_id AND g_max.step_id = se.max_step
),
distances AS (
    SELECT
        session_id,
        -- Spherical (curved earth) distance using spherical law of cosines
        ACOS(
            LEAST(1.0, GREATEST(-1.0,
                SIN(lat1 * PI() / 180) * SIN(lat2 * PI() / 180)
                + COS(lat1 * PI() / 180) * COS(lat2 * PI() / 180)
                * COS((lon2 - lon1) * PI() / 180)
            ))
        ) * 6371 AS dist_curved,
        -- Flat surface distance
        SQRT(POWER(lat2 - lat1, 2) + POWER(lon2 - lon1, 2)) * 111 AS dist_flat
    FROM coords
)
SELECT
    AVG(dist_curved)              AS avg_distance_curved,
    AVG(dist_flat)                AS avg_distance_flat,
    AVG(dist_curved) - AVG(dist_flat) AS difference
FROM distances;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    AVG(dist_curved)              AS avg_distance_curved,
    AVG(dist_flat)                AS avg_distance_flat,
    AVG(dist_curved) - AVG(dist_flat) AS difference
FROM (
    SELECT
        g_min.session_id,
        -- Spherical (curved earth) distance
        ACOS(
            LEAST(1.0, GREATEST(-1.0,
                SIN(g_min.latitude * PI() / 180) * SIN(g_max.latitude * PI() / 180)
                + COS(g_min.latitude * PI() / 180) * COS(g_max.latitude * PI() / 180)
                * COS((g_max.longitude - g_min.longitude) * PI() / 180)
            ))
        ) * 6371 AS dist_curved,
        -- Flat surface distance
        SQRT(
            POWER(g_max.latitude  - g_min.latitude,  2) +
            POWER(g_max.longitude - g_min.longitude, 2)
        ) * 111 AS dist_flat
    FROM
        -- Subquery: sessions with more than one distinct step, plus their min/max step ids
        (
            SELECT session_id, MIN(step_id) AS min_step, MAX(step_id) AS max_step
            FROM googlefit
            GROUP BY session_id
            HAVING COUNT(DISTINCT step_id) > 1
        ) AS bounds
    -- Join to retrieve coordinates for the minimum step
    JOIN googlefit g_min
        ON g_min.session_id = bounds.session_id
        AND g_min.step_id   = bounds.min_step
    -- Join to retrieve coordinates for the maximum step
    JOIN googlefit g_max
        ON g_max.session_id = bounds.session_id
        AND g_max.step_id   = bounds.max_step
) AS session_distances;
