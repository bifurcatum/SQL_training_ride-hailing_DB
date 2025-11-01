-- Exercise 2.4: Find Riders Who Took More Than Average Rides
-- 02.11.2025

WITH ridecount AS (SELECT
    r.name AS rider_name,
    COUNT(*) AS ride_count
FROM fact_rides f
JOIN dim_rider r
ON f.rider_id = r.rider_id
GROUP BY rider_name)
SELECT
     rider_name,
     ride_count
FROM ridecount
WHERE ride_count > (SELECT AVG(ride_count) FROM ridecount)
ORDER BY ride_count DESC;

-- I made it with CTE and subquery,
-- but as the hint proposes subquery with HAVING I'll put this one here as well:

SELECT
    r.name AS rider_name,
    COUNT(*) AS ride_count
FROM fact_rides f
JOIN dim_rider r
ON f.rider_id = r.rider_id
GROUP BY r.name
HAVING COUNT(*) > (
    SELECT AVG(ride_count)
    FROM (
        SELECT COUNT(*) AS ride_count
        FROM fact_rides
        GROUP BY rider_id
    ) AS avg_calc
)
ORDER BY ride_count DESC;

-- Useful observation: each subquery needs own alias (ex. 'AS avg_calc').
-- Even if you won't use it yourself - it is used by SQL engine.