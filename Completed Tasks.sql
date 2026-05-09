-- ======================================================================
-- Completed Tasks
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Asana
-- Access     : Premium
-- ID         : 2096
-- URL        : https://platform.stratascratch.com/coding/2096-completed-tasks
-- ======================================================================

/*
Find the number of actions that ClassPass workers did for tasks completed in January 2022. The completed tasks are these rows in the asana_actions table with 'action_name' equal to CompleteTask. Note that each row in the dataset indicates how many actions of a certain type one user has performed in one day and the number of actions is stored in the 'num_actions' column.
Output the ID of the user and a total number of actions they performed for tasks they completed. If a user from this company did not complete any tasks in the given period of time, you should still output their ID and the number 0 in the second column.
*/

-- Tables:
--   asana_users(company text, name text, surname text, user_id bigint)
--   asana_actions(action_name text, date date, num_actions bigint, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH classpass_users AS (
    -- Get all distinct ClassPass users
    SELECT DISTINCT user_id
    FROM asana_actions
    WHERE company = 'ClassPass'
),
completed_tasks AS (
    -- Get actions for completed tasks in January 2022 for ClassPass users
    SELECT 
        user_id,
        SUM(num_actions) AS total_actions
    FROM asana_actions
    WHERE company = 'ClassPass'
      AND action_name = 'CompleteTask'
      AND date >= '2022-01-01'
      AND date < '2022-02-01'
    GROUP BY user_id
)
SELECT 
    cu.user_id,
    COALESCE(ct.total_actions, 0) AS total_actions
FROM classpass_users cu
LEFT JOIN completed_tasks ct ON cu.user_id = ct.user_id
ORDER BY cu.user_id;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT 
    u.user_id,
    COALESCE(
        (
            SELECT SUM(a.num_actions)
            FROM asana_actions a
            WHERE a.user_id = u.user_id
              AND a.company = 'ClassPass'
              AND a.action_name = 'CompleteTask'
              AND a.date >= '2022-01-01'
              AND a.date < '2022-02-01'
        ), 0
    ) AS total_actions
FROM (
    SELECT DISTINCT user_id
    FROM asana_actions
    WHERE company = 'ClassPass'
) u
ORDER BY u.user_id;
