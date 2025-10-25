-- Exercise 1.6: Drivers Who Have Never Had a Cancelled Ride
-- 26.10.2025 ST

SELECT
    dr.name AS driver_name,
    COUNT(f.ride_id) AS completed_rides
FROM dim_driver dr
JOIN fact_rides f
ON dr.driver_id = f.driver_id
WHERE f.status = 'Completed' AND
    f.driver_id NOT IN
    (SELECT
         driver_id
     FROM fact_rides
     WHERE status IN ('Cancelled'))
GROUP BY dr.name;

-- The task have to be updated or data randomising logic needs change.
-- The problem with the task is that due to 33% probability of cancelled rides (when data is generated) it is very likely to get an empty list.