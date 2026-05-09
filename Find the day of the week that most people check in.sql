-- ======================================================================
-- Find the day of the week that most people check in
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Airbnb
-- Access     : Premium
-- ID         : 9762
-- URL        : https://platform.stratascratch.com/coding/9762-find-the-day-of-the-week-that-most-people-check-in
-- ======================================================================

/*
Find the day of the week that most people want to check in.

Output the day of the week alongside the corresponding check-in count.
*/

-- Tables:
--   airbnb_contacts(ds_checkin date, ds_checkout date, id_guest text, id_host text, id_listing text, n_guests bigint, n_messages bigint, ts_accepted_at timestamp without time zone, ts_booking_at timestamp without time zone, ts_contact_at timestamp without time zone, ts_reply_at timestamp without time zone)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH daily_counts AS (
    SELECT
        TO_CHAR(checkin_date, 'Day') AS day_of_week,
        EXTRACT(DOW FROM checkin_date) AS day_num,  -- for ordering Sun=0..Sat=6
        COUNT(*) AS checkin_count
    FROM airbnb_contacts
    GROUP BY day_of_week, day_num
),
ranked AS (
    SELECT
        day_of_week,
        checkin_count,
        RANK() OVER (ORDER BY checkin_count DESC) AS rnk
    FROM daily_counts
)
SELECT
    TRIM(day_of_week) AS day_of_week,
    checkin_count
FROM ranked
WHERE rnk = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    TRIM(TO_CHAR(checkin_date, 'Day')) AS day_of_week,
    COUNT(*) AS checkin_count
FROM airbnb_contacts
GROUP BY TO_CHAR(checkin_date, 'Day')
HAVING COUNT(*) = (
    SELECT MAX(cnt)
    FROM (
        SELECT COUNT(*) AS cnt
        FROM airbnb_contacts
        GROUP BY TO_CHAR(checkin_date, 'Day')
    ) sub
);
