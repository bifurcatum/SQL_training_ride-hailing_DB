-- =====================================================
--  Ride-Hailing Star Schema Training Database
-- =====================================================

-- Drop and recreate the database
DROP DATABASE IF EXISTS ride_hailing;
CREATE DATABASE ride_hailing;
USE ride_hailing;

-- =====================================================
--  Dimension Tables
-- =====================================================

-- 1. Drivers
CREATE TABLE dim_driver (
    driver_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    registration_date DATE,
    city_id INT,
    rating DECIMAL(3,2),
    vehicle_type VARCHAR(50)
);

-- 2. Riders
CREATE TABLE dim_rider (
    rider_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    registration_date DATE,
    loyalty_status VARCHAR(20)
);

-- 3. Locations
CREATE TABLE dim_location (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    city_name VARCHAR(100) NOT NULL,
    region_name VARCHAR(100),
    country VARCHAR(50) DEFAULT 'Estonia'
);

-- 4. Payment types
CREATE TABLE dim_payment_type (
    payment_type_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_method VARCHAR(20) NOT NULL
);

-- 5. Time dimension
CREATE TABLE dim_time (
    date_id INT PRIMARY KEY AUTO_INCREMENT,
    full_date DATE NOT NULL,
    day_of_week VARCHAR(10),
    month INT,
    year INT,
    is_weekend BOOLEAN
);

-- =====================================================
--  Fact Table
-- =====================================================

CREATE TABLE fact_rides (
    ride_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    driver_id INT NOT NULL,
    rider_id INT NOT NULL,
    pickup_location_id INT NOT NULL,
    dropoff_location_id INT NOT NULL,
    date_id INT NOT NULL,
    start_time DATETIME,
    end_time DATETIME,
    duration INT, -- in minutes
    distance DECIMAL(6,2), -- in km
    price DECIMAL(10,2),
    rating DECIMAL(2,1),
    payment_type_id INT,
    status VARCHAR(20),

    -- Foreign keys
    FOREIGN KEY (driver_id) REFERENCES dim_driver(driver_id),
    FOREIGN KEY (rider_id) REFERENCES dim_rider(rider_id),
    FOREIGN KEY (pickup_location_id) REFERENCES dim_location(location_id),
    FOREIGN KEY (dropoff_location_id) REFERENCES dim_location(location_id),
    FOREIGN KEY (date_id) REFERENCES dim_time(date_id),
    FOREIGN KEY (payment_type_id) REFERENCES dim_payment_type(payment_type_id)
);

-- =====================================================
--  Notes:
--  - Star schema: fact_rides (central) + 5 dimensions.
--  - Includes fields for:
--      * temporal analysis (start_time, end_time, dim_time)
--      * categorical aggregation (payment_type, status)
--      * advanced window functions (LAG, LEAD, ROLLUP, CUBE)
-- =====================================================
