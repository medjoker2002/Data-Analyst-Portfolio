USE data_drill;

SELECT * FROM officespace;

WITH RECURSIVE direct AS
(
	SELECT 
		o.employee,
        o.manager,
		ifnull(d.direct_reports, 0) direct_reports,
		ROW_NUMBER() OVER(PARTITION BY o.manager ORDER BY o.employee) AS rn
        -- rn is going to be usedn for a branch code to identify employee's manager in the hierarchy
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
        concat("0", rn) AS branch_code,
        direct_reports,
        1 AS level
    FROM direct
    WHERE manager = ""
    
    UNION ALL
    SELECT 
		d.employee,
        d.manager,
        concat(branch_code, lpad(d.rn, 2, "0")) AS  branch_code,
        d.direct_reports,
        level + 1 AS level
	FROM hierarchy h 
	INNER JOIN direct d 
		on d.manager = h.employee
)
	SELECT 
		employee,
        manager,
        branch_code,
        level,
        direct_reports,
		CASE WHEN level = 1 THEN count(employee) OVER() - 1
			WHEN level = 2 THEN sum(direct_reports) OVER(PARTITION BY left(branch_code, 4))
            WHEN level = 3 THEN sum(direct_reports) OVER(PARTITION BY left(branch_code, 6))
            ELSE direct_reports
		END AS total_reports
    FROM hierarchy