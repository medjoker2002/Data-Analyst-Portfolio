USE data_drill;

WITH runner_bands AS (
    SELECT 
        final,
        CASE 
            WHEN final < '03:00:00' THEN 'Sub 3:00'
            WHEN final < '03:30:00' THEN '3:00 - 3:30'
            WHEN final < '04:00:00' THEN '3:30 - 4:00'
            WHEN final < '04:30:00' THEN '4:00 - 4:30'
            WHEN final < '05:00:00' THEN '4:30 - 5:00'
            WHEN final < '05:30:00' THEN '5:00 - 5:30'
            WHEN final < '06:00:00' THEN '5:30 - 6:00'
            ELSE '6:00+'
        END AS time_band
    FROM marathon_data
)
SELECT 
    time_band,
    COUNT(*) AS runner_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 1) AS percentage
FROM runner_bands
GROUP BY time_band
ORDER BY CASE 
	WHEN time_band = "sub 3:00" THEN "0"
    ELSE time_band
    END
;