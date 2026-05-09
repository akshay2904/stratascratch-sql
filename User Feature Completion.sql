-- ======================================================================
-- User Feature Completion
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 9792
-- URL        : https://platform.stratascratch.com/coding/9792-user-feature-completion
-- ======================================================================

/*
An app has product features that help guide users through a marketing funnel. Each user may complete some or all steps of a feature. For each feature, calculate the average completion percentage across users, where a user's completion percentage is defined as their maximum step reached divided by the total number of steps (n_steps) for that feature, multiplied by 100.
*/

-- Tables:
--   facebook_product_features(feature_id bigint, n_steps bigint)
--   facebook_product_features_realizations(feature_id bigint, step_reached bigint, timestamp timestamp without time zone, user_id bigint)


-- Write your SQL solution below:
