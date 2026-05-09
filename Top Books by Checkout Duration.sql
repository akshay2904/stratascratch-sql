-- ======================================================================
-- Top Books by Checkout Duration
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Meta, Spotify, Audible
-- Access     : Premium
-- ID         : 10567
-- URL        : https://platform.stratascratch.com/coding/10567-top-books-by-checkout-duration
-- ======================================================================

/*
A public library system tracks book circulation to understand which titles generate the most value through patron engagement. The library defines a book's lifetime value as the total number of days across all checkout periods for all copies of that book. Calculate each book's lifetime value by summing the number of days between checkout date and return date for all completed checkouts. Only include books that have more than 10 physical copies in the library's collection. Exclude any checkouts where a book hasn't been returned yet.




Return books ranked in the top 3 by lifetime value. If books are tied, they receive the same rank with no gaps in ranking (e.g., 1, 1, 2, 3 rather than 1, 1, 3, 4). Include all books ranked 1st, 2nd, or 3rd. Output the book title, number of copies, and lifetime value in days.
*/

-- Tables:
--   library_books(author text, book_id bigint, num_copies bigint, title text)
--   library_checkouts(book_id bigint, checkout_date date, checkout_id bigint, return_date date)


-- Write your SQL solution below:
