SELECT * FROM lemur.google_searches_median;

WITH ranks AS
(
	SELECT 
		searches,
        users,
        sum(users) OVER(ORDER BY searches ASC) running_total,
        sum(users) OVER() total
    FROM google_searches_median
)
	SELECT 
		avg(searches) median_searches
    FROM ranks
    WHERE total <= 2 * (running_total)
		AND total >= 2 * (running_total - users);
 