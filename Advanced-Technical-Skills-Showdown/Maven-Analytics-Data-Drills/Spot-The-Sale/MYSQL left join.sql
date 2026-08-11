USE data_drill;

SELECT 
		o.order_id,
        o.order_date,
        o.order_quantity,
        p.promo_id
FROM orders o
LEFT JOIN promotions p 
	on o.order_date BETWEEN p.start_date AND p.end_date
WHERE p.promo_id is NOT NULL;
