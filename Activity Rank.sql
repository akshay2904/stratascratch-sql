-- ======================================================================
-- Activity Rank
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google
-- Access     : Premium
-- ID         : 10351
-- URL        : https://platform.stratascratch.com/coding/10351-activity-rank
-- ======================================================================

/*
Find the email activity rank for each user. Email activity rank is defined by the total number of emails sent. The user with the highest number of emails sent will have a rank of 1, and so on. Output the user, total emails, and their activity rank.




•	Order records first by the total emails in descending order.

•	Then, sort users with the same number of emails in alphabetical order by their username.

•	In your rankings, return a unique value (i.e., a unique rank) even if multiple users have the same number of emails.
*/

-- Tables:
--   google_gmail_emails(day bigint, from_user text, id bigint, to_user text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH email_counts AS (
    SELECT
        from_user,
        COUNT(*) AS total_emails
    FROM google_gmail_emails
    GROUP BY from_user
)
SELECT
    from_user,
    total_emails,
    ROW_NUMBER() OVER (
        ORDER BY total_emails DESC, from_user ASC
    ) AS activity_rank
FROM email_counts
ORDER BY total_emails DESC, from_user ASC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    e1.from_user,
    e1.total_emails,
    -- Count how many users have strictly more emails, or same emails but alphabetically before
    (
        SELECT COUNT(*) + 1
        FROM (
            SELECT from_user, COUNT(*) AS total_emails
            FROM google_gmail_emails
            GROUP BY from_user
        ) e2
        WHERE e2.total_emails > e1.total_emails
           OR (e2.total_emails = e1.total_emails AND e2.from_user < e1.from_user)
    ) AS activity_rank
FROM (
    SELECT from_user, COUNT(*) AS total_emails
    FROM google_gmail_emails
    GROUP BY from_user
) e1
ORDER BY total_emails DESC, from_user ASC;
