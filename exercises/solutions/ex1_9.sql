-- Exercise 1.9: Riders with Gold Status
-- 30.10.2025 ST

SELECT r.name AS rider_name,
       r.loyalty_status,
       COUNT(f.ride_id) AS total_rides
FROM fact_rides f
JOIN dim_rider r
ON f.rider_id = r.rider_id
WHERE r.loyalty_status = 'Gold'
GROUP BY r.name
ORDER BY total_rides DESC;