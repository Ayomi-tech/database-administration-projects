
-- Create and Back populate orders table

-- Targeted Schema
USE mavenbearbbuilders ;

-- Creation of orders table 
CREATE TABLE orders (
    order_id BIGINT,
    created_at DATETIME,
    website_session_id BIGINT,
    primary_product_id BIGINT,
    items_purchased BIGINT,
    price_usd DECIMAL(6 , 2 ),
    cogs_usd DECIMAL(6 , 2 ),
    PRIMARY KEY (order_id)
);

-- Creating a trigger to update the orders table whenever new records are inserted into the order_items table.
INSERT INTO orders
SELECT 
      order_id,
      MIN(created_at) AS created_at,
      MIN(website_session_id) AS website_session_id,
      SUM(CASE
          WHEN is_primary_item = 1 THEN product_id
          ELSE NULL 
          END) AS primary_product_id,
      COUNT(order_item_id) AS items_purchased,
      ROUND(SUM(price_usd), 2) AS price_usd,
      ROUND(SUM(cogs_usd), 2) AS cogs_usd
FROM order_items
GROUP BY order_id
ORDER BY order_id ;
 
-- Setting up automation to update the orders table whenever new rows are inserted into the order_items table.
CREATE 
    TRIGGER  insert_new_orders
 AFTER INSERT ON order_items FOR EACH ROW 
    REPLACE INTO orders SELECT order_id,
        MIN(created_at) AS created_at,
        MIN(website_session_id) AS website_session_id,
        SUM(CASE
            WHEN is_primary_item = 1 THEN product_id
            ELSE NULL
        END) AS primary_product_id,
        COUNT(order_item_id) AS items_purchased,
        ROUND(SUM(price_usd), 2) AS price_usd,
        ROUND(SUM(cogs_usd), 2) AS cogs_usd FROM
        order_items
    WHERE
        order_id = new.order_id
    GROUP BY order_id
    ORDER BY order_id;


