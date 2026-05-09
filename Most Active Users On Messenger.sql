-- ======================================================================
-- Most Active Users On Messenger
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 10295
-- URL        : https://platform.stratascratch.com/coding/10295-most-active-users-on-messenger
-- ======================================================================

/*
Meta/Facebook Messenger stores the number of messages between users in a table named 'fb_messages'. In this table 'user1' is the sender, 'user2' is the receiver, and 'msg_count' is the number of messages exchanged between them.

Find the top 10 most active users on Meta/Facebook Messenger by counting their total number of messages sent and received. Your solution should output usernames and the count of the total messages they sent or received
*/

-- Tables:
--   fb_messages(date date, id bigint, msg_count bigint, user1 text, user2 text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH user_messages AS (
    -- Unpivot both sender and receiver into a single column using UNION ALL
    SELECT user1 AS username, msg_count FROM fb_messages
    UNION ALL
    SELECT user2 AS username, msg_count FROM fb_messages
),
ranked_users AS (
    SELECT
        username,
        SUM(msg_count) AS total_messages,
        RANK() OVER (ORDER BY SUM(msg_count) DESC) AS rnk
    FROM user_messages
    GROUP BY username
)
SELECT username, total_messages
FROM ranked_users
WHERE rnk <= 10
ORDER BY total_messages DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT username, SUM(msg_count) AS total_messages
FROM (
    -- Messages sent by user1
    SELECT user1 AS username, msg_count
    FROM fb_messages

    UNION ALL

    -- Messages received by user2
    SELECT user2 AS username, msg_count
    FROM fb_messages
) AS all_messages
GROUP BY username
ORDER BY total_messages DESC
LIMIT 10;
