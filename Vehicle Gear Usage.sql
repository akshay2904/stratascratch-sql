-- ======================================================================
-- Vehicle Gear Usage
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Tesla, Lyft, Uber
-- Access     : Premium
-- ID         : 10571
-- URL        : https://platform.stratascratch.com/coding/10571-vehicle-gear-usage
-- ======================================================================

/*
A company tracks data from its delivery vehicles. Every time a driver changes gears, the system records which vehicle ('car_id'), when it happened (timestamp in Unix epoch seconds), and which gear: P (Park), D (Drive), or R (Reverse).




Calculate how many total hours all vehicles spent in each gear. To determine the duration of a gear period, calculate the time difference between when that gear was engaged and when the next gear change occurred. For each vehicle's final gear change (which has no subsequent change recorded), assume the shift ended 2 hours after that final timestamp. Return gear and total hours.
*/

-- Tables:
--   vehicle_telemetry(car_id text, gear text, timestamp_epoch bigint)


-- Write your SQL solution below:
