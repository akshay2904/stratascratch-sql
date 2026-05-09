-- ======================================================================
-- Acceptance Rate By Date
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Free
-- ID         : 10285
-- URL        : https://platform.stratascratch.com/coding/10285-acceptance-rate-by-date
-- ======================================================================

/*
Calculate the friend acceptance rate for each date when friend requests were sent. A request is sent if action = sent and accepted if action = accepted. If a request is not accepted, there is no record of it being accepted in the table.




The output will only include dates where requests were sent and at least one of them was accepted (acceptance can occur on any date after the request is sent).
*/

-- Tables:
--   fb_friend_requests(action text, date date, user_id_receiver text, user_id_sender text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- ============================================================

-- Using CTEs and window-style aggregation to separate sent vs accepted counts
WITH sent AS (
    SELECT date, COUNT(*) AS sent_count
    FROM friend_requests
    WHERE action = 'sent'
    GROUP BY date
),
accepted AS (
    SELECT requester_id, acceptor_id
    FROM friend_requests
    WHERE action = 'accepted'
),
sent_with_acceptance AS (
    -- Join sent requests to accepted to check if each sent request was accepted
    SELECT s.date,
           s.sent_count,
           COUNT(a.acceptor_id) AS accepted_count
    FROM sent s
    JOIN friend_requests fr
        ON fr.action = 'sent'
        AND fr.date = s.date
    LEFT JOIN accepted a
        ON fr.requester_id = a.requester_id
        AND fr.acceptor_id = a.acceptor_id
    GROUP BY s.date, s.sent_count
)
SELECT
    date,
    ROUND(accepted_count::NUMERIC / sent_count, 2) AS acceptance_rate
FROM sent_with_acceptance
WHERE accepted_count > 0  -- only dates where at least one was accepted
ORDER BY date;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- ============================================================

SELECT
    s.date,
    ROUND(
        COUNT(DISTINCT CASE WHEN a.action = 'accepted' THEN a.requester_id::TEXT || '-' || a.acceptor_id::TEXT END)::NUMERIC
        / COUNT(DISTINCT s.requester_id::TEXT || '-' || s.acceptor_id::TEXT),
        2
    ) AS acceptance_rate
FROM friend_requests s
LEFT JOIN friend_requests a
    ON s.requester_id = a.requester_id
    AND s.acceptor_id = a.acceptor_id
    AND a.action = 'accepted'
WHERE s.action = 'sent'
GROUP BY s.date
HAVING COUNT(DISTINCT CASE WHEN a.action = 'accepted' THEN a.requester_id::TEXT || '-' || a.acceptor_id::TEXT END) > 0
ORDER BY s.date;
