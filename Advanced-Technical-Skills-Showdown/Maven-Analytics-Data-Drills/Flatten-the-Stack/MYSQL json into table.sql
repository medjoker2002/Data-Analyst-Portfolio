USE data_drill;

SELECT *
FROM sales_orders;

WITH parsed AS
(
	SELECT 
		s.order_number,
		jt.product_name,
		jt.price,
		jt.quantity,
		s.order_date,
		s.fulfilement
	FROM sales_orders s 
	CROSS JOIN JSON_TABLE(
		s.line_items,
		"$[*]" COLUMNS(
			product_name varchar(120) PATH "$.product.product_name",
			price DECIMAL(10,2) PATH "$.product.product_price",
			quantity INT PATH "$.quantity"
		)
	) jt
)
SELECT 
	fulfilement,
    sum(price*quantity) total_sales
FROM parsed
GROUP BY fulfilement
