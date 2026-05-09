-- ======================================================================
-- Average Time Between Steps
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Meta
-- Access     : Premium
-- ID         : 9793
-- URL        : https://platform.stratascratch.com/coding/9793-average-time-between-steps
-- ======================================================================

/*
Facebook wants to understand the average time users take to perform certain activities in a feature. User activity is captured in the column step_reached.




Calculate the average time it takes for users to progress through the steps of each feature. Your approach should first calculate the average time it takes for each user to progress through their steps within the feature. Then, calculate the feature's average progression time by taking the average of these user-level averages. Ignore features where no user has more than one step.




Output the feature ID and the average progression time in seconds.
*/

-- Tables:
--   facebook_product_features_realizations(feature_id bigint, step_reached bigint, timestamp timestamp without time zone, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH user_feature_time AS (
    SELECT
        feature_id,
        user_id,
        -- Time from first step to last step for each user-feature combination
        EXTRACT(EPOCH FROM (MAX(timestamp) - MIN(timestamp))) AS progression_seconds
    FROM facebook_product_features_realizations
    GROUP BY feature_id, user_id
    HAVING COUNT(DISTINCT step_reached) > 1  -- only users with more than one step
),
feature_avg AS (
    SELECT
        feature_id,
        AVG(progression_seconds) AS avg_progression_time
    FROM user_feature_time
    GROUP BY feature_id
)
SELECT
    feature_id,
    avg_progression_time
FROM feature_avg
ORDER BY feature_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    feature_id,
    AVG(user_progression_seconds) AS avg_progression_time
FROM (
    -- Step 1: Calculate per-user, per-feature progression time
    SELECT
        feature_id,
        user_id,
        EXTRACT(EPOCH FROM (MAX(timestamp) - MIN(timestamp))) AS user_progression_seconds
    FROM facebook_product_features_realizations
    GROUP BY feature_id, user_id
    HAVING COUNT(step_reached) > 1  -- user must have more than one step recorded
) AS user_level_avg
GROUP BY feature_id
-- Exclude features where no user had more than one step
-- (handled by HAVING above; only features with qualifying users appear)
ORDER BY feature_id;
