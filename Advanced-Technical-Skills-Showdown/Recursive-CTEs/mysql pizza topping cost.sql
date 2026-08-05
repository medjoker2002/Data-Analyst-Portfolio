SELECT * FROM lemur.pizzas_topping_cost;

WITH RECURSIVE pizzas AS
(
	SELECT 
		topping_name as last_topping,
        topping_name as pizza,
        ingredient_cost as pizza_cost,
        1 as level
    FROM pizzas_topping_cost
    
    UNION ALL
    SELECT 
		i.topping_name as last_topping,
        concat(pizza, ",", topping_name) as pizza,
        pizza_cost + ingredient_cost as pizza_cost,
        level + 1 as level
	FROM pizzas p
    INNER JOIN pizzas_topping_cost i
		ON p.last_topping < i.topping_name
        AND p.level < 3
)
	SELECT 
		pizza,
        pizza_cost
    FROM pizzas
    WHERE level = 3
    