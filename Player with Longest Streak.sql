-- ======================================================================
-- Player with Longest Streak
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Google, Amazon
-- Access     : Premium
-- ID         : 2059
-- URL        : https://platform.stratascratch.com/coding/2059-player-with-longest-streak
-- ======================================================================

/*
You are given a table of tennis players and their matches that they could either win (W) or lose (L). Find the longest streak of wins. A streak is a set of consecutive won matches of one player. The streak ends once a player loses their next match.




For this question, disregard edge cases such as: players who never lose, streaks that start before the first loss, and streaks that continue after the final match.
*/

-- Tables:
--   players_results(match_date date, match_result text, player_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Use the classic "gaps and islands" technique with window functions
WITH ranked AS (
    SELECT
        player_id,
        match_date,
        outcome,
        ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY match_date) AS rn,
        -- Assign a group number: subtract win-sequence row number from overall row number
        -- Consecutive wins will share the same group value
        ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY match_date)
        - ROW_NUMBER() OVER (PARTITION BY player_id, outcome ORDER BY match_date) AS grp
    FROM matches
),
win_streaks AS (
    SELECT
        player_id,
        grp,
        COUNT(*) AS streak_length
    FROM ranked
    WHERE outcome = 'W'
    GROUP BY player_id, grp
)
SELECT
    player_id,
    MAX(streak_length) AS longest_win_streak
FROM win_streaks
GROUP BY player_id
ORDER BY longest_win_streak DESC
LIMIT 1;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- Identify loss positions, then count wins between consecutive losses
WITH loss_positions AS (
    -- Get each player's loss positions with a sequential loss number
    SELECT
        player_id,
        match_date,
        -- Count how many losses have occurred up to and including this match
        (SELECT COUNT(*)
         FROM matches m2
         WHERE m2.player_id = m1.player_id
           AND m2.outcome = 'L'
           AND m2.match_date <= m1.match_date) AS loss_seq
    FROM matches m1
    WHERE outcome = 'L'
),
-- For each pair of consecutive losses, count wins between them
streaks AS (
    SELECT
        l1.player_id,
        l1.match_date AS loss_start,
        l2.match_date AS loss_end,
        -- Count wins strictly between two consecutive losses
        (SELECT COUNT(*)
         FROM matches m
         WHERE m.player_id = l1.player_id
           AND m.outcome = 'W'
           AND m.match_date > l1.match_date
           AND m.match_date < l2.match_date) AS streak_length
    FROM loss_positions l1
    JOIN loss_positions l2
        ON l1.player_id = l2.player_id
       AND l2.loss_seq = l1.loss_seq + 1  -- consecutive losses only
)
SELECT
    player_id,
    MAX(streak_length) AS longest_win_streak
FROM streaks
GROUP BY player_id
ORDER BY longest_win_streak DESC
LIMIT 1;
