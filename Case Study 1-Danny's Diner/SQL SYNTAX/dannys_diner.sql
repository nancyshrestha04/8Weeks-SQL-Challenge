----CASE STUDY 1: DANNY'S DINER----

--Author: Nancy Shrestha
--Tool Used: PgAdmin and PostgreSQL

CREATE SCHEMA dannys_diner;

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu
  ("product_id", "product_name", "price")
VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  

 CREATE TABLE sales (
  "customer_id" VARCHAR(1),
  "order_date" DATE,
  "product_id" INTEGER);
  
 INSERT INTO sales ("customer_id", "order_date", "product_id")
 VALUES 
 ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
 
CREATE TABLE members (
  "customer_id" VARCHAR(1),
  "join_date" DATE
);

INSERT INTO members
  ("customer_id", "join_date")
VALUES
  ('A', '2021-01-07'),
  ('B', '2021-01-09');


----TO GET AN INTEGRATED INFO BY COMBINING ALL THE TABLES---

SELECT s.customer_id, s.order_date,m.product_id,
       m.product_name,m.price,c.join_date

FROM   sales as s
	 JOIN menu as m on s.product_id = m.product_id
	LEFT JOIN members as c on s.customer_id = c.customer_id
ORDER BY s.customer_id, s.order_date asc;

-----------------------------
----CASE STUDY QUESTIONS-----
-----------------------------

----1. What is the total amount each customer spent at the restaurant?
----money spent by 'A'

SELECT s.customer_id, sum(m.price) as amount_spent
From   sales as s 
				INNER JOIN menu as m ON s.product_id =m.product_id
GROUP BY  s.customer_id
ORDER BY	s.customer_id;


----2. How many days has each customer visited the restaurant?

SELECT   customer_id, count (distinct order_date) as days_visited
FROM 	sales
Group by  customer_id
ORDER BY   count (distinct order_date) desc;


----3. What was the first item from the menu purchased by each customer?


SELECT   s.customer_id, m.product_id, m.product_name
FROM sales as s
				join menu as m ON s.product_id = m.product_id
WHERE  s.customer_id = 'A'
Order By  s.order_date asc, m.product_id ASC
LIMIT 2;

---first item ordered by 'B'

SELECT		s.customer_id, m.product_id, m.product_name
FROM		sales as s
			JOIN menu as m  ON  s.product_id = m.product_id
WHERE		s.customer_id = 'B'
ORDER BY	s.order_date ASC, m.product_id ASC
LIMIT       1;

---first item ordered by 'C'

SELECT		s.customer_id, m.product_id, m.product_name
FROM 		sales as s 
            JOIN  menu as m   ON  s.product_id = m.product_id
WHERE		s.customer_id = 'C'
ORDER BY	s.order_date ASC, m.product_id ASC
LIMIT		1;


-----4. What is the most purchased item on the menu and how many 
times was it purchased by all customers?

SELECT		m.product_name, count(m.product_name) as times_purchased
FROM 		sales as s
			INNER JOIN menu as m  ON  s.product_id= m.product_id
GROUP BY	m.product_name
ORDER BY	2 DESC
LIMIT		1;


----5. Which item was the most popular for each customer?

--By 'A'


SELECT		s.customer_id, m.product_name, count(m.product_name) as times_purchased
FROM 		sales as s
			INNER JOIN menu as m  ON  s.product_id= m.product_id
WHERE		s.customer_id = 'A'
GRoup by	s.customer_id, m.product_name
order by	3 DESC;

--By 'B'

SELECT		s.customer_id, m.product_name, count(m.product_name) as times_ordered
FROM		sales as s
            INNER join menu as m ON s.product_id = m.product_id
WHERE		s.customer_id = 'B'
GROUP BY	s.customer_id, m.product_name
order By	3 DESC;

--By 'C'

SELECT		s.customer_id, m.product_name, count(m.product_name) as times_ordered
FROM		sales as s
            INNER join menu as m ON s.product_id = m.product_id
WHERE		s.customer_id = 'C'
GROUP BY	s.customer_id, m.product_name
order By	3 DESC;

----6. Which item was purchased first by the customer after they became a member?

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


----7.Which item was purchased just before the customer became a member?

WITH members_sales_cte as
(
SELECT		s.customer_id, s.order_date, m.join_date, s.product_id,
			DENSE_RANK () OVER (PARTITION BY s.customer_id ORDER BY s.order_date desc) as RANK
FROM 		sales as s
				JOIN members as m ON s.customer_id = m.customer_id
WHERE		s.order_date < m.join_date
)

SELECT		m1.customer_id, m1.order_date, m1.join_date, 
            m2.product_name
FROM 		members_sales_cte as m1
				JOIN menu as m2 ON m1.product_id = m2.product_id
WHERE		m1.rank=1
ORDER BY	m1.customer_id, m1.order_date desc;


----8.What is the total items and amount spent for each member 
before they became a member?

SELECT		s.customer_id,  Count(m.product_name) as unique_items,
                           sum(m.price) as total_spent
FROM		sales as s
		JOIN menu as m ON m.product_id = s.product_id
		JOIN members as c ON  s.customer_id = c.customer_id
WHERE	c.join_date > s.order_date
Group By	s.customer_id
order By	3 DESC;

----9. If each $1 spent equates to 10 points and sushi has a 
----2x points multiplier - how many points would each customer have?


SELECT      view1.customer_id, sum(view1.loyalty_points) as total_points
FROM    (
        SELECT	 s.customer_id,
		         CASE WHEN m.product_name = 'sushi' then 
		         m.price*20 
		         ELSE m.price*10
				 END as loyalty_points
 		FROM 	sales as s 
              JOIN menu as m ON s.product_id = m.product_id  
	 ) as view1
GROUP BY	 	view1.customer_id
ORDER BY		1, 2 desc;


----10. In the first week after a customer joins the program 
----(including their join date) they earn 2x points 
----on all items, not just sushi - 
----how many points do customer A and B have at the end of January?

WITH dates_cte AS 
(
 SELECT  *, 
         date (join_date + integer '6' )AS valid_date, 
         (date_trunc('month', join_date) + interval '1 month - 1 day' ):: date 
	     AS last_date
 FROM     members AS m
)
SELECT		view1.customer_id, SUM(view1.points) as loyalty_points
FROM	
(
 SELECT    d.customer_id, s.order_date, d.join_date, 
           d.valid_date, d.last_date, m.product_name, m.price,
           CASE
		  WHEN s.order_date < d.join_date THEN 0*m.price
		  WHEN m.product_name = 'sushi' AND s.order_date BETWEEN d.valid_date AND d.last_date
		  THEN 2 * 10 * m.price
          WHEN s.order_date BETWEEN d.join_date AND d.valid_date 
			   THEN 2 * 10 * m.price
          ELSE 10 * m.price
		  END AS points
  FROM    dates_cte AS d
          JOIN sales AS s
          ON d.customer_id = s.customer_id
          JOIN menu AS m
          ON s.product_id = m.product_id
WHERE       s.order_date < d.last_date
GROUP BY    d.customer_id, s.order_date, d.join_date, d.valid_date, 
            d.last_date, m.product_name, m.price
ORDER by 	d.customer_id, s.order_date asc
) as view1
GROUP BY	view1.customer_id
Order BY	view1.customer_id, loyalty_points DESC;

-----------------------------------------------------------------------------
---------bonus questions:----------

----Create a table with customer_id, order_date, product_name,price, member----

SELECT		s.customer_id, s.order_date, m.product_name, m.price,
			CASE WHEN s.order_date >= c.join_date THEN 'Y'
			ELSE 'N'
			END AS member
FROM		sales as s 
				join menu as m ON s.product_id = m.product_id
				left join members as c ON s.customer_id = c.customer_id
ORDER BY	s.customer_id, s.order_date ASC;


------create a table with ranking for the food item for member purchases-----

WITH table_cte AS
(
SELECT    s.customer_id,s.order_date,m.product_name,m.price,
          CASE WHEN s.order_date >= c.join_date THEN 'Y'
          ELSE 'N'
          END as member
FROM	  sales as s
          LEFT JOIN menu as m on s.product_id = m.product_id
		  LEFT JOIN members as c ON s.customer_id = c.customer_id
)

SELECT		*, CASE
            WHEN member = 'N' THEN NULL
			ELSE
			RANK () over (PARTITION BY customer_id, member
						 ORDER BY order_date) 
			END as Ranking
FROM		table_cte;      

---------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------


			
			
			