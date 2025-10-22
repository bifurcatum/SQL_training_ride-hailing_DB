USE ride_hailing;

-- =====================================================
-- INSERT DATA INTO DIMENSIONS
-- =====================================================

-- 1. Locations (must be inserted first as drivers reference it)
INSERT INTO dim_location (city_name, region_name, country)
VALUES
('Tallinn', 'Harju', 'Estonia'),
('Tartu', 'Tartu', 'Estonia'),
('Narva', 'Ida-Viru', 'Estonia'),
('Pärnu', 'Pärnu', 'Estonia'),
('Viljandi', 'Viljandi', 'Estonia');

-- 2. Payment types
INSERT INTO dim_payment_type (payment_method)
VALUES ('Cash'), ('Card'), ('In-App'), ('Promo');

-- 3. Time dimension (Fixed: 365 actual days for 2025)
INSERT INTO dim_time (full_date, day_of_week, day_of_week_num, week_of_year, month, month_name, quarter, year, is_weekend, is_holiday)
SELECT
    full_date,
    DAYNAME(full_date) AS day_of_week,
    DAYOFWEEK(full_date) AS day_of_week_num,
    WEEK(full_date, 3) AS week_of_year,
    MONTH(full_date) AS month,
    MONTHNAME(full_date) AS month_name,
    QUARTER(full_date) AS quarter,
    YEAR(full_date) AS year,
    DAYOFWEEK(full_date) IN (1, 7) AS is_weekend,  -- 1=Sunday, 7=Saturday in MySQL
    FALSE AS is_holiday  -- Can be updated later for specific holidays
FROM (
    SELECT DATE_ADD('2024-12-31', INTERVAL seq DAY) AS full_date
    FROM (
        SELECT a.n + b.n * 10 + c.n * 100 AS seq
        FROM
            (SELECT 0 AS n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
             UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) a,
            (SELECT 0 AS n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
             UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8 UNION SELECT 9) b,
            (SELECT 0 AS n UNION SELECT 1 UNION SELECT 2 UNION SELECT 3) c
    ) numbers
    WHERE seq BETWEEN 1 AND 365
) dates;

-- Optional: Mark Estonian public holidays for 2025
UPDATE dim_time SET is_holiday = TRUE WHERE full_date IN (
    '2025-01-01',  -- New Year
    '2025-02-24',  -- Independence Day
    '2025-04-18',  -- Good Friday
    '2025-04-20',  -- Easter Sunday
    '2025-05-01',  -- Spring Day
    '2025-06-08',  -- Pentecost
    '2025-06-23',  -- Victory Day
    '2025-06-24',  -- Midsummer Day
    '2025-08-20',  -- Restoration of Independence
    '2025-12-24',  -- Christmas Eve
    '2025-12-25',  -- Christmas Day
    '2025-12-26'   -- Boxing Day
);

-- 4. Drivers (Fixed: realistic Estonian names, proper city_id reference)
INSERT INTO dim_driver (name, registration_date, city_id, rating, vehicle_type)
VALUES
('Jüri Tamm', DATE_SUB(CURDATE(), INTERVAL 1234 DAY), 1, 4.82, 'Sedan'),
('Mati Kask', DATE_SUB(CURDATE(), INTERVAL 987 DAY), 1, 4.91, 'SUV'),
('Peeter Kukk', DATE_SUB(CURDATE(), INTERVAL 756 DAY), 2, 4.65, 'Economy'),
('Andres Raudsepp', DATE_SUB(CURDATE(), INTERVAL 1456 DAY), 1, 4.88, 'Sedan'),
('Toomas Sepp', DATE_SUB(CURDATE(), INTERVAL 543 DAY), 3, 4.73, 'Economy'),
('Kalev Mägi', DATE_SUB(CURDATE(), INTERVAL 823 DAY), 2, 4.95, 'SUV'),
('Mart Laane', DATE_SUB(CURDATE(), INTERVAL 1102 DAY), 4, 4.58, 'Sedan'),
('PriitOrg', DATE_SUB(CURDATE(), INTERVAL 645 DAY), 1, 4.79, 'Economy'),
('Tarmo Paju', DATE_SUB(CURDATE(), INTERVAL 1345 DAY), 5, 4.67, 'SUV'),
('Raivo Saar', DATE_SUB(CURDATE(), INTERVAL 892 DAY), 1, 4.84, 'Sedan'),
('Olev Tamme', DATE_SUB(CURDATE(), INTERVAL 723 DAY), 2, 4.72, 'Economy'),
('Jaak Kruus', DATE_SUB(CURDATE(), INTERVAL 1234 DAY), 3, 4.89, 'Sedan'),
('Vello Lepp', DATE_SUB(CURDATE(), INTERVAL 456 DAY), 1, 4.63, 'SUV'),
('Rein Käär', DATE_SUB(CURDATE(), INTERVAL 1567 DAY), 4, 4.76, 'Economy'),
('Heino Nurk', DATE_SUB(CURDATE(), INTERVAL 934 DAY), 1, 4.93, 'Sedan'),
('Tõnu Vares', DATE_SUB(CURDATE(), INTERVAL 678 DAY), 2, 4.68, 'SUV'),
('Lembit Kuusk', DATE_SUB(CURDATE(), INTERVAL 1423 DAY), 5, 4.81, 'Economy'),
('Alo Pärn', DATE_SUB(CURDATE(), INTERVAL 812 DAY), 1, 4.87, 'Sedan'),
('Tiit Mets', DATE_SUB(CURDATE(), INTERVAL 1098 DAY), 3, 4.74, 'SUV'),
('Valdur Kivi', DATE_SUB(CURDATE(), INTERVAL 567 DAY), 2, 4.66, 'Economy');

-- 5. Riders (Fixed: realistic Estonian names)
INSERT INTO dim_rider (name, registration_date, loyalty_status)
VALUES
('Kati Tamm', DATE_SUB(CURDATE(), INTERVAL 1534 DAY), 'Gold'),
('Liis Kask', DATE_SUB(CURDATE(), INTERVAL 892 DAY), 'Silver'),
('Mari Kukk', DATE_SUB(CURDATE(), INTERVAL 1245 DAY), 'Bronze'),
('Anneli Mägi', DATE_SUB(CURDATE(), INTERVAL 678 DAY), 'Silver'),
('Kristi Sepp', DATE_SUB(CURDATE(), INTERVAL 1876 DAY), 'Gold'),
('Tiina Laane', DATE_SUB(CURDATE(), INTERVAL 423 DAY), 'Bronze'),
('Piret Org', DATE_SUB(CURDATE(), INTERVAL 1092 DAY), 'Silver'),
('Helen Paju', DATE_SUB(CURDATE(), INTERVAL 1567 DAY), 'Gold'),
('Kersti Saar', DATE_SUB(CURDATE(), INTERVAL 734 DAY), 'Bronze'),
('Monika Tamme', DATE_SUB(CURDATE(), INTERVAL 1234 DAY), 'Silver'),
('Laura Kruus', DATE_SUB(CURDATE(), INTERVAL 456 DAY), 'Bronze'),
('Kristiina Lepp', DATE_SUB(CURDATE(), INTERVAL 1678 DAY), 'Gold'),
('Ave Käär', DATE_SUB(CURDATE(), INTERVAL 912 DAY), 'Silver'),
('Marika Nurk', DATE_SUB(CURDATE(), INTERVAL 567 DAY), 'Bronze'),
('Sirje Vares', DATE_SUB(CURDATE(), INTERVAL 1345 DAY), 'Gold'),
('Ene Kuusk', DATE_SUB(CURDATE(), INTERVAL 823 DAY), 'Silver'),
('Külli Pärn', DATE_SUB(CURDATE(), INTERVAL 1456 DAY), 'Bronze'),
('Aino Mets', DATE_SUB(CURDATE(), INTERVAL 645 DAY), 'Silver'),
('Tiiu Kivi', DATE_SUB(CURDATE(), INTERVAL 1789 DAY), 'Gold'),
('Merike Tamm', DATE_SUB(CURDATE(), INTERVAL 534 DAY), 'Bronze'),
('Kai Raudsepp', DATE_SUB(CURDATE(), INTERVAL 1123 DAY), 'Silver'),
('Reet Männik', DATE_SUB(CURDATE(), INTERVAL 789 DAY), 'Bronze'),
('Anu Saks', DATE_SUB(CURDATE(), INTERVAL 1432 DAY), 'Gold'),
('Kadri Põld', DATE_SUB(CURDATE(), INTERVAL 623 DAY), 'Silver'),
('Lea Hein', DATE_SUB(CURDATE(), INTERVAL 1567 DAY), 'Bronze'),
('Rita Jõgi', DATE_SUB(CURDATE(), INTERVAL 845 DAY), 'Silver'),
('Ester Torn', DATE_SUB(CURDATE(), INTERVAL 1234 DAY), 'Gold'),
('Silva Rand', DATE_SUB(CURDATE(), INTERVAL 456 DAY), 'Bronze'),
('Aili Väli', DATE_SUB(CURDATE(), INTERVAL 1678 DAY), 'Silver'),
('Evi Allik', DATE_SUB(CURDATE(), INTERVAL 712 DAY), 'Bronze'),
('Inga Vaher', DATE_SUB(CURDATE(), INTERVAL 1345 DAY), 'Gold'),
('Õie Mänd', DATE_SUB(CURDATE(), INTERVAL 934 DAY), 'Silver'),
('Helgi Koiv', DATE_SUB(CURDATE(), INTERVAL 567 DAY), 'Bronze'),
('Aime Luik', DATE_SUB(CURDATE(), INTERVAL 1876 DAY), 'Gold'),
('Valve Karu', DATE_SUB(CURDATE(), INTERVAL 623 DAY), 'Silver'),
('Hilja Rebane', DATE_SUB(CURDATE(), INTERVAL 1432 DAY), 'Bronze'),
('Virve Hunt', DATE_SUB(CURDATE(), INTERVAL 789 DAY), 'Silver'),
('Meeli Jänes', DATE_SUB(CURDATE(), INTERVAL 1123 DAY), 'Gold'),
('Maie Hirv', DATE_SUB(CURDATE(), INTERVAL 845 DAY), 'Bronze'),
('Helle Ilves', DATE_SUB(CURDATE(), INTERVAL 1567 DAY), 'Silver'),
('Linda Metsis', DATE_SUB(CURDATE(), INTERVAL 456 DAY), 'Bronze'),
('Aasa Kotkas', DATE_SUB(CURDATE(), INTERVAL 1234 DAY), 'Gold'),
('Ülle Kull', DATE_SUB(CURDATE(), INTERVAL 678 DAY), 'Silver'),
('Viivi Haug', DATE_SUB(CURDATE(), INTERVAL 1789 DAY), 'Bronze'),
('Elvi Tuvi', DATE_SUB(CURDATE(), INTERVAL 534 DAY), 'Silver'),
('Helve Kägu', DATE_SUB(CURDATE(), INTERVAL 1456 DAY), 'Gold'),
('Maive Kivi', DATE_SUB(CURDATE(), INTERVAL 912 DAY), 'Bronze'),
('Taimi Kruusa', DATE_SUB(CURDATE(), INTERVAL 1092 DAY), 'Silver'),
('Eha Pärtel', DATE_SUB(CURDATE(), INTERVAL 734 DAY), 'Bronze'),
('Liia Kirsimäe', DATE_SUB(CURDATE(), INTERVAL 1678 DAY), 'Gold');

-- =====================================================
-- FACT TABLE GENERATION (1000 rides with realistic patterns)
-- =====================================================

DELIMITER $$

CREATE PROCEDURE generate_fact_rides()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE d_id INT;
    DECLARE r_id INT;
    DECLARE base_rating DECIMAL(3,2);
    DECLARE base_price DECIMAL(10,2);
    DECLARE pickup_loc INT;
    DECLARE dropoff_loc INT;
    DECLARE ride_date DATE;
    DECLARE ride_date_id INT;
    DECLARE start_dt DATETIME;
    DECLARE duration INT;
    DECLARE distance_km DECIMAL(6,2);
    DECLARE ride_status VARCHAR(20);
    DECLARE payment_type INT;

    WHILE i < 1000 DO
        -- Select random driver and rider
        SET d_id = FLOOR(1 + RAND() * 20);
        SET r_id = FLOOR(1 + RAND() * 50);

        -- Generate random date in 2025 (days 1-330 from Jan 1)
        SET ride_date = DATE_ADD('2025-01-01', INTERVAL FLOOR(RAND() * 330) DAY);

        -- Look up the corresponding date_id from dim_time
        SELECT date_id INTO ride_date_id
        FROM dim_time
        WHERE full_date = ride_date;

        -- Generate time of day (bias towards morning/evening rush hours)
        -- 20% chance of morning rush (7-9am), 20% evening rush (5-7pm), 60% other times
        SET start_dt = CASE
            WHEN RAND() < 0.2 THEN
                TIMESTAMP(ride_date, SEC_TO_TIME(FLOOR(7*3600 + RAND()*2*3600)))  -- 7-9 AM
            WHEN RAND() < 0.5 THEN
                TIMESTAMP(ride_date, SEC_TO_TIME(FLOOR(17*3600 + RAND()*2*3600))) -- 5-7 PM
            ELSE
                TIMESTAMP(ride_date, SEC_TO_TIME(FLOOR(RAND()*24*3600)))          -- Random
        END;

        -- Pickup and dropoff locations
        SET pickup_loc = FLOOR(1 + RAND() * 5);
        SET dropoff_loc = FLOOR(1 + RAND() * 5);

        -- Distance based on same/different cities
        SET distance_km = CASE
            WHEN pickup_loc = dropoff_loc THEN ROUND(1 + RAND() * 8, 1)      -- Same city: 1-9 km
            ELSE ROUND(10 + RAND() * 40, 1)                                    -- Different cities: 10-50 km
        END;

        -- Duration: roughly 2-3 min per km + random traffic (5-20 min)
        SET duration = FLOOR(distance_km * (2 + RAND()) + 5 + RAND() * 15);

        -- Base price: 2 EUR start + 0.80 EUR per km
        SET base_price = ROUND(2 + distance_km * 0.80, 2);

        -- Weekend/holiday surge pricing (20% increase)
        IF (SELECT is_weekend OR is_holiday FROM dim_time WHERE date_id = ride_date_id) THEN
            SET base_price = base_price * 1.2;
        END IF;

        -- Rush hour surge (30% increase)
        IF HOUR(start_dt) IN (7, 8, 17, 18) THEN
            SET base_price = base_price * 1.3;
        END IF;

        -- Driver experience factor (slightly higher ratings for experienced drivers)
        SET base_rating = ROUND(3.8 + RAND() * 1.2, 1);
        IF base_rating > 5.0 THEN SET base_rating = 5.0; END IF;

        -- Status distribution: 85% completed, 12% cancelled, 3% refunded
        SET ride_status = ELT(
            CASE
                WHEN RAND() < 0.85 THEN 1
                WHEN RAND() < 0.97 THEN 2
                ELSE 3
            END,
            'Completed', 'Cancelled', 'Refunded'
        );

        -- Payment type distribution: 10% cash, 40% card, 45% in-app, 5% promo
        SET payment_type = CASE
            WHEN RAND() < 0.10 THEN 1  -- Cash
            WHEN RAND() < 0.50 THEN 2  -- Card
            WHEN RAND() < 0.95 THEN 3  -- In-App
            ELSE 4                      -- Promo
        END;

        -- Cancelled/refunded rides have no rating and possibly reduced price
        IF ride_status != 'Completed' THEN
            SET base_rating = NULL;
            IF ride_status = 'Refunded' THEN
                SET base_price = 0;
            END IF;
        END IF;

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
            r_id,
            pickup_loc,
            dropoff_loc,
            ride_date_id,
            start_dt,
            TIMESTAMPADD(MINUTE, duration, start_dt),
            duration,
            distance_km,
            base_price,
            base_rating,
            payment_type,
            ride_status
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