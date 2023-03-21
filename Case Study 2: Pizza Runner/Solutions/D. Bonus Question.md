# Bonus Question 🪜

### If Danny wants to expand his range of pizzas how would this impact the existing data design? Write an INSERT statement to demonstrate what would happen if a new Supreme pizza with all the toppings was added to the Pizza Runner menu?
````sql
INSERT INTO
pizza_names ("pizza_id","pizza_name")
VALUES
(3,'Supreme');
INSERT INTO
pizza_recipes ("pizza_id","toppings")
VALUES
(3,'1,2,3,4,5,6,7,8,9,10,11,12');
````
To see the result
````sql
SELECT	*
FROM	pizza_names as pn
			JOIN pizza_recipes as pr
			ON pn.pizza_id = pr.pizza_id;
````
#### Answer

| pizza_id | pizza_name | pizza_id | toppings |
| -------- | ---------- | -------- | -------- |
| 1 | Meatlovers | 1 | 1,2,3,4,5,6,8,10 |
| 2 | Vegetarian | 2 | 4,6,7,9,11,12 |
| 3 | Supreme | 3 | 1,2,3,4,5,6,7,8,9,10,11,12 |
***
