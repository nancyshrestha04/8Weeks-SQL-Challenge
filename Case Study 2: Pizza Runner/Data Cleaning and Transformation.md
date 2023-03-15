# 🛁 ✨ Data Cleaning and Transformation

## 1. ``customer_orders`` table
The customer_orders table shown below has missing/blank space and ``null`` values in the exclusions and extras column. 

![customer_orders](https://user-images.githubusercontent.com/123035903/225198833-577d8cf6-3c8b-4275-b884-419fec6f94e4.png)

### Steps
-	Removed null and blank spaces and replaced them with ‘ ‘ in the extras and exclusion column.
-	Used ``INTO`` function to create and insert the cleaned data in the temporary table t_customer_orders.
````sql
SELECT 		order_id, customer_id, pizza_id,
			CASE
			      WHEN exclusions LIKE 'null' OR exclusions ISNULL THEN '' 
			      ELSE exclusions
			      END as exclusion,
			CASE 
			      WHEN extras LIKE 'null' OR extras ISNULL THEN '' 
			      ELSE extras
			      END as extras,
			order_time
INTO TEMP TABLE      t_customer_orders 				
FROM                            pizza_runner.customer_orders;
````
### Result

![t-customer-orders](https://user-images.githubusercontent.com/123035903/225209041-11133db6-c9cc-4024-8352-2781d77e6000.png)
***
## 2. ``runner_orders`` table
The runner_orders table below has missing/blank space and null values in 
-	pickup_time has null values.
-	distance has null values, and few values have ‘km’, and few don’t.
-	duration has null values, and few values have ‘minutes/mins/minute’, and few don’t.
-	cancellation column has missing/blank space and null values.

![runner_orders](https://user-images.githubusercontent.com/123035903/225209475-1e02c3b7-27d7-402d-ac6b-b9307dfff560.png)
781d77e6000.png)

### Steps
-	Removed null and blank spaces and replaced them with ‘ ‘ in the pickup_time and cancellation columns.
-	Replaced nulls with ‘ ‘ and used TRIM function to remove the ‘mins/minute/minutes’ from duration column.
-	Replaced nulls with ‘ ‘ and used TRIM function to remove ‘km’ from the distance column.
-	Used ``INTO`` function to create and insert the cleaned data in the temporary table t_runner_orders.
````sql
SELECT	order_id,runner_id,
		CASE 
		     WHEN pickup_time = 'null' THEN '' 
		      ELSE pickup_time
		      END as pickup_time,
		CASE
		      WHEN duration = 'null' THEN ''
		      WHEN duration LIKE '%mins' THEN 
                                       TRIM('mins' from duration)
		      WHEN duration LIKE '%minute' THEN TRIM('minute' from duration)
		      WHEN duration LIKE '%minutes' THEN 
                                       TRIM('minutes' FROM duration)
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
FROM                pizza_runner.runner_orders;
````

### Result

![t-runner-orders](https://user-images.githubusercontent.com/123035903/225210024-3e244f47-deff-44e0-9579-ea6b149f5165.png)

***
## 3. Alter the data type of pickup_time, distance and duration columns from t_runner_orders table.

It is required to change the data type of :
-	pickup_time to DATETIME data type
-	distance to FLOAT data type
-	duration to INT data type

Since there are empty strings in all the above columns, we must update and set pickup_time to ‘2000-01-01 00:00:00’, distance and duration to 0. 
````sql
UPDATE       t_runner_orders
SET               pickup_time = '2000-01-01 00:00:00'
WHERE        pickup_time = '' ;

UPDATE      t_runner_orders
SET              distance = 0
WHERE       distance = '';

UPDATE       t_runner_orders
SET               duration = 0
WHERE        duration= '';
````
And then we alter the data type for each of the above columns.
````sql
------For pickup_time-----
ALTER TABLE t_runner_orders
ALTER COLUMN pickup_time TYPE TIMESTAMP
USING pickup_time:: TIMESTAMP without time zone;

---For duration column---
ALTER TABLE t_runner_orders
ALTER COLUMN duration TYPE integer
USING duration:: integer;

----For distance column---
ALTER TABLE t_runner_orders
ALTER COLUMN distance TYPE FLOAT
using distance::FLOAT;
````
### Result

![updated_t_runner_orders](https://user-images.githubusercontent.com/123035903/225211089-e6cb3986-ab4a-47fb-b81f-3481b6c519d7.png)

***










