-- ======================================================================
-- Top Posts Per Channel
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta
-- Access     : Premium
-- ID         : 10538
-- URL        : https://platform.stratascratch.com/coding/10538-top-posts-per-channel
-- ======================================================================

/*
Identify the top 3 posts with the highest like counts for each channel. Assign a rank to each post based on its like count, allowing for gaps in ranking when posts have the same number of likes. For example, if two posts tie for 1st place, the next post should be ranked 3rd, not 2nd. Exclude any posts with zero likes.




The output should display the channel name, post ID, post creation date, and the like count for each post. Because there could be ties in rankings, your output could have more than 3 rows for each channel.
*/

-- Tables:
--   posts(channel_id bigint, comments bigint, created_at date, likes bigint, post_id bigint, shares bigint)
--   channels(channel_id bigint, channel_name text, channel_type text)


-- Write your SQL solution below:
