# 🥢 🍜 Danny's Diner SQL Challenge

## Solution
* Tool used: PostgreSQL
* Functions Used: 
  * Aggregate Functions- SUM,COUNT
  * Joins- INNER JOIN, LEFT JOIN, RIGHT JOIN
  * DATE Functions- DATE, DATE_TRUNC
  * Common Table Expressions (CTE)
***
### 1. What is the total amount each customer spent at the restaurant?

````sql
SELECT          s.customer_id, sum(m.price) as amount_spent
From            sales as s 
		 INNER JOIN menu as m 
		  ON  s.product_id=m.product_id
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
FROM 	         sales
Group by         customer_id
ORDER BY         count (distinct order_date) desc;
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

SELECT            s.customer_id, m.product_id, m.product_name
FROM              sales as s
	           INNER JOIN menu as m 
		    ON s.product_id = m.product_id
WHERE             s.customer_id = 'A'
Order By          s.order_date asc, m.product_id ASC
LIMIT             2;

-----first item ordered by 'B'

SELECT		s.customer_id, m.product_id, m.product_name
FROM		sales as s
	         INNER JOIN menu as m
		  ON  s.product_id = m.product_id
WHERE		s.customer_id = 'B'
ORDER BY	s.order_date ASC, m.product_id ASC
LIMIT                1;

-----first item ordered by 'C'

SELECT		s.customer_id, m.product_id, m.product_name
FROM 		sales as s 
                 INNER JOIN  menu as m
		  ON  s.product_id = m.product_id
WHERE           s.customer_id = 'C'
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
SELECT		  m.product_name, count(m.product_name) as times_purchased
FROM 		  sales as s
		   INNER JOIN menu as m 
		    ON s.product_id=     m.product_id
GROUP BY	  m.product_name
ORDER BY	  2 DESC
LIMIT		  1;
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

SELECT	           s.customer_id, m.product_name, count(m.product_name) as times_purchased
FROM 	           sales as s
	            INNER JOIN menu as m  
		     ON   s.product_id= m.product_id
WHERE	           s.customer_id = 'A'
GRoup by	   s.customer_id, m.product_name
order by	   3 DESC;

-----By 'B'

SELECT		s.customer_id, m.product_name, count(m.product_name) as times_ordered
FROM		sales as s
                 INNER join menu as m 
		  ON s.product_id = m.product_id
WHERE	        s.customer_id = 'B'
GROUP BY	s.customer_id, m.product_name
order By	3 DESC;

-----By 'C'

SELECT		s.customer_id, m.product_name, count(m.product_name) as times_ordered
FROM		sales as s
                 INNER join menu as m 
		  ON  s.product_id = m.product_id
WHERE	        s.customer_id = 'C'
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
ORDER BY        s.order_Date) as Rank
FROM		sales as s
	         INNER JOIN members as m 
		  ON s.customer_id = m.customer_id
WHERE	        s.order_date >= m.join_date
)
SELECT		m1.customer_id, m1.order_date, m.product_name,m1.rank
FROM		members_sales_cte as m1
	         INNER JOIN menu as m 
		  ON m1.product_id = m.product_id
WHERE	        m1.rank = 1
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
***

7. Which item was purchased just before the customer became a member?
````sql
WITH members_sales_cte as
(
SELECT		s.customer_id, s.order_date, m.join_date, s.product_id,
		DENSE_RANK () OVER (PARTITION BY s.customer_id 
                ORDER BY s.order_date desc) as RANK
FROM 		sales as s
		 INNER JOIN members as m 
		  ON s.customer_id = m.customer_id
WHERE	        s.order_date < m.join_date
)

SELECT		m1.customer_id, m1.order_date, m1.join_date, 
                m2.product_name
FROM 		members_sales_cte as m1
		  INNER JOIN menu as m2 
		   ON m1.product_id = m2.product_id
WHERE	        m1.rank=1
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
*** 

8. What is the total items and amount spent for each member before they became a member?
````sql
SELECT		s.customer_id,  Count(m.product_name) as unique_items,
                sum(m.price) as total_spent
FROM		sales as s
		 INNER JOIN menu as m 
		  ON m.product_id = s.product_id
		 INNER JOIN members as c 
		  ON  s.customer_id = c.customer_id
WHERE	        c.join_date > s.order_date
Group By	s.customer_id
order By	3 DESC;
````
#### Steps
- Used COUNT, SUM to find the total items and total amount spent by each customer using GROUP BY function.
- USED INNER JOIN to join _menu_ and _member_ tables with _sales_ table.

#### Answer

| customer_id | unique_items | total_spent |
| ----------- | ------------ | ----------- |
| B	      | 3	     | 40          | 
| A           | 2            | 25          |

- Customer A ordered 2 items from the menu and spent amount $25 in total whereas customer B spent $40 in total and ordered 3 items from the menu before they became a member.
*** 

9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
````sql
SELECT          view1.customer_id, sum(view1.loyalty_points) as total_points
FROM    (
SELECT           s.customer_id,
		 CASE 
		 WHEN 
		 m.product_name = 'sushi' then m.price*20 
		 ELSE m.price*10
		 END as loyalty_points
FROM 	         sales as s 
                   INNER JOIN menu as m 
		    ON s.product_id = m.product_id  
	 ) as view1
GROUP BY	 view1.customer_id
ORDER BY	 1, 2 DESC;
````
#### Steps

- Created subquerries to use conditions for loyalty points.

#### Answer

| customer_id | total_points |
| ----------- | ------------ |
| A           | 860          | 
| B           | 940          |
| C           | 360          |

- Customer A has 860 points.
- Customer B has 940 points.
- Customer C has 360 points.

***
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi 
- how many points do customer A and B have at the end of January?
````sql
WITH dates_cte AS 
(
 SELECT                    *, date (join_date + integer '6' ) as valid_date, 
                           (date_trunc('month', join_date) + interval '1 month - 1 day' ):: date as last_date
 FROM                      members AS m
)

SELECT		           view1.customer_id, SUM(view1.points) as loyalty_points
FROM	
(
SELECT                     d.customer_id, s.order_date, d.join_date, d.valid_date, d.last_date,
                           m.product_name, m.price,
                           CASE
		           WHEN 
			   s.order_date < d.join_date THEN 0* m.price
                           WHEN 
			   m.product_name = 'sushi' AND s.order_date BETWEEN d.valid_date AND d.last_date 
			   THEN 2 * 10 * m.price
                           WHEN 
			   s.order_date BETWEEN d.join_date AND d.valid_date THEN 2 * 10 * m.price
                           ELSE 10 * m.price
		           END) AS points
FROM                       dates_cte AS d
                             INNER JOIN sales AS s
                              ON d.customer_id = s.customer_id
                             INNER JOIN menu AS m
                              ON s.product_id = m.product_id
WHERE                      s.order_date < d.last_date
GROUP BY                   d.customer_id, s.order_date, d.join_date, d.valid_date, 
                           d.last_date, m.product_name, m.price
ORDER BY 	           d.customer_id, s.order_date asc
) as view1

GROUP BY	          view1.customer_id
Order BY	          view1.customer_id, loyalty_points DESC;
````
#### Steps

- Divided the questions into 2 sections and made few assumptions
  * As the first part of the question states that, a customer earns 2x points on all items, not just sushi, in the first week after becoming a member (including the join date). Hence, the valid date for earning the 2x points is 6 days. In order to set a valid date I used DATE function as DATE(join_date + integer ‘6’).
  * The second part of the question asks how many points customer A and B have at the end of January. My approach to the question was by setting last date of the month and I used (date_trunc….. + interval ‘1 month – 1 day’ ):: date function.
  * **Assumptions**:
    - The points are earned only after the customer joins the loyalty program.
    - The customer earns 2x 10 points for each $1 spent on all the items in the menu between join date to valid date.
    - After the valid date, the customer then earns 2x 10 points for each $1 spent for sushi and 1x 10 points for the rest.
 - Created CTE and used DATE and date_trunc to create columns called valid date and last date.
 - Added conditions in my query by using CASE WHEN function to calculate the loyalty points after the customer becomes a member. I used the WHERE clause to filter orders that were after January.
 - Used subquery and aggregate function like SUM to calculate the total points earned and ALIAS as loyalty points.
 - Used GROUP BY function to sort loyalty points based on customer id and ORDER BY function to keep the loyalty points in descending order.

#### Answer

| customer_id | loyalty_points |
| ----------- | -------------- |
| A           | 780            |
| B           | 320            |

- Customer A has earned 780 points by the end of January.
- Customer B has earned 320 points by the end of January.

***
## Bonus Question

### 1. Create a table with customer_id, order_date, product_name, price, member.
````sql
SELECT		     s.customer_id, s.order_date, m1.product_name, m1.price,
		     CASE 
		     WHEN  
		     s.order_date >= m.join_date THEN 'Y'
		     ELSE 'N'
		     END as member
FROM		     sales as s 
		      LEFT JOIN members as m
		       ON s.customer_id = m.customer_id
	              INNER JOIN menu as m1 
		       ON s.product_id = m1.product_id
ORDER BY	     1,2 ASC;
````

#### Answer

| customer_id | order_date | product_name | price | member |
| ----------- | ---------- | -------------| ----- | ------ |
| A           | 2021-01-01 | sushi        | 10    | N      |
| A           | 2021-01-01 | curry        | 15    | N      |
| A           | 2021-01-07 | curry        | 15    | Y      |
| A           | 2021-01-10 | ramen        | 12    | Y      |
| A           | 2021-01-11 | ramen        | 12    | Y      |
| A           | 2021-01-11 | ramen        | 12    | Y      |
| B           | 2021-01-01 | curry        | 15    | N      |
| B           | 2021-01-02 | curry        | 15    | N      |
| B           | 2021-01-04 | sushi        | 10    | N      |
| B           | 2021-01-11 | sushi        | 10    | Y      |
| B           | 2021-01-16 | ramen        | 12    | Y      |
| B           | 2021-02-01 | ramen        | 12    | Y      |
| C           | 2021-01-01 | ramen        | 12    | N      |
| C           | 2021-01-01 | ramen        | 12    | N      |
| C           | 2021-01-07 | ramen        | 12    | N      |

### Rank All The Things- create a table with ranking for the food item for member purchase

##### Danny also requires further information about the ```ranking``` of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ```ranking``` values for the records when customers are not yet part of the loyalty program.
````sql
WITH table_cte AS
(
SELECT         s.customer_id,s.order_date,m.product_name,m.price,
               CASE 
	       WHEN 
	       s.order_date >= c.join_date THEN 'Y'
               ELSE 'N'
               END as member
FROM	       sales as s
                LEFT JOIN menu as m 
		 ON s.product_id = m.product_id
		LEFT JOIN members as c 
		 ON s.customer_id = c.customer_id
)

SELECT		 *, 
                CASE
                WHEN 
		member = 'N' THEN NULL
	        ELSE
	        RANK () over (PARTITION BY customer_id, member ORDER BY order_date) 
	        END as Ranking
FROM		table_cte;      
````
#### Steps
- Created CTE as new table_cte
- Used RANK OVER(PARTITION BY ORDER BY) function to create a column named _Ranking_ based on order date.

#### Answer

| customer_id | order_date  | product_name | price | member | ranking |
| ----------- | ----------- | ------------ | ----- | ------ | ------- |
| A           | 2021-01-01  | sushi        | 10    | N      | NULL    |
| A           | 2021-01-01  | curry        | 15    | N      | NULL    |
| A           | 2021-01-07  | curry        | 15    | Y      | 1       |
| A           | 2021-01-10  | ramen        | 12    | Y      | 2       | 
| A           | 2021-01-11  | ramen        | 12    | Y      | 3       |
| A           | 2021-01-11  | ramen        | 12    | Y      | 3       |
| B           | 2021-01-01  | curry        | 15    | N      | NULL    
| B           | 2021-01-02  | curry        | 15    | N      | NULL
| B           | 2021-01-04  | sushi        | 10    | N      | NULL
| B           | 2021-01-11  | sushi        | 10    | Y      | 1
| B           | 2021-01-16  | ramen        | 12    | Y      | 2
| B           | 2021-02-01  | ramen        | 12    | Y      | 3
| C           | 2021-01-01  | ramen        | 12    | N      | NULL
| C           | 2021-01-01  | ramen        | 12    | N      | NULL
| C           | 2021-01-07  | ramen        | 12    | N      | NULL





































 














