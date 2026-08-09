use data_drill;

SELECT *
FROM spy_close_price_5y;


WITH cte_ma AS
(
	SELECT 
		c_date,
		c_close,
		CASE
			WHEN rn > 49 
            THEN 
				avg(c_close) OVER(ORDER BY c_date ROWS BETWEEN 49 PRECEDING AND CURRENT ROW)
            ELSE NULL    
		 END AS ma_50,
        CASE
			WHEN rn > 199 
            THEN
				avg(c_close) OVER(ORDER BY c_date ROWS BETWEEN 199 PRECEDING AND CURRENT ROW)
			ELSE NULL
		 END AS ma_200
    FROM (select *, ROW_NUMBER() OVER(ORDER BY c_date) rn
			from spy_close_price_5y) r
), cte_lagged AS 
(
	SELECT *,
		LAG(ma_50) OVER(ORDER BY c_date) prv_ma_50,
        LAG(ma_200) OVER(ORDER BY c_date) prv_ma_200
    FROM cte_ma
), cte_gc AS
(
	SELECT *,
		CASE 
			WHEN ma_50 > ma_200
				AND prv_ma_50 <= prv_ma_200
			THEN 1
            ELSE 0
		END AS golden_cross
    FROM cte_lagged
)
SELECT *
FROM cte_gc
WHERE golden_cross = 1;