-- ======================================================================
-- Product Market Share
-- ======================================================================
-- Difficulty : Hard
-- Companies  : Shopify, Amazon
-- Access     : Premium
-- ID         : 2112
-- URL        : https://platform.stratascratch.com/coding/2112-product-market-share
-- ======================================================================

/*
Write a query to find the market share at the product brand level for each territory, for the Q4-2021 time period.




Market share is defined as the number of orders of a certain product brand sold in a territory divided by the total number of orders sold in this territory.




Output the ID of the territory, name of the product brand and the corresponding market share in percentages. Only include these product brands that had at least one sale in a given territory.
*/

-- Tables:
--   fct_customer_sales(cust_id text, order_date date, order_id text, order_value bigint, prod_sku_id text)
--   map_customer_territory(cust_id text, territory_id text)
--   dim_product(market_name text, prod_brand text, prod_sku_id text, prod_sku_name text)


-- Write your SQL solution below:

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH q4_2021_orders AS (
    -- Filter orders to Q4 2021 (October, November, December 2021)
    SELECT
        o.order_id,
        o.territory_id,
        p.product_brand
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.order_date >= '2021-10-01'
      AND o.order_date <  '2022-01-01'
),
brand_territory_counts AS (
    SELECT
        territory_id,
        product_brand,
        COUNT(DISTINCT order_id) AS brand_orders
    FROM q4_2021_orders
    GROUP BY territory_id, product_brand
)
SELECT
    territory_id,
    product_brand,
    -- Divide brand orders by total orders per territory and convert to percentage
    ROUND(
        brand_orders * 100.0 / SUM(brand_orders) OVER (PARTITION BY territory_id),
        2
    ) AS market_share_pct
FROM brand_territory_counts
ORDER BY territory_id, market_share_pct DESC;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    brand_sales.territory_id,
    brand_sales.product_brand,
    ROUND(
        brand_sales.brand_orders * 100.0 / territory_totals.total_orders,
        2
    ) AS market_share_pct
FROM (
    -- Count distinct orders per territory + brand in Q4 2021
    SELECT
        o.territory_id,
        p.product_brand,
        COUNT(DISTINCT o.order_id) AS brand_orders
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.order_date >= '2021-10-01'
      AND o.order_date <  '2022-01-01'
    GROUP BY o.territory_id, p.product_brand
) AS brand_sales
JOIN (
    -- Count total distinct orders per territory in Q4 2021
    SELECT
        o.territory_id,
        COUNT(DISTINCT o.order_id) AS total_orders
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN products p ON oi.product_id = p.product_id
    WHERE o.order_date >= '2021-10-01'
      AND o.order_date <  '2022-01-01'
    GROUP BY o.territory_id
) AS territory_totals
    ON brand_sales.territory_id = territory_totals.territory_id
ORDER BY brand_sales.territory_id, market_share_pct DESC;
