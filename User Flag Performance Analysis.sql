-- ======================================================================
-- User Flag Performance Analysis
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Google
-- Access     : Premium
-- ID         : 10558
-- URL        : https://platform.stratascratch.com/coding/10558-user-flag-performance-analysis
-- ======================================================================

/*
You are analyzing user flagging performance on a video platform. For each user who has had at least one of their flags reviewed by YouTube, calculate their flagging performance metrics as described below.




Find each user's first name, last name, total number of distinct videos they flagged that had at least one reviewed flag, total number of distinct videos they flagged that were ultimately removed, and the latest date when any of their flags were reviewed.
*/

-- Tables:
--   user_flags(flag_id text, user_firstname text, user_lastname text, video_id text)
--   flag_review(flag_id text, reviewed_by_yt boolean, reviewed_date date, reviewed_outcome text)


-- Write your SQL solution below:
