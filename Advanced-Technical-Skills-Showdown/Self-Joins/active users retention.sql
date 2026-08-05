with act_users as
(
	SELECT 
		month(event_date) month,
		user_id
	FROM lemur.users_retention
	WHERE event_type in ("sign-in", "like", "comment")
	GROUP BY month(event_date), user_id
)
	SELECT
		c.month,
        count(p.user_id) active_users
    FROM act_users c 
    left join act_users p
		on c.user_id = p.user_id
        and c.month = p.month + 1
	group by month 