---A. Pizza Metrics---
---1. How many pizzas were ordered?---

SELECT			count(*)as total_pizza_ordered
FROM 			  t_customer_orders;

---ANSWER:Total of 14 pizzas were ordered-----

--2.How many unique customer orders were made?----
SELECT			count(distinct order_id) as unique_orders
FROM			  t_customer_orders;

--ANSWER: 10 unique customer orders were made.--------

--3.How many successful orders were delivered by each runner?---

SELECT		  runner_id, count(order_id) as successful_delivery
FROM		    t_runner_orders
WHERE		    distance != 0
GROUP BY	  runner_id
ORDER BY	  runner_id;

--ANSWER: Runner_id 1 delivered 4 orders, runner_id 2 delivered 3 and runner_id delivered only 1 order.--

---4. How many of each type of pizza was delivered?--

SELECT			 p.pizza_name, count(c.order_id) as pizza_ordered_delivered
FROM			   t_customer_orders as c
					    JOIN pizza_names as p
						   ON c.pizza_id = p.pizza_id
					    JOIN t_runner_orders as r
						   ON r.order_id = c.order_id
WHERE        r.distance != 0
Group by		 p.pizza_name
ORDER BY		 2 desc;

---ANSWER: 9 meatlovers pizzas were delivered and 3 Vegetarian pizzas were delivered.---

---------5. How many Vegetarian and Meatlovers were ordered by each customer?---

SELECT			  c.customer_id, p.pizza_name, count(c.order_id) as pizza_ordered
FROM          t_customer_orders as c
					     JOIN pizza_runner.pizza_names as p
						    ON c.pizza_id = p.pizza_id
GROUP BY		  c.customer_id, p.pizza_name
ORDER BY		  c.customer_id, pizza_ordered DESC;

--Answer:

--customer_id 101 ordered 2 Meat Lovers and 1 Vegetarian pizzas.
--customer_id 102 ordered 2 Meat Lovers and 1 Vegetarian pizzas.
--customer_id 103 ordered 3 Meat lovers and 1 Vegetarian pizzas.
--customer_id 104 orderd 3 Meat Lovers pizzas.
--cuctomer_id 105 ordered 1 Vegetarian pizza.

--6. What was the maximum number of pizzas delivered in a single order?---

WITH pizza_number_cte as
(
SELECT			 c.order_id, count(c.pizza_id) as pizza_per_order
FROM			   t_customer_orders as c
					    JOIN t_runner_orders as r
						   ON c.order_id = r.order_id
WHERE			   r.duration != 0
GROUP BY		 c.order_id
ORDER BY		 c.order_id
)
SELECT 			 MAX(pizza_per_order)
FROM			   pizza_number_cte

--ANSWER: 

--Maximum of 3 pizzas were delivered in one single order.

-------------------------------------------------------------

---7.For each customer, how many delivered pizzas had at least 1 change and how many had no changes?--
SELECT			     c.customer_id,
				         SUM
				         (
				          CASE 
					        WHEN c.exclusion != '' OR c.extras != '' THEN 1
					        ELSE 0
					        END) as at_least_one,
				         SUM
				        (
				         CASE 
					       WHEN c.exclusion = '' AND c.extras = '' THEN 1 
					       ELSE 0
					       END )as no_change
				
FROM			      t_customer_orders as c
					       JOIN t_runner_orders as r
					        ON c.order_id = r.order_id
WHERE			      r.distance != 0
GROUP BY		    c.customer_id
ORDER BY 	    	c.customer_id;

ANSWER: 

--customer_id 101 had placed 2 orders with no changes. 
--customer_id 102 had placed 3 orders with no changes.
--customer_id 103 had placed 3 orders with at least one changes.
--customer_id 104 had placed 3 orders, 1 with no changes and 2 with at least one changes.
--customer_id 105 had placed 1 order with at least one changes.
--------------------------------------------------------------------------------------------------------

--8.How many pizzas were delivered that had both exclusions and extras?----------

SELECT			SUM 
				   (
				   CASE WHEN c.exclusion IS NOT NULL AND c.extras IS NOT NULL THEN 1
				   ELSE 0
				   END ) as pizza_w_extras_exclusion
FROM			t_customer_orders as c
					 JOIN t_runner_orders as r
					  ON c.order_id = r.order_id
WHERE			r.distance != 0 AND c.exclusion != '' and c.extras != '';
--------------------------------OR-------------------------------------------------

SELECT			count(c.order_id) as pizzas_w_exclusion_extras
FROM			  t_customer_orders as c
					   JOIN t_runner_orders as r
						  ON c.order_id = r.order_id
WHERE			   r.distance != 0 
				    AND
				     c.exclusion != ''
				    AND
				     c.extras != '';

--ANSWER:
--Only 1 order had both extras and exclusions.

--------------------------------------------------------------------------------------
---9.What was the total volume of pizzas ordered for each hour of the day?----

-- SELECT * FROM t_customer_orders;---

SELECT			date_part ('hour', order_time) as hour,
				    count(order_id) as number_of_orders
FROM			  t_customer_orders
GROUP BY		date_part ('hour', order_time)
ORDER BY		date_part ('hour', order_time) ASC;

---ANSWER: 
--The highest volume of pizzas ordered is at 13:00 hour, 21:00 hour and 23:00 hour.
--The lowest volume of pizza ordered is at 11:00 hour and 19:00 hour.

--------------------------------------------------------------------------------------
--10.What was the volume of orders for each day of the week?---
SELECT			 extract(dow from order_time) as "day of week",
				     to_char(order_time, 'Day') as "Day Name", 
				     count(order_id) as volume_of_orders
from			   t_customer_orders
GROUP BY		 extract(dow from order_time) ,
				     to_char(order_time, 'Day') 
ORDER BY		 3 DESC;

---ANSWER: 

--Pizza runner received 5 orders on Wednesday and Saturday.
--It received 3 orders on Thursday and 1 order on Friday.
-------------------------------------------------------------------------------------
