# :pizza: Pizza Runner SQL Challenge
<img src="https://user-images.githubusercontent.com/81607668/127271856-3c0d5b4a-baab-472c-9e24-3c1e3c3359b2.png" alt="Image" width="500" height="520">

## :bucket: Table of Contents
- [Background](#background)
- [Problem Statement](#problem-statement)
- [Entity Relationship Diagram](#entity-relationship-diagram)
- [Table Relationship and Description](#table-relationship-and-description)
- [Case Study Questions](#case-study-questions)
  1. Pizza metrics
  2. Runner and Customer Experience
  3. Pricing and ratings
  4. Bonus Question

***

## Background
Danny wanted to open a new Pizza business and to expand his new Pizza empire, he planned to Uberize it, that’s how ‘Pizza Runner’ was launched.
Danny started by recruiting “runners” to deliver fresh pizza from Pizza Runner Headquarters (otherwise known as Danny’s house) and maxed out his credit card to pay freelance developers to build a mobile app to accept orders from customers.
***

## Problem Statement
The data for Pizza Runner is unclean and lacks proper calculations, resulting in inefficiencies in the company's operations. Danny needs help to clean the data and perform basic calculations to better direct the runners and optimize operations. The goal is to provide a foundation for data-driven decision making and increase the company's success.
***

## Entity Relationship Diagram
![image](https://user-images.githubusercontent.com/81607668/127271531-0b4da8c7-8b24-4a14-9093-0795c4fa037e.png)
***

## Table Relationship and Description
### 1. **runners**
The ``runners`` table shows the ``registration_date`` for each new runner.

### 2. **customer_orders**
-	The ``customer_orders`` table capture customer pizza orders with 1 row for each individual pizza that is part of the order.
-	The ``pizza_id`` relates to the type of pizza which was ordered.
-	The ``exclusion`` is the ``topping_id`` values which should be removed from the pizza while the ``extras`` are the ``topping_id`` values which need to be added to the pizza.

#### Note: Customers can order multiple pizza in a single order with varying exclusion and extras values even if the pizza is the same type.

### 3. **runner_orders**
-	The runner_orders table captures the information of pizza orders that are assigned to runners.
- Each runner has their respective ``runner_id``.
-	The ``pickup_time`` is the timestamp at which the runner arrives at the Pizza Runner headquarters to pick up the freshly cooked pizzas.
-	The ``distance`` and ``duration`` fields are related to how far and long the runner had to travel to deliver the order to the respective customer.

### 4. **pizza_names**
Currently, Pizza Runner only has 2 pizzas available the Meat Lovers and Vegetarian with ``pizza_id`` 1 and 2 respectively.

### 5. **pizza_recipes**
Each ``pizza_id`` has a standard set of ``toppings`` which are used as part of the pizza recipe.

### 6. **pizza_toppings**
This table contains all the ``topping_name`` values with their corresponding ``topping_id`` value.
***

## Case Study Questions
The questions are divided as area of focus including:
- [Pizza Metrics](#pizza-metrics)
- [Runner and Customer Experience](#runner-and-customer-experience)
- [Pricing and Ratings](#pricing-and-ratings)
- [Bonus Question](#bonus-question)

#### Note: _The data needs cleaning including the null values in the customer_orders table and altering the data types in the customer_orders and runner_orders table._
***

### Pizza Metrics

1.	How many pizzas were ordered?
2.	How many unique customer orders were made?
3.	How many successful orders were delivered by each runner?
4.	How many of each type of pizza was delivered?
5.	How many Vegetarian and Meat Lovers were ordered by each customer?
6.	What was the maximum number of pizzas delivered in a single order?
7.	For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
8.	How many pizzas were delivered that had both exclusions and extras?
9.	What was the total volume of pizzas ordered for each hour of the day?
10.	What was the volume of orders for each day of the week?

### Runner and Customer Experience

1.	How many runners signed up for each 1-week period? (i.e.week starts 2021-01-01)
2.	What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pick up the order?
3.	Is there any relationship between the number of pizzas and how long the order takes to prepare?
4.	What was the average distance travelled for each customer?
5.	What was the difference between the longest and shortest delivery times for all orders?
6.	What was the average speed for each runner for each delivery and do you notice any trend for these values?
7.	What is the successful delivery percentage for each runner?

### Pricing and Ratings

1. If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees?
2.	What if there was an additional $1 charge for any pizza extras?
    *	Add cheese is $1 extra.
3.	The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own data for ratings for each successful customer order between 1 to 5.
4.	Using your newly generated table - can you join all the information together to form a table which has the following information for successful deliveries?
    *	customer_id
    *	order_id
    *	runner_id
    *	rating
    *	order_time
    *	pickup_time
    *	Time between order and pickup
    *	Delivery duration
    *	Average speed
    *	Total number of pizzas
5.	If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre travelled - how much money does Pizza Runner have left over after these deliveries?

### Bonus Question

If Danny wants to expand his range of pizzas - how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?



















