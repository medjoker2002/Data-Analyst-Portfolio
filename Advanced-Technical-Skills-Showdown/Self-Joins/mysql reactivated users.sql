SELECT * FROM lemur.user_logins;

WITH monthly_active AS 
(
    SELECT 
        user_id,
        MONTH(login_date) AS mth
    FROM user_logins
    GROUP BY user_id, MONTH(login_date)
),
reactivated AS 
(
    SELECT 
        m.mth,
        m.user_id,
		CASE
			WHEN m.mth = 1 THEN 1
            ELSE prev1.user_id 
		END prv1
    FROM monthly_active m
    LEFT JOIN monthly_active prev1 
        ON m.user_id = prev1.user_id 
        AND m.mth = prev1.mth + 1
)

SELECT 
	mth,
	count(CASE WHEN prv1 is NULL THEN 1 END) reactivated_count
FROM reactivated

GROUP BY mth
ORDER BY mth