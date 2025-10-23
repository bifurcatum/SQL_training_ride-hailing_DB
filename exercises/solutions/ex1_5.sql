-- Exercise 1.5: Rides on Weekends
-- 23.10.2025 ST

SELECT
    f.ride_id,
    f.start_time,
    t.full_date,
    t.day_of_week
FROM fact_rides f
JOIN dim_time t
ON f.date_id = t.date_id
WHERE t.is_weekend = 1;

-- Good to check dim_time table content beforehand