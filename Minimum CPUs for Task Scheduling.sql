-- ======================================================================
-- Minimum CPUs for Task Scheduling
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Nvidia
-- Access     : Premium
-- ID         : 10557
-- URL        : https://platform.stratascratch.com/coding/10557-minimum-cpus-for-task-scheduling
-- ======================================================================

/*
You are managing a task scheduling system where each task has a specific start and end time. Multiple tasks can run simultaneously if there are enough CPUs available, but each CPU can only run one task at a time.




Given a list of task execution intervals, determine the minimum number of CPUs required to execute all tasks without any conflicts. When processing the data, duplicate task entries should only be counted once, and tasks with missing start or end times should be excluded from the calculation. Tasks without names can still be included as long as they have valid execution times. Note that when a task ends at the exact moment another task starts, they do not conflict since the CPU can be reused immediately.




Return the minimum number of CPUs required.
*/

-- Tables:
--   task_schedule(end_time timestamp without time zone, start_time timestamp without time zone, task_id bigint, task_name text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

-- Using a sweep line / event-based approach with window functions
-- Each task start = +1 CPU needed, each task end = -1 CPU freed
-- At any point, max concurrent tasks = min CPUs required

WITH tasks AS (
    -- Deduplicate and exclude rows with missing start or end times
    SELECT DISTINCT start_time, end_time
    FROM task_schedule
    WHERE start_time IS NOT NULL
      AND end_time IS NOT NULL
),
events AS (
    -- Generate +1 event at start, -1 event at end
    -- Tasks ending at same time another starts do NOT conflict (end first)
    SELECT start_time AS event_time, 1 AS delta FROM tasks
    UNION ALL
    SELECT end_time AS event_time, -1 AS delta FROM tasks
),
running_totals AS (
    SELECT
        event_time,
        delta,
        -- Sum all events at same time (ends before starts at same timestamp)
        SUM(delta) OVER (
            ORDER BY event_time,
                     delta  -- order -1 (ends) before +1 (starts) at same time
        ) AS concurrent_tasks
    FROM events
)
SELECT COALESCE(MAX(concurrent_tasks), 0) AS min_cpus_required
FROM running_totals;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

-- For each task's start time, count how many other tasks overlap with it
-- A task B overlaps task A's start if B.start_time <= A.start_time < B.end_time
-- (strict less than end_time because tasks ending exactly when another starts don't conflict)

WITH tasks AS (
    -- Deduplicate and exclude rows with missing start or end times
    SELECT DISTINCT start_time, end_time
    FROM task_schedule
    WHERE start_time IS NOT NULL
      AND end_time IS NOT NULL
)
SELECT COALESCE(MAX(overlap_count), 0) AS min_cpus_required
FROM (
    SELECT
        t1.start_time,
        -- Count how many tasks are actively running when t1 starts
        -- A task is running at t1.start_time if it started at or before t1.start_time
        -- and ends strictly after t1.start_time (end == start means no conflict)
        COUNT(*) AS overlap_count
    FROM tasks t1
    JOIN tasks t2
        ON t2.start_time <= t1.start_time
       AND t2.end_time > t1.start_time  -- strictly greater: task ending = CPU freed immediately
    GROUP BY t1.start_time
) AS overlaps;
