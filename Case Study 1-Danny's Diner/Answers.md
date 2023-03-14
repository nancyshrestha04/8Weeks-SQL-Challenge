# 🥢 🍜 Danny's Diner SQL Challenge

## Answers
* Tool used: PostgreSQL
* Functions Used: 
  * Aggregate Functions- SUM,COUNT
  * Joins- INNER JOIN, LEFT JOIN, RIGHT JOIN
  * DATE Functions- DATE, DATE_TRUNC
  * Common Table Expressions (CTE)
***
### 1. What is the total amount each customer spent at the restaurant?

````sql
SELECT              s.customer_id, sum(m.price) as amount_spent
From                 sales as s 
		INNER JOIN menu as m ON  s.product_id=m.product_id
GROUP BY        s.customer_id
ORDER BY	s.customer_id;
````
#### Steps:
- Used SUM, GROUP BY and ORDER BY functions to fins the total amount spent by each customer.
- Used INNER JOIN function to join **sales** and **menu** tables using _product_id_ as joining key.\

#### ANSWER

| customer_id | total_sales |
| ----------- | ----------- |
| A           | 76          |
| B           | 74          |
| C           | 36          |

- Customer A spent $76
- Customer B spent $74
- Customer C spent $36

***
2. How many days has each customer visited the restaurant?

````sql
SELECT           customer_id, count (distinct order_date) as  days_visited
FROM 	          sales
Group by       customer_id
ORDER BY     count (distinct order_date) desc;
````
#### Steps
- Used DISTINCT function wrapped with COUNT function to find the total number of days visited by each customer.
- Used GROUP BY and ORDER BY functions as aggregate function to keep number of times visited in descending order.

#### ANSWER

| Customer_id | days_visited |
| ----------- | ------------ |
| B           | 6            |
| A           | 4            |
| C           | 2            |


- Customer B visited 6 times.
- Customer A visited 4 times.
- Customer C visited 2 times.
***
3.  What was the first item from the menu purchased by each customer?

````sql
-----first item ordered by 'A'

SELECT               s.customer_id, m.product_id, m.product_name
FROM                sales as s
	              join menu as m ON s.product_id = m.product_id
WHERE             s.customer_id = 'A'
Order By           s.order_date asc, m.product_id ASC
LIMIT 2;

-----first item ordered by 'B'

SELECT		s.customer_id, m.product_id, m.product_name
FROM		sales as s
			JOIN menu as m  ON  s.product_id = m.product_id
WHERE		s.customer_id = 'B'
ORDER BY	s.order_date ASC, m.product_id ASC
LIMIT                1;

-----first item ordered by 'C'

SELECT		s.customer_id, m.product_id, m.product_name
FROM 		sales as s 
            JOIN  menu as m   ON  s.product_id = m.product_id
WHERE              s.customer_id = 'C'
ORDER BY	s.order_date ASC, m.product_id ASC
LIMIT		1;
````
#### Steps
Wrote separate querries for each customers using WHERE clause

#### Answer

###### Customer A

| customer_id | product_id | product_name |
| ----------- | ---------- | ------------ |
| A           | 1          | sushi        |
| A           | 2          | curry        |

###### Customer B

| customer_id | product_id | product_name |
| ----------- | ---------- | ------------ |
| B           | 2          | curry        |

###### Customer C

| customer_id | product_id | product_name |
| ----------- | ---------- | ------------ |
| C           | 3          | ramen        |

- Customer A purchased _sushi_ and _ramen_ first.
- Customer B purchased _curry_ first.
- Customer C purchased _ramen_ first.
***
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
````sql
SELECT		m.product_name, count(m.product_name) as times_purchased
FROM 		  sales as s
		  INNER JOIN menu as m  ON  
                            s.product_id=     m.product_id
GROUP BY	m.product_name
ORDER BY	2 DESC
LIMIT		1;
````
#### Steps
- Used COUNT function and GROUP BY function to find the ost popular item on the menu and number of times it was purchased.
- Used ORDER BY function to sort the most purchased item in DESC order and set LIMIT as 1.

#### Answer 

| product_name | times_purchased |
| ------------ | --------------- |
| ramen        | 8               |

- Most popular item on the menu is _ramen_.
- It was purchased **8** times.
***
5.  Which item was the most popular for each customer?
````sql
-----By 'A'

SELECT	           s.customer_id, m.product_name, count(m.product_name) 
                        as times_purchased
FROM 	           sales as s
			INNER JOIN menu as m  ON   s.product_id= m.product_id
WHERE	s.customer_id = 'A'
GRoup by	s.customer_id, m.product_name
order by	3 DESC;

-----By 'B'

SELECT		s.customer_id, m.product_name, count(m.product_name) as times_ordered
FROM		sales as s
                                   INNER join menu as m ON   s.product_id = m.product_id
WHERE	s.customer_id = 'B'
GROUP BY	s.customer_id, m.product_name
order By	3 DESC;

-----By 'C'

SELECT		s.customer_id, m.product_name, count(m.product_name) as times_ordered
FROM		sales as s
                                INNER join menu as m ON  s.product_id = m.product_id
WHERE	s.customer_id = 'C'
GROUP BY	s.customer_id, m.product_name
order By	3 DESC;
````
#### Steps:
 Wrote separate querries for each customers using WHERE clause.

#### Answer:
 
| customer_id | product_name | times_purchased |
| ----------- | ------------ | --------------- |
| A           | ramen        | 3               |
| A           | curry        | 2               |
| A           | sushi        | 1               |

| customer_id | product_name | times_purchased |
| ----------- | ------------ | --------------- |
| B           | ramen        | 2              |
| B           | curry        | 2               |
| B           | sushi        | 2              |

| customer_id | product_name | times_purchased |
| ----------- | ------------ | --------------- |
| C           | ramen        | 3               |

-	A and C’s most favourite item is _ramen_.
-	B likes all the items in the menu equally.
***
6.  Which item was purchased first by the customer after they became a member?
````sql
WITH members_sales_cte as
(
SELECT		s.customer_id, s.order_date, m.join_date, s.product_id,
		DENSE_RANK () OVER (PARTITION BY s.customer_id 
ORDER BY s.order_Date) as Rank
FROM		sales as s
			JOIN members as m 
			ON s.customer_id = m.customer_id
WHERE	s.order_date >= m.join_date
)
SELECT		m1.customer_id, m1.order_date, m.product_name,m1.rank
FROM		members_sales_cte as m1
			JOIN menu as m 
			ON m1.product_id = m.product_id
WHERE	m1.rank = 1
ORDER BY	m1.customer_id;
````
#### Steps
- Created CTE and used **DENSE_RANK and OVER(Partition By ORDER BY)** function to create a new column _rank_ based on **order_date**.
- Filtered order_date to be on _or_ after the join_date to find items ordered after the customer became a member.
- Filtered the table using _WHERE rank = 1_ clause to retrieve the first item purchased by the customer after becoming member.

#### Answer

| customer_id | order_date | product_name | rank |
| ----------- | ---------- | ------------ | ---- |
| A           | 2021-01-07 | curry        | 1    |
| B           | 2021-01-11 | sushi        | 1    |

-	Customer A first ordered _curry_ after becoming a member at Dannys Diner.
-	Customer B first ordered _sushi_ after becoming a member at Dannys Diner.

7. Which item was purchased just before the customer became a member?
````sql
WITH members_sales_cte as
(
SELECT		s.customer_id, s.order_date, m.join_date, s.product_id,
		DENSE_RANK () OVER (PARTITION BY s.customer_id 
                          ORDER BY s.order_date desc) as RANK
FROM 		sales as s
		    JOIN members as m ON s.customer_id = m.customer_id
WHERE	s.order_date < m.join_date
)

SELECT		m1.customer_id, m1.order_date, m1.join_date, 
                           m2.product_name
FROM 		members_sales_cte as m1
		     JOIN menu as m2 ON m1.product_id = m2.product_id
WHERE	m1.rank=1
ORDER BY	m1.customer_id, m1.order_date desc;
````
#### Steps
- Created CTE and used **DENSE_RANK() OVER(PARTITION BY ORDERED BY)** function to create a _rank_ column based on order_date but in descending order since we are finding the item ordered just before the customer became a member.
- Used WHERE = 1 to find the item ordered by each customer just before becoming a member.

#### Answer

| customer_id | order_date | join_date   | product_name |
| ----------- | ---------- | ----------- | ------------ |
| A           | 2021-01-01 | 2021-01-07  | sushi        |
| A           | 2021-01-01 | 2021-01-07  | curry        |
| B           | 2021-01-04 | 2021-01-04  | sushi        |

- Customer A ordered _sushi_ and _curry_ just before becoming a member while Customer B ordered _sushi_.









 














