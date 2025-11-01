-- Exercise 1.7: Total Revenue Per Month
-- 26.10.2025 ST

SELECT month AS month_num,
       month_name,
       SUM(price) AS total_revenue
FROM dim_time t
JOIN fact_rides f
ON t.date_id = f.date_id
WHERE f.status = 'Completed'
GROUP BY month, month_name
ORDER BY month;