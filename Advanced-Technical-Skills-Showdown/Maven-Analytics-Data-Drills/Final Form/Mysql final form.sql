USE data_drill;

SELECT
	*
FROM employee_satisfaction_survey;

WITH last_survey AS
(
	SELECT
		Email,
        first_value(Satisfaction) OVER(PARTITION BY Email ORDER BY Timestamp DESC) Satisfaction
	FROM employee_satisfaction_survey
),
ratings AS
(
	SELECT 
		Email,
        Satisfaction
    FROM last_survey
    GROUP BY 1, 2
)
SELECT
	Satisfaction,
    count(Email) Employees
FROM ratings
GROUP BY Satisfaction
ORDER BY Satisfaction