WITH unbanned_trips AS (
    SELECT 
        t.request_at AS day,
        t.status,
        t.client_id,
        t.driver_id
    FROM Trips t
    LEFT JOIN Users c ON t.client_id = c.users_id
    LEFT JOIN Users d ON t.driver_id = d.users_id
    WHERE t.request_at BETWEEN '2013-10-01' AND '2013-10-03'
      AND c.banned = 'No'
      AND d.banned = 'No'
),
daily_stats AS (
    SELECT 
        day,
        COUNT(*) AS total_requests,
        COUNT(CASE WHEN status != 'completed' THEN 1 END) AS canceled_requests
    FROM unbanned_trips
    GROUP BY day
    HAVING COUNT(*) > 0
)
SELECT 
    day,
    ROUND(canceled_requests * 1.0 / total_requests, 2) AS "Cancellation Rate"
FROM daily_stats
ORDER BY day;