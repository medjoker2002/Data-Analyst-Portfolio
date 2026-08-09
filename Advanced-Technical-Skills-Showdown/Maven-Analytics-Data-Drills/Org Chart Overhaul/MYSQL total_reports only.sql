USE data_drill;

SELECT * FROM officespace;

WITH RECURSIVE total AS
(
	SELECT 
		employee AS root,
        manager AS root_manager,
        employee
    FROM officespace
    
    UNION ALL
    SELECT 
		t.root,
        t.root_manager,
		o.employee AS employee
	FROM total t 
	INNER JOIN officespace o 
		on o.manager = t.employee
)

SELECT 
	root AS employee,
    root_manager AS manager,
    count(*) - 1 AS total_reports
FROM total
GROUP BY root, root_manager