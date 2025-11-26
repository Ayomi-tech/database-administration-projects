
-- Order Performance
DELIMITER //
CREATE PROCEDURE order_performance (IN startdate DATE, enddate DATE)
BEGIN
SELECT COUNT(order_id) AS total_orders,
       SUM(price_usd) AS total_revenue
FROM orders
WHERE DATE(created_at) BETWEEN startdate AND enddate ;       
END //
DELIMITER ;

call order_performance ('2013-11-01', '2013-12-31');

-- Total Films and Store Data
DELIMITER //
CREATE PROCEDURE total_film_and_store (IN firstname VARCHAR(60), lastname VARCHAR(60))
BEGIN
SELECT store_id, COUNT(DISTINCT film_id) AS total_film FROM inventory_non_normalized
WHERE store_manager_first_name = firstname AND store_manager_last_name = lastname 
GROUP BY store_id;
END //
DELIMITER ;

CALL total_film_and_store ('Jon', 'Stephens');






