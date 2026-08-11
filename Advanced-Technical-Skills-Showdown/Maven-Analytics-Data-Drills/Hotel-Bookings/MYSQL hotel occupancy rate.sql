WITH RECURSIVE hotel_dates AS 
(
    SELECT MIN(checkin_date) AS date
    FROM hotel_bookings
    
    UNION ALL
    
    SELECT DATE_ADD(date, INTERVAL 1 DAY)
    FROM hotel_dates
    WHERE date < (SELECT MAX(checkout_date) FROM hotel_bookings)
),
daily_occupancy AS 
(
    SELECT 
        d.date,
        COUNT(*) AS rooms_occupied,
        ROUND(COUNT(*) * 100.0 / 200, 2) AS daily_occupancy_rate_pct   -- daily %
    FROM hotel_dates d
    LEFT JOIN hotel_bookings b 
        ON d.date >= b.checkin_date 
       AND d.date < b.checkout_date
       AND b.is_canceled = 0
    GROUP BY d.date
)
SELECT 
    DATE_FORMAT(date, '%Y-%m') AS month_year,
    ROUND(AVG(daily_occupancy_rate_pct), 2) AS avg_daily_occupancy_rate_pct
FROM daily_occupancy
GROUP BY DATE_FORMAT(date, '%Y-%m')
ORDER BY month_year;