-- ======================================================================
-- Top Percentile Fraud
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Google, Netflix
-- Access     : Premium
-- ID         : 10303
-- URL        : https://platform.stratascratch.com/coding/10303-top-percentile-fraud
-- ======================================================================

/*
We want to identify the most suspicious claims in each state. We'll consider the top 5% of claims (those at or above the 95th percentile of fraud scores) in each state as potentially fraudulent.




Your output should include the policy number, state, claim cost, and fraud score.
*/

-- Tables:
--   fraud_score(claim_cost bigint, fraud_score double precision, policy_num text, state text)


-- Write your SQL solution below:
