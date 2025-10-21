USE ride_hailing;

-- =====================================================
-- DATA SANITY CHECK SCRIPT
-- =====================================================

-- 1. Check table counts
SELECT 'dim_driver' AS table_name, COUNT(*) AS row_count FROM dim_driver
UNION ALL
SELECT 'dim_rider', COUNT(*) FROM dim_rider
UNION ALL
SELECT 'dim_location', COUNT(*) FROM dim_location
UNION ALL
SELECT 'dim_payment_type', COUNT(*) FROM dim_payment_type
UNION ALL
SELECT 'dim_time', COUNT(*) FROM dim_time
UNION ALL
SELECT 'fact_rides', COUNT(*) FROM fact_rides;

-- 2. Price, Rating, Duration range checks
SELECT
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating,
    MIN(duration) AS min_duration,
    MAX(duration) AS max_duration
FROM fact_rides;

-- 3. Count completed vs cancelled vs refunded rides
SELECT
    status,
    COUNT(*) AS rides_count,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM fact_rides), 2) AS percent_total
FROM fact_rides
GROUP BY status;

-- 4. Distribution of payment types
SELECT
    p.payment_method,
    COUNT(f.ride_id) AS total_rides,
    ROUND(AVG(f.price),2) AS avg_price
FROM fact_rides f
JOIN dim_payment_type p ON f.payment_type_id = p.payment_type_id
GROUP BY p.payment_method;

-- 5. Average rating per driver (top 5)
SELECT
    d.name AS driver_name,
    ROUND(AVG(f.rating),2) AS avg_rating,
    COUNT(f.ride_id) AS rides_count
FROM fact_rides f
JOIN dim_driver d ON f.driver_id = d.driver_id
GROUP BY d.driver_id
ORDER BY avg_rating DESC
LIMIT 5;

-- 6. Sample data check: 5 random rides
SELECT
    ride_id, driver_id, rider_id, pickup_location_id, dropoff_location_id,
    DATE(start_time) AS ride_date, price, rating, status
FROM fact_rides
ORDER BY RAND()
LIMIT 5;

-- =====================================================
-- END OF CHECK SCRIPT
-- =====================================================
