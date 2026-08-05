use leetcode;

SELECT *
FROM stadium_traffic;

WITH high_attendance as
(
	SELECT
		*,
        ROW_NUMBER() OVER(ORDER BY id) rn
	FROM stadium_traffic
    WHERE people > 99
),
streaks as
(
	SELECT 
		id, 
        visit_date, 
        people, 
        id - rn AS streak_grp
    FROM high_attendance
),
streaks_count AS
(
	SELECT 
		id, 
        visit_date, 
        people, 
        streak_grp,
        count(*) OVER(PARTITION BY streak_grp) streak_len 
	FROM streaks
)
SELECT 
	id, 
	visit_date, 
	people
FROM streaks_count
WHERE streak_len > 2