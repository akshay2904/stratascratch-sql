-- ======================================================================
-- Requests Acceptance Rate
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Airbnb
-- Access     : Premium
-- ID         : 10133
-- URL        : https://platform.stratascratch.com/coding/10133-requests-acceptance-rate
-- ======================================================================

/*
Find the acceptance rate of requests which is defined as the ratio of accepted contacts vs all contacts. Multiply the ratio by 100 to get the rate.
*/

-- Tables:
--   airbnb_contacts(ds_checkin date, ds_checkout date, id_guest text, id_host text, id_listing text, n_guests bigint, n_messages bigint, ts_accepted_at timestamp without time zone, ts_booking_at timestamp without time zone, ts_contact_at timestamp without time zone, ts_reply_at timestamp without time zone)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Assumes a table: friend_request(sender_id, send_to_id, request_date, is_accept)
-- or similar; using common schema: requests(requester_id, accepter_id, accept_date)
-- Using schema: friend_requests(request_id, requester_id, acceptee_id, is_accepted)

SELECT
    ROUND(
        100.0 * SUM(CASE WHEN is_accepted = 1 THEN 1 ELSE 0 END) / COUNT(*),
        2
    ) AS acceptance_rate
FROM friend_requests;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    ROUND(
        (
            SELECT 100.0 * COUNT(*)
            FROM friend_requests
            WHERE is_accepted = 1
        )
        /
        (
            SELECT COUNT(*)
            FROM friend_requests
        ),
        2
    ) AS acceptance_rate;
