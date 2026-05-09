-- ======================================================================
-- Top Actor Ratings by Genre
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Google, Netflix
-- Access     : Premium
-- ID         : 10548
-- URL        : https://platform.stratascratch.com/coding/10548-top-actor-ratings-by-genre
-- ======================================================================

/*
Find the top actors based on their average movie rating within the genre they appear in most frequently.
•  For each actor, determine their most frequent genre (i.e., the one they’ve appeared in the most).
•   If there is a tie in genre count, select the genre where the actor has the highest average rating.
•   If there is still a tie in both count and rating, include all tied genres for that actor.




Rank all resulting actor + genre pairs in descending order by their average movie rating.
•  Return all pairs that fall within the top 3 ranks (not simply the top 3 rows), including ties.
•  Do not skip rank numbers — for example, if two actors are tied at rank 1, the next rank is 2 (not 3).
*/

-- Tables:
--   top_actors_rating(actor_name text, genre text, movie_rating double precision, movie_title text, production_company text, release_date date)


-- Write your SQL solution below:
