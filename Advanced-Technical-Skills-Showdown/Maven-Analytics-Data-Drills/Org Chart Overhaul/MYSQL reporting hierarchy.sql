USE data_drill;

SELECT * FROM officespace;

WITH RECURSIVE direct AS
(
	SELECT 
		o.employee,
        o.manager,
		ifnull(d.direct_reports, 0) direct_reports
    FROM officespace o
    LEFT JOIN (
				SELECT 
					manager,
					count(employee) direct_reports
				FROM officespace
				GROUP BY manager
			) d
		ON o.employee = d.manager
)
, hierarchy AS
(
	SELECT 
		employee,
        manager,
        employee AS reporting_hierarchy,
        direct_reports
    FROM direct
    WHERE manager = ""
    
    UNION ALL
    SELECT 
		d.employee,
        d.manager,
        concat(reporting_hierarchy, " > ", d.employee) AS  reporting_hierarchy,
        d.direct_reports
	FROM hierarchy h 
	INNER JOIN direct d 
		on d.manager = h.employee
)
, emp_under AS
(
	SELECT 
		o.employee,
        h.employee employees_under
	FROM hierarchy o 
    LEFT JOIN hierarchy h 
		ON h.reporting_hierarchy LIKE concat(h.reporting_hierarchy, " >%")
), total AS
(
	SELECT 
		employee,
        count(employees_under) total_reports
	FROM emp_under
    GROUP BY employee
)
SELECT 
	h.*,
    t.total_reports
	-- sum( t.total_reports) OVER()
FROM hierarchy h 
INNER JOIN total t 
	ON h.employee = t.employee