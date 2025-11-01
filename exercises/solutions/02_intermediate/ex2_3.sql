-- Exercise 2.3: Compare Each Ride Price to Driver's Average
-- 01.11.2025 ST

SELECT
    f.ride_id,
    dr.name AS driver_name,
    f.price AS ride_price,
    AVG(f.price) OVER(PARTITION BY f.driver_id) AS driver_avg_price,
    ROUND(f.price - (AVG(f.price) OVER(PARTITION BY f.driver_id)), 2) AS price_difference
FROM fact_rides f
JOIN dim_driver dr
on f.driver_id = dr.driver_id
WHERE f.status = 'Completed';

-- Tried to use alias in the formula but MySQL has thrown an error.