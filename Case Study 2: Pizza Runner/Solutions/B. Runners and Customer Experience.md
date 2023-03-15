# 🏃 👩‍💻 Runner and Customer Experience
## [Solution](#solution) 🗒️

### 1. How many runners signed up for each 1-week period? (i.e.week starts 2021-01-01)
````sql
SELECT					trim('eek' from to_char(registration_date, 'week')) as registration_week,
						count(runner_id) as runners_signed_up
FROM					runners
GROUP BY				1
ORDER BY				2 DESC;
````
#### Answer
| registration_week | runners_signed_up |
| ----------------- | ---------------- |
| 1 | 2 |
| 2 | 1 |
| 3 | 1 |

- On the 1st week of January, 2 runners signed up.
- On 2nd and 3rd week of January, only 1 runner signed up.
***

### 2. What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
````sql
SELECT					r.runner_id, 
						ROUND(AVG(EXTRACT(minutes from (r.pickup_time - c.order_time))))as runner_time
FROM					t_customer_orders as c
							JOIN t_runner_orders as r
								ON c.order_id = r.order_id
WHERE						r.distance != 0
GROUP BY				1 
ORDER BY				2;

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
GROUP BY		runner_id;
````
#### Answer
| runner_id | average_time |
| --------- | ------------- |
| 3 | 10 |
| 2 | 23 |
| 1 | 15 |

- Runner_id 3 took an average of 10 minutes to reach the HQ to pickup the order.
- Runner_id 2 took an averag of 23 minutes to reach the HQ to pickup the order.
- Runner_id 1 took an average of 15 minutes to reach the HQ to pickup the order.
***

### 3. Is there any relationship between the number of pizzas and how long the order takes to prepare?
````sql
SELECT * FROM t_customer_orders
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
````
#### Answer

| pizza_ordered | avg_prep_time_minutes |
| ------------- | ----------------|
| 1 | 12 |
| 2 | 12 | 
| 3 | 29 |

- It takes 12 minutes on average to prepare a single pizza.
- It takes 29 minutes on average to prepare an order with 3 pizzas
- On average it takes 18 minutes to prepare an order with 2 pizzas, which is 9 minutes per pizza. Therefore, making 2 pizzas in a single order is efficient rate.
***

### 4. What was the average distance travelled for each customer?
````sql
SELECT		c.customer_id, round(avg(r.distance)) as avg_distance_travelled
FROM		t_runner_orders as r
				JOIN t_customer_orders as c
					ON r.order_id = c.order_id
WHERE		r.duration != 0
GROUP BY	c.customer_id
ORDER BY	c.customer_id;
````
#### Answer

| customer_id | avg_distance_travelled |
| ----------- | -------------|
| 101 | 20 |
| 102 | 17 |
| 103 | 23 |
| 104 | 10 |
| 105 | 25 |

Based on the average distance calculated, customer_id 104 lives closest out of all and customer_id 105 lives the farthest. 
***

### 6. What was the average speed for each runner for each delivery and do you notice any trend for these values?
````sql
SELECT		r.runner_id, r.order_id, c.customer_id,count(c.pizza_id) as pizzas_ordered,
            r.distance as distance, ROUND((r.duration/ 60.0),2) as duration_hour,
			ROUND(CAST(AVG(r.distance/r.duration *60) AS NUMERIC), 2) as avg_speed
			
FROM		t_runner_orders as r
				JOIN t_customer_orders as c
					ON r.order_id = c.order_id
WHERE		r.duration != 0
GROUP BY	r.runner_id, r.order_id, c.customer_id,r.distance, duration_hour
ORDER BY	r.runner_id, r.order_id, c.customer_id;
````
#### Answer
| runner_id | order_id | customer_id | pizzas_ordered | distance | duration_hour | avg_speed |
| --------- | -------- | ------------| -------------- | -------- | ------------- | --------- |
| 1 | 1 | 101 | 1 | 20 | 0.53 | 37.50 |
| 1 | 2 | 101 | 1 | 20 | 0.45 | 44.44 |
| 1 | 3 | 102 | 2 | 13.4 | 0.33 | 40.20 |
| 1 | 10 | 104 | 2 | 10 | 0.17 | 60.00 |
| 2 | 4 | 103 | 3 | 23.4 | 0.67 | 35.10 |
| 2 | 7 | 105 | 1 | 25 | 0.42 | 60.00 |
| 2 | 8 | 102 | 1 | 23.4 | 0.25 | 93.60 |
| 3 | 5 | 104 | 1 | 10 | 0.25 | 40.00 |

- The average speed of Runner 1 falls within the range of 37.50 km/hr to 60 km/hr.
- Runner 2 has an average speed that ranges from 35.10 km/hr to 93.60 km/hr. 
- Notably, the average speed for Runner 2 changed by a factor of 3 when the distance remained the same.
- Runner 3 has maintained an average speed of 40 km/hr.



