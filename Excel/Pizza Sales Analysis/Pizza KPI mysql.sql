use pizzadb;

select * from pizza_sales;

SELECT *,
	total_revenue/total_orders avg_order_value,
    total_pizzas/total_orders avg_order_pizza
FROM
(select sum(total_price) total_revenue, sum(quantity) total_pizzas, count(DISTINCT order_id) total_orders
from pizza_sales) kpi;

select dayname(order_date) order_day, count(DISTINCT order_id) daily_trend
from pizza_sales
GROUP BY dayname(order_date);

select left(order_time, 2) order_hour, count(DISTINCT order_id) hourly_trend
from pizza_sales
GROUP BY left(order_time, 2)
ORDER BY left(order_time, 2);

select pizza_category,
	sum(total_price) total_sales_per_category,
    (select sum(total_price) FROM pizza_sales) total_sales
from pizza_sales
GROUP BY pizza_category;

select pizza_size,
	sum(total_price) total_sales_per_size,
    (select sum(total_price) FROM pizza_sales) total_sales
from pizza_sales
GROUP BY pizza_size;

select pizza_category,
	sum(quantity) total_pizzas_per_category
from pizza_sales
GROUP BY pizza_category;

WITH pizza_rank AS(
	SELECT *,
		ROW_NUMBER() OVER(ORDER BY total_pizzas_sold DESC) top_ranking,
		count(pizza_name) OVER() number_of_pizzas
	FROM( 
		select pizza_name,
			sum(quantity) total_pizzas_sold
		from pizza_sales
		GROUP BY pizza_name) pns
)
SELECT pizza_name, total_pizzas_sold, top_ranking
from pizza_rank
-- top 5
WHERE top_ranking <= 5;
-- bottom 5
-- WHERE top_ranking >= number_of_pizzas - 4 ;

