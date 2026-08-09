USE data_drill;

SELECT *
FROM baseball_positions;


SELECT 
	jt.Positions,
    count(jt.Positions) count
FROM baseball_positions b  
CROSS JOIN  JSON_TABLE(concat('["', replace(b.position, "/", '","'), '"]'),
	"$[*]" COLUMNS(
		positions VARCHAR(10) PATH "$"
	)
) jt
GROUP BY jt.Positions
ORDER BY count DESC
;