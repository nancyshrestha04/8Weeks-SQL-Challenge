------Removing null from the columns in customer_orders table and creating
-------temporary customer_orders table-----------

SELECT 			order_id, customer_id, pizza_id,
				CASE
				WHEN exclusions LIKE 'null' OR exclusions ISNULL THEN '' ELSE exclusions
			END as exclusion,
			CASE WHEN extras LIKE 'null' OR
			extras ISNULL THEN '' 
			ELSE extras
			END as extras,
			order_time
INTO temp table t_customer_orders 
				
FROM customer_orders;

----------------Removing null from the columns in runner_orders table---------
-------and creating temporary table runner_orders--------

SELECT			order_id,runner_id,
			CASE 
				WHEN pickup_time = 'null' THEN '' 
				ELSE pickup_time
				END as pickup_time,
			CASE
				WHEN duration = 'null' THEN ''
				WHEN duration LIKE '%mins' THEN TRIM('mins' from duration)
				WHEN duration LIKE '%minute' THEN TRIM('minute' from duration)
				WHEN duration LIKE '%minutes' THEN TRIM('minutes' FROM duration)
				ELSE duration
				END as duration,
			CASE 
				WHEN distance = 'null' THEN '' 
				WHEN distance LIKE '%km' THEN TRIM('km' from distance)
				ELSE distance
				END as distance,
			CASE
				WHEN cancellation IS NULL or cancellation LIKE 'null' THEN ''
                ELSE cancellation 
				END AS cancellation				
INTO temp table t_runner_orders 
FROM runner_orders;

-----Then, we alter the date according to its correct data type.
-- pickup_time to DATETIME type--
-- distance to FLOAT type--
-- duration to INT type---
-----//////////////-------------------------------------
---Since there are empty strings in the duration column, one cannot change the---
-----datatype straight away, so had to set the duration as 0 wherever ''------
UPDATE t_runner_orders
SET duration = 0
WHERE duration= '';

----------------
---Since there are empty strings in the distance column, one cannot change the---
-----datatype straight away, so had to set the distance as 0 wherever ''------

UPDATE t_runner_orders
SET distance = 0
WHERE distance = '';

------------------------------
---Since there are empty strings in the pickup_time column, one cannot change the---
-----datatype straight away, so had to set the distance as 0 wherever ''------

UPDATE t_runner_orders
SET pickup_time = '2000-01-01 00:00:00'
WHERE pickup_time = '';

----NOW altering the datatype----

ALTER TABLE t_runner_orders
ALTER COLUMN distance TYPE FLOAT
using distance::FLOAT;

---For duration column---
ALTER TABLE t_runner_orders
ALTER COLUMN duration TYPE integer
USING duration:: integer;

------For pickup_time-----

ALTER TABLE t_runner_orders
ALTER COLUMN pickup_time TYPE TIMESTAMP
USING pickup_time:: TIMESTAMP without time zone; 

--------------------------------
