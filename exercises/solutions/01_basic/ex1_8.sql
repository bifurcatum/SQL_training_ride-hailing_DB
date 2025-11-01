-- Exercise 1.8: Busiest Day of Week
-- 30.10.2025 ST

SELECT
    t.day_of_week,
    COUNT(f.ride_id) AS total_rides
FROM fact_rides f
JOIN dim_time t
ON f.date_id = t.date_id
GROUP BY t.day_of_week
ORDER BY total_rides DESC;
