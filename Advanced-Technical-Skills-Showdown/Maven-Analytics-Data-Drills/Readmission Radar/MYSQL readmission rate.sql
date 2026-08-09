SELECT * FROM data_drill.inpatient_admissions;

WITH next_dates AS (
	SELECT
		patient_id,
		admission_date,
		discharge_date,
		LEAD(admission_date) OVER(PARTITION BY patient_id ORDER BY admission_date) next_admission
	FROM data_drill.inpatient_admissions
)
SELECT
	count(CASE WHEN datediff(next_admission, discharge_date) <= 30 THEN TRUE END) * 100 / count(*) AS readmission_rate
FROM next_dates
;