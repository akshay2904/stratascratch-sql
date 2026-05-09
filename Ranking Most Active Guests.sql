-- ======================================================================
-- Ranking Most Active Guests
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Airbnb
-- Access     : Free
-- ID         : 10159
-- URL        : https://platform.stratascratch.com/coding/10159-ranking-most-active-guests
-- ======================================================================

/*
Identify the most engaged guests by ranking them according to their overall messaging activity. The most active guest, meaning the one who has exchanged the most messages with hosts, should have the highest rank. If two or more guests have the same number of messages, they should have the same rank. Importantly, the ranking shouldn't skip any numbers, even if many guests share the same rank. Present your results in a clear format, showing the rank, guest identifier, and total number of messages for each guest, ordered from the most to least active.
*/

-- Tables:
--   airbnb_contacts(ds_checkin date, ds_checkout date, id_guest text, id_host text, id_listing text, n_guests bigint, n_messages bigint, ts_accepted_at timestamp without time zone, ts_booking_at timestamp without time zone, ts_contact_at timestamp without time zone, ts_reply_at timestamp without time zone)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH message_counts AS (
    SELECT
        id_guest,
        COUNT(*) AS total_messages
    FROM messages
    GROUP BY id_guest
)
SELECT
    DENSE_RANK() OVER (ORDER BY total_messages DESC) AS rank,
    id_guest,
    total_messages
FROM message_counts
ORDER BY rank, id_guest;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    -- Count how many distinct message totals are greater than this guest's total,
    -- then add 1 to get the dense rank
    (
        SELECT COUNT(DISTINCT sub.msg_count)
        FROM (
            SELECT id_guest, COUNT(*) AS msg_count
            FROM messages
            GROUP BY id_guest
        ) sub
        WHERE sub.msg_count > main.total_messages
    ) + 1 AS rank,
    id_guest,
    total_messages
FROM (
    SELECT
        id_guest,
        COUNT(*) AS total_messages
    FROM messages
    GROUP BY id_guest
) main
ORDER BY rank, id_guest;
