-- ======================================================================
-- Total Sales In Different Currencies
-- ======================================================================
-- Difficulty : Medium
-- Companies  : Goldman Sachs, Salesforce
-- Access     : Premium
-- ID         : 2041
-- URL        : https://platform.stratascratch.com/coding/2041-total-sales-in-different-currencies
-- ======================================================================

/*
You work for a multinational company that wants to calculate total sales across all their countries they do business in.
You have 2 tables, one is a record of sales for all countries and currencies the company deals with, and the other holds currency exchange rate information.
Calculate the total sales, per quarter, for the first 2 quarters in 2020, and report the sales in USD currency.
*/

-- Tables:
--   sf_exchange_rate(date date, exchange_rate double precision, source_currency text, target_currency text)
--   sf_sales_amount(currency text, sales_amount bigint, sales_date date)


-- Write your SQL solution below:
