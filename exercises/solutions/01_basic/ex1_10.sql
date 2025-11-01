-- Exercise 10: Longest Ride by Distance
-- 30.10.2025 ST

SELECT
    f.ride_id,
    f.distance,
    f.duration,
    f.price,
    pickup.city_name AS pickup_city,
    dr_off.city_name AS dropoff_city
FROM fact_rides f
JOIN dim_location pickup
ON f.pickup_location_id = pickup.location_id
JOIN dim_location dr_off
ON f.dropoff_location_id = dr_off.location_id
ORDER BY distance DESC
LIMIT 1;

-- This one is a little bit tricky as you have to join the same table twice using different aliases.