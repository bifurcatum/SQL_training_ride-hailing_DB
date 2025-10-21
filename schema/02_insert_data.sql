USE ride_hailing;

-- =====================================================
-- INSERT DATA INTO DIMENSIONS
-- =====================================================

-- 1. Drivers
INSERT INTO dim_driver (name, registration_date, city_id, rating, vehicle_type)
SELECT
    CONCAT('Driver_', n),
    DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*1500) DAY),
    FLOOR(1 + RAND()*5),
    ROUND(3.5 + RAND()*1.5, 2),
    ELT(FLOOR(1 + RAND()*3), 'Sedan', 'SUV', 'Economy')
FROM (
    SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
    UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
    UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
    UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20
) t;

-- 2. Riders
INSERT INTO dim_rider (name, registration_date, loyalty_status)
SELECT
    CONCAT('Rider_', n),
    DATE_SUB(CURDATE(), INTERVAL FLOOR(RAND()*2000) DAY),
    ELT(FLOOR(1 + RAND()*3), 'Bronze', 'Silver', 'Gold')
FROM (
    SELECT n FROM (
        SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
        UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
        UNION SELECT 11 UNION SELECT 12 UNION SELECT 13 UNION SELECT 14 UNION SELECT 15
        UNION SELECT 16 UNION SELECT 17 UNION SELECT 18 UNION SELECT 19 UNION SELECT 20
        UNION SELECT 21 UNION SELECT 22 UNION SELECT 23 UNION SELECT 24 UNION SELECT 25
        UNION SELECT 26 UNION SELECT 27 UNION SELECT 28 UNION SELECT 29 UNION SELECT 30
        UNION SELECT 31 UNION SELECT 32 UNION SELECT 33 UNION SELECT 34 UNION SELECT 35
        UNION SELECT 36 UNION SELECT 37 UNION SELECT 38 UNION SELECT 39 UNION SELECT 40
        UNION SELECT 41 UNION SELECT 42 UNION SELECT 43 UNION SELECT 44 UNION SELECT 45
        UNION SELECT 46 UNION SELECT 47 UNION SELECT 48 UNION SELECT 49 UNION SELECT 50
    ) s
) r;

-- 3. Locations (cities)
INSERT INTO dim_location (city_name, region_name, country)
VALUES
('Tallinn', 'Harju', 'Estonia'),
('Tartu', 'Tartu', 'Estonia'),
('Narva', 'Ida-Viru', 'Estonia'),
('Pärnu', 'Pärnu', 'Estonia'),
('Viljandi', 'Viljandi', 'Estonia');

-- 4. Payment types
INSERT INTO dim_payment_type (payment_method)
VALUES ('Cash'), ('Card'), ('In-App'), ('Promo');

-- 5. Time dimension (12 months)
INSERT INTO dim_time (full_date, day_of_week, month, year, is_weekend)
SELECT
    DATE(CONCAT('2025-', LPAD(m,2,'0'), '-15')),
    ELT(FLOOR(1 + RAND()*7), 'Mon','Tue','Wed','Thu','Fri','Sat','Sun'),
    m,
    2025,
    IF(m IN (6,7,12), TRUE, FALSE)
FROM (
    SELECT 1 AS m UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
    UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9 UNION SELECT 10
    UNION SELECT 11 UNION SELECT 12
) months;

-- =====================================================
-- FACT TABLE GENERATION (1000 rides with biases)
-- =====================================================

DELIMITER $$

CREATE PROCEDURE generate_fact_rides()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE d_id INT;
    DECLARE base_rating DECIMAL(3,2);
    DECLARE base_price DECIMAL(10,2);
    DECLARE wday INT;
    DECLARE start_dt DATETIME;
    DECLARE duration INT;

    WHILE i < 1000 DO
        SET d_id = FLOOR(1 + RAND()*20);  -- driver_id
        SET wday = FLOOR(1 + RAND()*7);   -- for weekend bias

        -- Bias: more experienced drivers (higher id) → slightly higher price & rating
        SET base_rating = ROUND(3.5 + (d_id/40) + RAND()*1.0, 2);
        SET base_price  = ROUND(5 + (d_id/2) + RAND()*25, 2);

        -- Weekend bias: 10% higher price & more rides on weekends
        IF wday IN (6,7) THEN
            SET base_price = base_price * 1.1;
        END IF;

        SET duration = FLOOR(10 + RAND()*50);
        SET start_dt = TIMESTAMPADD(
            MINUTE,
            FLOOR(RAND()*1440),
            TIMESTAMPADD(DAY, FLOOR(RAND()*330), '2025-01-01 00:00:00')
        );

        INSERT INTO fact_rides (
            driver_id,
            rider_id,
            pickup_location_id,
            dropoff_location_id,
            date_id,
            start_time,
            end_time,
            duration,
            distance,
            price,
            rating,
            payment_type_id,
            status
        )
        VALUES (
            d_id,
            FLOOR(1 + RAND()*50),               -- rider
            FLOOR(1 + RAND()*5),                -- pickup
            FLOOR(1 + RAND()*5),                -- dropoff
            FLOOR(1 + RAND()*12),               -- date_id (month)
            start_dt,
            TIMESTAMPADD(MINUTE, duration, start_dt),
            duration,
            ROUND(3 + RAND()*15, 1),            -- distance
            base_price,
            base_rating,
            FLOOR(1 + RAND()*4),                -- payment type
            ELT(FLOOR(1 + RAND()*3), 'Completed','Cancelled','Refunded')
        );

        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

CALL generate_fact_rides();
DROP PROCEDURE generate_fact_rides;

-- =====================================================
-- END OF INSERT SCRIPT
-- =====================================================
