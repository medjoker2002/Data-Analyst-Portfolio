SELECT *  FROM status_updates;

SELECT * FROM payments;

WITH day_payments AS
(
	SELECT 
		user_id,
		sum(paid) paid 
    FROM payments
    GROUP BY user_id
)
	SELECT  
		s.user_id,
        CASE WHEN paid = 0 OR paid IS NULL THEN "CHURN"
			 WHEN s.status = "CHURN" THEN "RESURRECT"
             ELSE "EXISTING"
		END updated_status
        
    FROM status_updates s
    LEFT JOIN day_payments p 
		ON s.user_id = p.user_id