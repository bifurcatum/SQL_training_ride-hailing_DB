-- Exercise 1.1: Find All Completed Rides
-- 22.10.25 ST

SELECT
    ride_id,
    start_time,
    price
FROM fact_rides
WHERE status = 'Completed';

-- Checked rows count in a resulting table with:
SELECT
    COUNT(*)
FROM fact_rides
WHERE status = 'Completed';