USE data_drill;

SELECT * FROM data_drill.lessonstreaks;

/* only two helper columns: 
- dense_rank() over(partition by user_id order by date desc) as dr_date
desne rank does not icrement on the same date, so it calculuates different dates by descending order.
- days_ago difference in days between today and other dates.

active streak stops where dense rank differs from days_ago indicating the gap between dates is more than 1 day

so we take max(dr_date) where dr_date = days_ago grouped by user_id */
WITH days AS
(
	SELECT 
		user_id,
		user_name,
		date,
		timestampdiff(day, date, "2025-09-29") days_ago,
		DENSE_RANK() OVER(PARTITION BY user_id ORDER BY date DESC) dr_date
	FROM lessonstreaks
), streak AS
(
	SELECT 
		user_id,
		user_name,
		max(dr_date) as active_streak
	FROM days
    WHERE dr_date = days_ago
    GROUP BY user_id, user_name
    ORDER BY 3 DESC
)
SELECT 
	user_id,
	user_name,
	active_streak
FROM streak
;