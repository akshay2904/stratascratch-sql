-- ======================================================================
-- Customer Feedback Analysis
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Capital One
-- Access     : Premium
-- ID         : 10366
-- URL        : https://platform.stratascratch.com/coding/10366-customer-feedback-analysis
-- ======================================================================

/*
Capital One's marketing team is working on a project to analyze customer feedback from their feedback surveys.




The team sorted the words from the feedback into three different categories:




•	short_comments

•	mid_length_comments

•	long_comments




The team wants to find comments that are not short and that come from social media. The output should include feedback_id, feedback_text, source_channel, and a comment_category, which is already calculated in the data. Include only one row per feedback_id.
*/

-- Tables:
--   customer_feedback(comment_category text, feedback_id bigint, feedback_text text, source_channel text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH ranked_feedback AS (
    SELECT
        feedback_id,
        feedback_text,
        source_channel,
        comment_category,
        ROW_NUMBER() OVER (PARTITION BY feedback_id ORDER BY feedback_id) AS rn
    FROM (
        SELECT feedback_id, feedback_text, source_channel, 'short_comments' AS comment_category
        FROM short_comments
        UNION ALL
        SELECT feedback_id, feedback_text, source_channel, 'mid_length_comments' AS comment_category
        FROM mid_length_comments
        UNION ALL
        SELECT feedback_id, feedback_text, source_channel, 'long_comments' AS comment_category
        FROM long_comments
    ) all_feedback
    WHERE comment_category <> 'short_comments'
      AND source_channel = 'Social Media'
)
SELECT
    feedback_id,
    feedback_text,
    source_channel,
    comment_category
FROM ranked_feedback
WHERE rn = 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT DISTINCT
    f.feedback_id,
    f.feedback_text,
    f.source_channel,
    f.comment_category
FROM (
    -- Exclude short_comments, include only Social Media
    SELECT feedback_id, feedback_text, source_channel, 'mid_length_comments' AS comment_category
    FROM mid_length_comments
    WHERE source_channel = 'Social Media'

    UNION

    SELECT feedback_id, feedback_text, source_channel, 'long_comments' AS comment_category
    FROM long_comments
    WHERE source_channel = 'Social Media'
) f;
