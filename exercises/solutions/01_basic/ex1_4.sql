-- Exercise 1.4: Average Price by Payment Method
-- 23.10.2025 ST

SELECT
    p.payment_method,
    AVG(f.price) AS avg_price,
    COUNT(f.ride_id) AS total_rides
FROM dim_payment_type p
JOIN fact_rides f
ON p.payment_type_id = f.payment_type_id
GROUP BY p.payment_method, f.status
HAVING f.status = 'Completed';


