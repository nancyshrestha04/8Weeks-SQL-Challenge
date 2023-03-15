-------------------------------------------------------------------------------------
----------------B. RUNNER AND CUSTOMER EXPERINCE-------------------------------------

-- 1. How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)--

SELECT					trim('eek' from to_char(registration_date, 'week')) as registration_week,
						count(runner_id) as runners_signed_up
FROM					runners
GROUP BY				1
ORDER BY				2 DESC;

--ANSWER: On the 1st week of January, 2 runners signed up.
----------ON 2nd and 3rd week of January, only 1 runner signed up.

-- 2.What was the average time in minutes it took for each runner to 
----------arrive at the Pizza Runner HQ to pickup the order?----------

SELECT					r.runner_id, 
						ROUND(AVG(EXTRACT(minutes from (r.pickup_time - c.order_time))))as runner_time
FROM					t_customer_orders as c
							JOIN t_runner_orders as r
								ON c.order_id = r.order_id
WHERE						r.distance != 0
GROUP BY				1 
ORDER BY				2 

----------------OR--------------------------

WITH runner_time_cte as
(
SELECT			r.runner_id, r.pickup_time, c.order_time,
				extract(minutes from (r.pickup_time - c.order_time)) as runner_time_minutes
FROM			t_customer_orders as c
					JOIN t_runner_orders as r
						ON c.order_id= r.order_id
WHERE			r.distance !=0
)

SELECT			runner_id, ROUND(AVG(runner_time_minutes)) as average_time
FROM			runner_time_cte
GROUP BY		runner_id

--ANSWER: Runner_id 3 took an average of 10 minutes to reach the HQ to pickup the order.
----------Runner_id 2 took an averag of 23 minutes to reach the HQ to pickup the order.
----------Runner_id 1 took an average of 15 minutes to reach the HQ to pickup the order.
-------------------------------------------------------------------------------------------------

--3.Is there any relationship between the number of pizzas and how long the order takes to prepare?

WITH prep_time_cte as
(
SELECT		c.order_id,count(c.pizza_id) as pizza_ordered, c.order_time, r.pickup_time,
	        extract('minutes' from (r.pickup_time - c.order_time)) as prep_time_minutes	        
FROM		t_customer_orders as c
			JOIN t_runner_orders as r
				ON c.order_id = r.order_id
WHERE		r.distance !=0
GROUP BY	c.order_id , c.order_time, r.pickup_time, prep_time_minutes
ORDER BY	c.order_id
)
SELECT		pizza_ordered, ROUND(AVG(prep_time_minutes)) as avg_prep_time_minutes
FROM		prep_time_cte
GROUP BY	pizza_ordered
ORDER BY	pizza_ordered;

--ANSWER: It takes 12 minutes on average to prepare a single pizza.
----------It takes 29 minutes on average to prepare an order with 3 pizzas
----------On average it takes 18 minutes to prepare an order with 2 pizzas, which is 9 minutes
-------------per pizza. Therefore, making 2 pizzas in a single order is efficient rate.

-- 4.What was the average distance travelled for each customer?-----

SELECT		c.customer_id, round(avg(r.distance)) as avg_distance_travelled
FROM		t_runner_orders as r
				JOIN t_customer_orders as c
					ON r.order_id = c.order_id
WHERE		  r.duration != 0
GROUP BY	c.customer_id
ORDER BY	c.customer_id;

--ANSWER: Based on the average distance calculated, customer_id 104 lives closest out of all and 
----------customer_id 105 lives the farthest. 

--  5. What was the difference between the longest and shortest delivery times for all orders?

SELECT		MAX(duration) as longest_delivery_time,
			MIN(duration) as shortest_delivery_time,
			(MAX(duration)- MIN(duration)) as difference
FROM		t_runner_orders
WHERE		duration != 0

--  ANSWER: The longest delivery time is 40 minutes and shortest is 10 minutes and 
------------the difference between them is 30 minutes.

--  6.What was the average speed for each runner for each delivery and 
-- ---do you notice any trend for these values?

SELECT		r.runner_id, r.order_id, c.customer_id,count(c.pizza_id) as pizzas_ordered,
            r.distance as distance, ROUND((r.duration/ 60.0),2) as duration_hour,
			ROUND(CAST(AVG(r.distance/r.duration *60) AS NUMERIC), 2) as avg_speed
			
FROM		t_runner_orders as r
				JOIN t_customer_orders as c
					ON r.order_id = c.order_id
WHERE		r.duration != 0
GROUP BY	r.runner_id, r.order_id, c.customer_id,r.distance, duration_hour
ORDER BY	r.runner_id, r.order_id, c.customer_id;

-- -ANSWER: The average speed of Runner 1 falls within the range of 37.50 km/hr to 60 km/hr.
-- Runner 2 has an average speed that ranges from 35.10 km/hr to 93.60 km/hr. 
-- Notably, the average speed for Runner 2 changed by a factor of 3 when the distance remained the same.
-- Runner 3 has maintained an average speed of 40 km/hr.
-- This information can help us identify the performance levels of each runner and could be used to provide 
-- feedback and training to improve the performance of the runners if necessary.

-----7. What is the successful delivery percentage for each runner?

WITH success_percent_cte as
(
SELECT  order_id,runner_id,
		case WHEN
		distance = 0 THEN 0
		ELSE 1
		END as delivery_status
FROM	t_runner_orders
)
SELECT		runner_id, (100 * SUM(delivery_status)/count(order_id)) as delivery_percentage
FROM		success_percent_cte
GROUP BY	runner_id
ORDER BY	runner_id;

-- ANSWER : Runner 1 has achieved a delivery success rate of 100%, which is the highest among all the runners. 
-- Runner 2 has the second-highest delivery success rate, while Runner 3 has the lowest delivery success rate. 
-- This information can help us identify the top-performing runners and 
-- the areas where the lower-performing runners may need improvement to enhance their delivery success rates.
