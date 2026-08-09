USE data_drill;

SELECT *
FROM activity;

WITH st_mv AS
(
	SELECT user_id,
		count(id) started
    FROM activity
    GROUP BY user_id
),metrics AS
(
	SELECT 
		user_id,
		min(date) first_date,
		max(first_name) first_name,
		max(date) last_date,
		max(last_name) last_name,
		count(id) finished
	FROM (SELECT *,
				 FIRST_VALUE(movie_name) OVER(PARTITION BY user_id ORDER BY id) first_name,
				 LAST_VALUE(movie_name) OVER(PARTITION BY user_id ORDER BY id ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) last_name
		  FROM activity
          WHERE finished =1) a
	GROUP BY user_id
)
SELECT 
	u.id,
    u.created_at,
    m.first_date,
    m.first_name, 
    m.last_date, 
    m.last_name, 
    s.started,
    m.finished
FROM users u
LEFT JOIN st_mv s 
	on u.id = s.user_id
LEFT JOIN metrics m
	on u.id = m.user_id
-- WHERE m.last_name = "Fight Club"
;