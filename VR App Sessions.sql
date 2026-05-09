-- ======================================================================
-- VR App Sessions
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta, Spotify, Netflix
-- Access     : Premium
-- ID         : 10569
-- URL        : https://platform.stratascratch.com/coding/10569-vr-app-sessions
-- ======================================================================

/*
Your company operates a VR gaming platform where users can launch and play various virtual reality applications. The vr_sessions table records every session initiated by users, capturing when they started an app and when they exited. The platform analytics team needs to understand app popularity and usage patterns.




Calculate the total number of unique sessions for each VR application. A session is identified by a unique session_id. If the same session_id appears multiple times in the table (which can happen due to connection retries or logging issues), count it as only one session by keeping the record with the earliest start_time. Include all applications that have at least one session in your results. Return the app name and the total number of sessions.
*/

-- Tables:
--   vr_sessions(app_name text, end_time timestamp without time zone, session_id text, start_time timestamp without time zone, user_id text)


-- Write your SQL solution below:
