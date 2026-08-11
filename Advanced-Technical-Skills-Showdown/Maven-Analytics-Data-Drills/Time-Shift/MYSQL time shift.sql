-- tickets Table Date Column Fix
-- UPDATE tickets
-- SET submitted_at_utc = replace(submitted_at_utc, "T", " ");

-- ALTER TABLE tickets
-- MODIFY COLUMN submitted_at_utc DATETIME;

WITH time_shift AS(
	SELECT
		user_id,
		CAST(substring(timezone, 5, 3) AS SIGNED) time_diff
	FROM data_drill.users
), 
local_times AS(
	SELECT
		t.user_id,
        t.submitted_at_utc AS time_utc,
        timestampadd(HOUR, time_diff, submitted_at_utc) time_local
	FROM data_drill.tickets t
    LEFT JOIN time_shift u
		ON t.user_id = u.user_id
)
SELECT 
	hour(time_local) hour,
    count(user_id) number_of_submissions
FROM local_times
GROUP BY hour(time_local)
ORDER BY 2 DESC
;