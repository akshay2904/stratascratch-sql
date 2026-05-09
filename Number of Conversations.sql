-- ======================================================================
-- Number of Conversations
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 2086
-- URL        : https://platform.stratascratch.com/coding/2086-number-of-conversations
-- ======================================================================

/*
Count the total number of distinct conversations on WhatsApp. Two users share a conversation if there is at least 1 message between them. Multiple messages between the same pair of users are considered a single conversation.
*/

-- Tables:
--   whatsapp_messages(message_date date, message_id bigint, message_receiver_id text, message_sender_id text, message_time text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Normalize each message so the smaller user_id is always "user1"
-- to treat (A→B) and (B→A) as the same conversation, then count distinct pairs.
WITH normalized AS (
    SELECT
        LEAST(sender_id, receiver_id)    AS user1,
        GREATEST(sender_id, receiver_id) AS user2
    FROM whatsapp_messages
)
SELECT COUNT(DISTINCT (user1, user2)) AS total_conversations
FROM normalized;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Group by the normalized pair using GROUP BY, then count the groups.
SELECT COUNT(*) AS total_conversations
FROM (
    SELECT
        LEAST(sender_id, receiver_id)    AS user1,
        GREATEST(sender_id, receiver_id) AS user2
    FROM whatsapp_messages
    GROUP BY
        LEAST(sender_id, receiver_id),
        GREATEST(sender_id, receiver_id)
) AS distinct_conversations;
