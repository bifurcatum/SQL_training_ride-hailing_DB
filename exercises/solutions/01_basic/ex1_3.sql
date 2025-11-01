-- Exercise 1.3: Count Rides Per City
-- 23.10.2025 ST

SELECT
    l.city_name,
    COUNT(f.ride_id) AS total_rides
FROM dim_location l
JOIN fact_rides f
ON l.location_id = f.pickup_location_id
GROUP BY l.city_name
ORDER BY total_rides DESC;

-- Join on pickup_location_id as stated in the task
-- DESC to show highest first
