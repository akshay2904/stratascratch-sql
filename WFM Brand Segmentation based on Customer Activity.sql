-- ======================================================================
-- WFM Brand Segmentation based on Customer Activity
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Whole Foods Market
-- Access     : Premium
-- ID         : 2038
-- URL        : https://platform.stratascratch.com/coding/2038-wfm-brand-segmentation-based-on-customer-activity
-- ======================================================================

/*
WFM would like to segment the customers in each of their store brands into Low, Medium, and High segmentation. The segments are to be based on a customer's average basket size which is defined as (total sales / count of transactions), per customer.




The segment thresholds are as follows:





If average basket size is more than $30, then Segment is “High”.


If average basket size is between $20 and $30, then Segment is “Medium”.


If average basket size is less than $20, then Segment is “Low”.





Summarize the number of unique customers, the total number of transactions, total sales, and average basket size, grouped by store brand and segment for 2017.




Your output should include the brand, segment, number of customers, total transactions, total sales, and average basket size.
*/

-- Tables:
--   wfm_transactions(customer_id bigint, product_id bigint, sales bigint, store_id bigint, transaction_date date, transaction_id bigint)
--   wfm_stores(location text, store_brand text, store_id bigint)


-- Write your SQL solution below:
