-- ======================================================================
-- Number Of Custom Email Labels
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google
-- Access     : Premium
-- ID         : 10120
-- URL        : https://platform.stratascratch.com/coding/10120-number-of-custom-email-labels
-- ======================================================================

/*
Find the number of occurrences of custom email labels for each user receiving an email. Output the receiver user id, label, and the corresponding number of occurrences.
*/

-- Tables:
--   google_gmail_emails(day bigint, from_user text, id bigint, to_user text)
--   google_gmail_labels(email_id bigint, label text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Using CTE with window function to count label occurrences per receiver
WITH label_counts AS (
    SELECT
        to_user     AS receiver_user_id,
        label,
        COUNT(*)    AS occurrence_count
    FROM google_gmail_emails
    JOIN google_gmail_labels
        ON google_gmail_emails.id = google_gmail_labels.email_id
    WHERE label NOT IN ('inbox', 'sent', 'drafts', 'trash', 'spam', 'starred', 'important', 'unread')
      AND label IS NOT NULL
    GROUP BY to_user, label
)
SELECT
    receiver_user_id,
    label,
    occurrence_count
FROM label_counts
ORDER BY receiver_user_id, label;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Direct join and GROUP BY to count custom label occurrences per receiver
SELECT
    e.to_user   AS receiver_user_id,
    l.label,
    COUNT(*)    AS occurrence_count
FROM google_gmail_emails e
JOIN google_gmail_labels l
    ON e.id = l.email_id
WHERE l.label NOT IN ('inbox', 'sent', 'drafts', 'trash', 'spam', 'starred', 'important', 'unread')
  AND l.label IS NOT NULL
GROUP BY e.to_user, l.label
ORDER BY e.to_user, l.label;
