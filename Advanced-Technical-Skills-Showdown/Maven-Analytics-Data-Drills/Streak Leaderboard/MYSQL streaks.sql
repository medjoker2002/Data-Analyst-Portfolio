USE data_drill;

WITH no_dupes AS
(
	SELECT user_id, user_name, date
    FROM lessonstreaks
    GROUP BY 1,2,3
), days_diff AS
(
	SELECT
		user_id, 
        user_name, 
        date,
        LEAD(date) OVER(PARTITION BY user_id ORDER BY date DESC) prv_date,
        timestampdiff(day, LEAD(date) OVER(PARTITION BY user_id ORDER BY date DESC), date) days
	FROM no_dupes
), str_group as
(
	SELECT 
		user_id, 
        user_name, 
        date,
        days,
        sum(CASE WHEN days > 1 then 1 ELSE 0 END) 
			OVER(PARTITION BY user_id ORDER BY date) as streak_group 
	FROM days_diff
)			
SELECT 
	user_id,
    user_name, 
	min(date) start_date,
    max(date) end_date,
    streak_group,
    count(*) streak_length
FROM str_group
GROUP BY user_id, user_name, streak_group
ORDER BY count(*) DESC
;