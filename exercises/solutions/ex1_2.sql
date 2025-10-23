-- Exercise 1.2: Top 10 Most Expensive Rides
-- 23.10.2025 ST

SELECT
    ride_id,
    price,
    distance,
    start_time
FROM fact_rides
ORDER BY price DESC
LIMIT 10;