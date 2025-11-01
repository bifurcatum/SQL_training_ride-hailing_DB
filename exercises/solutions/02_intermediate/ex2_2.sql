-- Exercise 2.2: Running Total of Daily Revenue
-- 01.11.2025 ST

WITH day_revenue AS (SELECT
    DATE(start_time) AS ride_date,
    SUM(price) AS daily_revenue
FROM fact_rides
WHERE status = 'Completed'
    AND MONTH(start_time) = 1
    AND YEAR(start_time) = 2025
GROUP BY ride_date)
SELECT
    ride_date,
    daily_revenue,
    SUM(daily_revenue) OVER(ORDER BY ride_date) AS cumulative_revenue
FROM day_revenue;

-- First I made it overcomplicated by joining with dim_time, but it is not needed as start_time provides necessary data.