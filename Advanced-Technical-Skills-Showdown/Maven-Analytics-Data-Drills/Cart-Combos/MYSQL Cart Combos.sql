SELECT
	*
FROM grocery_transactions;

SELECT
	t1.product_name AS product_1,
	t2.product_name AS product_2,
    count(*) AS number_of_transactions
FROM grocery_transactions t1
INNER JOIN grocery_transactions t2
	ON t1.transaction_id = t2.transaction_id
	AND t1.product_name < t2.product_name
GROUP BY t1.product_name, t2.product_name
ORDER BY count(*) DESC
;    