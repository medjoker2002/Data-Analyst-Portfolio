SELECT * FROM lemur.server_utilization;

WITH lagged AS (
    SELECT 
        server_id,
        status_time,
        session_status,
        LAG(status_time) OVER (PARTITION BY server_id ORDER BY status_time) AS prev_time
    FROM server_utilization
)

SELECT 
    FLOOR(
        SUM(TIMESTAMPDIFF(SECOND, prev_time, status_time)) / (3600 * 24)
    ) AS total_full_days
FROM lagged
WHERE session_status = 'stop';
