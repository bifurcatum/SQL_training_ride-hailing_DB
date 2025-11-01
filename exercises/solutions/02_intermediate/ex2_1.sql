-- Exercise 2.1: Rank Drivers by Total Revenue
-- 01.11.2025 ST

SELECT
    dr.name as driver_name,
    SUM(f.price) as total_revenue,
    DENSE_RANK() OVER(ORDER BY SUM(f.price) DESC) as revenue_rank
FROM dim_driver dr
JOIN fact_rides f
ON dr.driver_id = f.driver_id
WHERE f.status IN ('Completed')
GROUP BY dr.name;

-- The exercise hint suggests that you use ranking in a CTE or subquery - however as SUM() is used inside the window function it is not necessary.