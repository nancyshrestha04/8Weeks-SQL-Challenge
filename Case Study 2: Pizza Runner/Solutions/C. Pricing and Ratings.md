# 💵 ⭐ Pricing and Ratings
## [Solutions](#solutions)

### 1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes how much money has Pizza Runner made so far if there are no delivery fees?
````sql
WITH pricing_cte as
(
SELECT	c.order_id,c.customer_id,c.pizza_id,r.runner_id,c.extras,
        c.order_time,r.pickup_time, r.duration, r.distance,
				CASE
				WHEN c.pizza_id = 1 Then 12
				ELSE 10
				END AS cost
FROM		t_customer_orders as c
				 JOIN t_runner_orders AS r
					ON c.order_id = r.order_id
WHERE		r.distance != 0
)

SELECT	SUM(cost) as sum_pizza_cost
FROM		pricing_cte;
````
### ANSWER: 

 | sum_pizza_cost |
 | -------------- |
 |  138           |
 
 The Pizza Runner so far made $138, with no charge for changes and delivery.
***
### 2. What if there was an additional $1 charge for any pizza extras? -Add cheese is $1 extra
````sql
WITH pricing_cte as
(
SELECT			c.order_id,c.customer_id,c.pizza_id,r.runner_id,c.order_time,c.extras,
				r.pickup_time, r.duration, r.distance,
				CASE
				WHEN c.pizza_id = 1 Then 12
				ELSE 10
				END AS cost,
				CASE
	  			WHEN c.extras ISNULL or c.extras = '' THEN 0
	   			ELSE (LENGTH(c.extras) - LENGTH(REPLACE(c.extras, ',','')) +1)
	   			END as no_of_extras
				
FROM			t_customer_orders as c
					JOIN t_runner_orders AS r
						ON c.order_id = r.order_id
WHERE			r.distance != 0
)

SELECT			order_id, pizza_id, extras,((no_of_extras * 1)+cost) as cost_w_surcharge
FROM			pricing_cte;
````
### ANSWER:

| order_id | pizza_id | extras | cost_w_surcharge |
| -------- | -------- | ------ | ---------------- |
| 1    |  1  |       | 12  |
| 2    |  1  |       | 12  |
| 3    |  2  |       | 10  |
| 3    |  1  |       | 12  |
| 4    |  2  |       | 10  |
| 4    |  1  |       | 12  |
| 4    |  1  |       | 12  |
| 5    |  1  | 1     | 13  |
| 7    |  2  | 1     | 11  |
| 8    |  1  |       | 12  |
| 10   |  1  | 1,4   | 14  |
| 10   |  1  |       | 12  |
***

### 3. The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
````sql
CREATE TABLE ratings (
 "order_id" INTEGER,
  "customer_id" INTEGER,
	"runner_id" INTEGER,
	"ratings" INTEGER,
	"rating_time" TIMESTAMP
)
DROP TABLE ratings
INSERT INTO ratings
 ( "order_id", "customer_id", "runner_id","ratings","rating_time")
 VALUES
  ('1', '101', '1', '4', '2020-01-01 19:45:22'),
  ('2', '101', '1', '4', '2020-01-01 21:03:52'),
  ('3', '102', '1', '5','2020-01-03 08:51:20'),
  ('4', '103', '2', '5','2020-01-04 16:20:26'),
  ('5', '104', '3', '4','2020-01-09 10:00:29'),
  ('7', '105', '2', '4','2020-01-08 23:40:29'),
  ('8', '102', '2', '5','2020-01-10 22:20:13'),
  ('10', '104', '1', '5','2020-01-11 20:36:39');
````
To see the new ratings table
````sql
SELECT    *
FROM      ratings;
````
### 4. Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?
- customer_id
- order_id
- runner_id
- rating
- order_time
- pickup_time
- time between order and pickup
- delivery duration
- average speed
- total number of pizzas
````sql
SELECT			co.customer_id, co.order_id, ro.runner_id, co.order_time, ro.pickup_time,
				rt.ratings, ROUND(EXTRACT(epoch FROM ro.pickup_time - co.order_time)/60::NUMERIC, 2) as
				time_between_order_and_pickup, ro.duration as delivery_duration,
				ROUND(CAST(AVG(ro.distance/ro.duration *60) AS NUMERIC), 2) as average_speed,
				count(co.pizza_id) as total_number_of_pizzas
FROM			t_runner_orders as ro
				JOIN t_customer_orders as co
					ON ro.order_id = co.order_id
				JOIN ratings as rt
				 	ON ro.order_id = rt.order_id
WHERE			ro.distance != 0
GROUP BY		ro.runner_id, co.customer_id, co.order_id,co.order_time, ro.pickup_time,
				rt.ratings, time_between_order_and_pickup, delivery_duration
ORDER BY		co.order_id, co.customer_id;
````
### ANSWER

| customer_id | order_id | runner_id | order_time | pickup_time | ratings | time_between_order_and_pickup | delivery_duration | average_speed | total_number_of_pizzas |
| ----------- | --------- | -------- | ---------- | ----------- | ------- | -------------- | --------- | --------- | --------- |
| 101 | 1 | 1 | 2020-01-01 18:05:02 | 2020-01-01 18:15:34 | 4 | 10.53 | 32 | 37.50 | 1 |
| 101 | 2 | 1 | 2020-01-01 19:00:52 | 2020-01-01 19:10:54 | 4 | 10.03 | 27 | 44.44 | 1 |
| 102 | 3 | 1 | 2020-01-02 23:51:23 | 2020-01-03 00:12:37 | 5 | 21.23 | 20 | 40.20 | 2 |
| 103 | 4 | 2 | 2020-01-04 13:23:46 | 2020-01-04 13:53:03 | 5 | 29.28 | 40 | 35.10 | 3 |
| 104 | 5 | 3 | 2020-01-08 21:00:29 | 2020-01-08 21:10:57 | 4 | 10.47 | 15 | 40.00 | 1 |
| 105 | 7 | 2 | 2020-01-08 21:20:29 | 2020-01-08 21:30:45 | 4 | 10.27 | 25 | 60.00 | 1 |
| 102 | 8 | 2 | 2020-01-09 23:54:33 | 2020-01-10 00:15:02 | 5 | 20.48 | 15 | 93.60 | 1 |
| 104 | 10 | 1 | 2020-01-11 18:34:49 | 2020-01-11 18:50:20 | 5 | 15.52 | 10 | 60.00 | 2 |

***
### 5. If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled how much money does Pizza Runner have left over after these deliveries?
````sql
WITH gross_income as
(
 SELECT		pn.pizza_name,
 			CASE
            WHEN pizza_name = 'Meatlovers' THEN COUNT(pizza_name) * 12
            ELSE COUNT(pizza_name) * 10
            END AS gross_income
FROM		t_customer_orders AS co
    		 JOIN pizza_names AS pn 
				ON co.pizza_id = pn.pizza_id
    		 JOIN t_runner_orders AS ro 
				ON co.order_id = ro.order_id
WHERE		ro.distance != 0
            AND ro.duration != 0
GROUP BY	1
),
expense as
(
SELECT		sum(distance * 0.3) as expense
FROM		t_runner_orders
WHERE		distance != 0
            AND duration != 0
)
SELECT		SUM(gross_income) - expense as net_profit
FROM		gross_income, expense
GROUP BY	expense;
````
#### ANSWER

| net_profit |
| ---------- |
| 94.44      |
***

