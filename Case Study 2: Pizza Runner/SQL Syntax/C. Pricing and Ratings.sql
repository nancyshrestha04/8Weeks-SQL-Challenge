---------------------------------------------------------------------------------------------------------------------
-------D.Pricing and Ratings------
---1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there 
--were no charges for changes - how much money has Pizza Runner made so 
----far if there are no delivery fees?
WITH pricing_cte as
(
SELECT			c.order_id,c.customer_id,c.pizza_id,r.runner_id,c.extras, c.order_time,
				r.pickup_time, r.duration, r.distance,
				CASE
				WHEN c.pizza_id = 1 Then 12
				ELSE 10
				END AS cost
FROM			t_customer_orders as c
					JOIN t_runner_orders AS r
						ON c.order_id = r.order_id
WHERE			r.distance != 0
)

SELECT		SUM(cost) as sum_pizza_cost
FROM		pricing_cte;
 
----A. The Pizza Runner so far made $138, with no charge for changes and delivery.
-------------------------------------------------------------------------------------------
---2.What if there was an additional $1 charge for any pizza extras?
----Add cheese is $1 extra

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

--------------------------------------------------------
--3.The Pizza Runner team now wants to add an additional ratings system that 
---allows customers to rate their runner, how would you design an additional table 
---for this new dataset - generate a schema for this new table and insert your own 
---data for ratings for each successful customer order between 1 to 5.

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

SELECT *
FROM ratings

-------------------------------------------------
-------------------------------------------------
--4.Using your newly generated table - can you join all of the 
------information together to form a table which has the following information 
-----for successful deliveries?
-- customer_id
-- order_id
-- runner_id
-- rating
-- order_time
-- pickup_time
-- Time between order and pickup
-- Delivery duration
-- Average speed
-- Total number of pizzas

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
-----------------------------------------------------------------
--5.If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with 
--no cost for extras and each runner is paid $0.30 per kilometre traveled
---how much money does Pizza Runner have left over after these deliveries?

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
--------------------------------------------------------------------------------------------
