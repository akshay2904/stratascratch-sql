-- ======================================================================
-- Marketing Campaign Success [Advanced]
-- ======================================================================
-- Difficulty : Hard
-- Companies  : ActiveCampaign, Amazon
-- Access     : Premium
-- ID         : 514
-- URL        : https://platform.stratascratch.com/coding/514-marketing-campaign-success-advanced
-- ======================================================================

/*
You have the marketing_campaign table, which records in-app purchases by users. Users making their first in-app purchase enter a marketing campaign, where they see call-to-actions for more purchases. Find how many users made additional purchases due to the campaign's success.




The campaign starts one day after the first purchase. Users with only one or multiple purchases on the first day do not count, nor do users who later buy only the same products from their first day.
*/

-- Tables:
--   marketing_campaign(created_at date, price bigint, product_id bigint, quantity bigint, user_id bigint)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH first_day AS (
    -- Determine each user's first purchase date and the products bought that day
    SELECT
        user_id,
        MIN(created_at::date) AS first_purchase_date
    FROM marketing_campaign
    GROUP BY user_id
),
first_day_products AS (
    -- Collect distinct products purchased on the first day per user
    SELECT DISTINCT
        mc.user_id,
        fd.first_purchase_date,
        mc.product_id
    FROM marketing_campaign mc
    JOIN first_day fd
        ON mc.user_id = fd.user_id
        AND mc.created_at::date = fd.first_purchase_date
),
campaign_purchases AS (
    -- Purchases made AFTER the first day (campaign period)
    SELECT DISTINCT
        mc.user_id,
        mc.product_id
    FROM marketing_campaign mc
    JOIN first_day fd
        ON mc.user_id = fd.user_id
        AND mc.created_at::date > fd.first_purchase_date  -- campaign starts day after first purchase
),
new_product_buyers AS (
    -- Users who bought at least one product during campaign that was NOT in their first-day set
    SELECT DISTINCT cp.user_id
    FROM campaign_purchases cp
    LEFT JOIN first_day_products fdp
        ON cp.user_id = fdp.user_id
        AND cp.product_id = fdp.product_id
    WHERE fdp.product_id IS NULL  -- product not seen on first day
)
SELECT COUNT(*) AS users_influenced_by_campaign
FROM new_product_buyers;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT COUNT(*) AS users_influenced_by_campaign
FROM (
    -- Users who have at least one post-first-day purchase of a NEW product
    SELECT mc.user_id
    FROM marketing_campaign mc
    WHERE mc.created_at::date > (
        -- first purchase date for this user
        SELECT MIN(mc2.created_at::date)
        FROM marketing_campaign mc2
        WHERE mc2.user_id = mc.user_id
    )
    AND mc.product_id NOT IN (
        -- products bought on their first purchase day
        SELECT mc3.product_id
        FROM marketing_campaign mc3
        WHERE mc3.user_id = mc.user_id
          AND mc3.created_at::date = (
              SELECT MIN(mc4.created_at::date)
              FROM marketing_campaign mc4
              WHERE mc4.user_id = mc3.user_id
          )
    )
    GROUP BY mc.user_id
) AS influenced_users;
