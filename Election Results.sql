-- ======================================================================
-- Election Results
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Deloitte, Google
-- Access     : Premium
-- ID         : 2099
-- URL        : https://platform.stratascratch.com/coding/2099-election-results
-- ======================================================================

/*
The election is conducted in a city and everyone can vote for one or more candidates, or choose not to vote at all. Each person has 1 vote so if they vote for multiple candidates, their vote gets equally split across these candidates. For example, if a person votes for 2 candidates, these candidates receive an equivalent of 0.5 vote each. Some voters have chosen not to vote, which explains the blank entries in the dataset.




Find out who got the most votes and won the election. Output the name of the candidate or multiple names in case of a tie.

To avoid issues with a floating-point error you can round the number of votes received by a candidate to 3 decimal places.
*/

-- Tables:
--   voting_results(candidate text, voter text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH vote_counts AS (
    SELECT 
        candidate,
        ROUND(SUM(1.0 / candidate_count)::numeric, 3) AS total_votes
    FROM (
        SELECT 
            voter,
            candidate,
            COUNT(candidate) OVER (PARTITION BY voter) AS candidate_count
        FROM voting
        WHERE candidate IS NOT NULL AND candidate != ''
    ) sub
    GROUP BY candidate
),
max_votes AS (
    SELECT MAX(total_votes) AS max_total FROM vote_counts
)
SELECT vc.candidate
FROM vote_counts vc
JOIN max_votes mv ON vc.total_votes = mv.max_total;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT candidate
FROM (
    SELECT 
        v.candidate,
        ROUND(SUM(1.0 / voter_counts.cnt)::numeric, 3) AS total_votes
    FROM voting v
    JOIN (
        SELECT voter, COUNT(candidate) AS cnt
        FROM voting
        WHERE candidate IS NOT NULL AND candidate != ''
        GROUP BY voter
    ) voter_counts ON v.voter = voter_counts.voter
    WHERE v.candidate IS NOT NULL AND v.candidate != ''
    GROUP BY v.candidate
) candidate_totals
WHERE total_votes = (
    SELECT MAX(total_votes)
    FROM (
        SELECT 
            v2.candidate,
            ROUND(SUM(1.0 / voter_counts2.cnt)::numeric, 3) AS total_votes
        FROM voting v2
        JOIN (
            SELECT voter, COUNT(candidate) AS cnt
            FROM voting
            WHERE candidate IS NOT NULL AND candidate != ''
            GROUP BY voter
        ) voter_counts2 ON v2.voter = voter_counts2.voter
        WHERE v2.candidate IS NOT NULL AND v2.candidate != ''
        GROUP BY v2.candidate
    ) inner_totals
);
