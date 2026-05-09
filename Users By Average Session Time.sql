-- ======================================================================
-- Users By Average Session Time
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Free
-- ID         : 10352
-- URL        : https://platform.stratascratch.com/coding/10352-users-by-avg-session-time
-- ======================================================================

/*
Calculate each user's average session time, where a session is defined as the time difference between a page_load and a page_exit. Assume each user has only one session per day. If there are multiple page_load or page_exit events on the same day, use only the latest page_load and the earliest page_exit. Only consider sessions where the page_load occurs before the page_exit on the same day. Output the user_id and their average session time.
*/

-- Tables:
--   facebook_web_log(action text, timestamp timestamp without time zone, user_id bigint)


-- Write your SQL solution below:
