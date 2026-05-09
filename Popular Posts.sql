-- ======================================================================
-- Popular Posts
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Google, Amazon, Meta
-- Access     : Premium
-- ID         : 2073
-- URL        : https://platform.stratascratch.com/coding/2073-popular-posts
-- ======================================================================

/*
The column 'perc_viewed' in the table 'post_views' denotes the percentage of the session duration time the user spent viewing a post. Using it, calculate the total time that each post was viewed by users. Output post ID and the total viewing time in seconds, but only for posts with a total viewing time of over 5 seconds.
*/

-- Tables:
--   user_sessions(platform text, session_endtime timestamp without time zone, session_id bigint, session_starttime timestamp without time zone, user_id text)
--   post_views(perc_viewed double precision, post_id bigint, session_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- ============================================================

-- Join post_views with sessions to get session duration,
-- then compute perc_viewed * session_duration to get actual view time per row
SELECT
    pv.post_id,
    SUM(s.session_duration * pv.perc_viewed / 100.0) AS total_view_time
FROM post_views pv
JOIN sessions s
    ON pv.session_id = s.session_id
GROUP BY pv.post_id
HAVING SUM(s.session_duration * pv.perc_viewed / 100.0) > 5;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- ============================================================

SELECT
    post_id,
    total_view_time
FROM (
    SELECT
        pv.post_id,
        SUM(s.session_duration * pv.perc_viewed / 100.0) AS total_view_time
    FROM post_views pv,
         sessions s
    WHERE pv.session_id = s.session_id
    GROUP BY pv.post_id
) subq
WHERE total_view_time > 5;
