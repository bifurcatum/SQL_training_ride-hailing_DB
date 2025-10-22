-- Exercise 1.1: Find All Completed Rides
-- 22.10.25 ST

SELECT
    fact_rides.ride_id,
    fact_rides.start_time,
    fact_rides.price
FROM fact_rides
WHERE status = 'Completed';

-- Checked rows count in a resulting table with:
SELECT
    COUNT(*)
FROM fact_rides
WHERE status = 'Completed';