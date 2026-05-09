-- ======================================================================
-- Successfully Sent Messages
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 9777
-- URL        : https://platform.stratascratch.com/coding/9777-successfully-sent-messages
-- ======================================================================

/*
Find the ratio of successfully received messages to sent messages.
*/

-- Tables:
--   facebook_messages_sent(message_id bigint, sender bigint, text text)
--   facebook_messages_received(message_id bigint, receiver bigint, text text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Assumes a messages table with a status column
-- 'sent' = total attempted, 'received' (or 'delivered') = successfully received
WITH message_counts AS (
    SELECT
        COUNT(*) FILTER (WHERE status = 'sent')     AS sent_count,
        COUNT(*) FILTER (WHERE status = 'received') AS received_count
    FROM messages
)
SELECT
    sent_count,
    received_count,
    CASE
        WHEN sent_count = 0 THEN NULL
        ELSE ROUND(received_count::NUMERIC / sent_count::NUMERIC, 4)
    END AS received_to_sent_ratio
FROM message_counts;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    (SELECT COUNT(*) FROM messages WHERE status = 'sent')     AS sent_count,
    (SELECT COUNT(*) FROM messages WHERE status = 'received') AS received_count,
    CASE
        WHEN (SELECT COUNT(*) FROM messages WHERE status = 'sent') = 0 THEN NULL
        ELSE ROUND(
            (SELECT COUNT(*) FROM messages WHERE status = 'received')::NUMERIC
            /
            (SELECT COUNT(*) FROM messages WHERE status = 'sent')::NUMERIC,
            4
        )
    END AS received_to_sent_ratio;
