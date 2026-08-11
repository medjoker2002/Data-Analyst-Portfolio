USE data_drill;

SELECT *
FROM coffee_shop_sales;

SELECT *,
	monthly_sales - LAG(monthly_sales) OVER(PARTITION BY store ORDER BY month) MoM_diff
FROM(SELECT month(date) month, store, SUM(sales) monthly_sales
	FROM coffee_shop_sales
	GROUP BY  month(date), store) ms
;