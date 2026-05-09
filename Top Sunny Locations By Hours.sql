-- ======================================================================
-- Top Sunny Locations By Hours
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Capital One
-- Access     : Premium
-- ID         : 10551
-- URL        : https://platform.stratascratch.com/coding/10551-top-sunny-locations-by-hours
-- ======================================================================

/*
Find the top three locations with the highest total number of sunny hours. Sunny hours are calculated as:




Sunny Hours = Maximum Daylight Hours - (Cloud Cover Percentage ÷ 10).




If the result is negative, treat it as zero. Round all calculations to 2 decimal places.




Return the location name and the total number of sunny hours. If multiple locations are tied in total sunny hours, include all tied locations, even if this results in more than three being returned. Do not skip ranks. If there are ties, all tied locations should be included at their shared rank.
*/

-- Tables:
--   weather_data(cloud_cover_percentage double precision, date date, location_name text, max_daylight_hours double precision)


-- Write your SQL solution below:
