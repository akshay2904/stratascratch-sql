-- ======================================================================
-- Find the average difference between booking and check-in dates
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Airbnb
-- Access     : Premium
-- ID         : 9614
-- URL        : https://platform.stratascratch.com/coding/9614-find-the-average-difference-between-booking-and-check-in-dates
-- ======================================================================

/*
Find the average number of days between the booking and check-in dates for AirBnB hosts. Order the results based on the average number of days in descending order.
avg_days_between_booking_and_checkin DESC
*/

-- Tables:
--   airbnb_contacts(ds_checkin date, ds_checkout date, id_guest text, id_host text, id_listing text, n_guests bigint, n_messages bigint, ts_accepted_at timestamp without time zone, ts_booking_at timestamp without time zone, ts_contact_at timestamp without time zone, ts_reply_at timestamp without time zone)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

SELECT 
    host_id,
    AVG(checkin_date::date - booking_date::date) AS avg_days_between_booking_and_checkin
FROM airbnb_contacts
WHERE checkin_date IS NOT NULL 
  AND booking_date IS NOT NULL
GROUP BY host_id
ORDER BY avg_days_between_booking_and_checkin DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    host_id,
    AVG(
        EXTRACT(DAY FROM (checkin_date::timestamp - booking_date::timestamp))
    ) AS avg_days_between_booking_and_checkin
FROM (
    SELECT 
        host_id,
        checkin_date,
        booking_date
    FROM airbnb_contacts
    WHERE checkin_date IS NOT NULL 
      AND booking_date IS NOT NULL
) AS filtered_contacts
GROUP BY host_id
ORDER BY avg_days_between_booking_and_checkin DESC;
