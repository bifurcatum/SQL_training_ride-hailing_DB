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

-- 1. Locations (must be created first as drivers reference it)
CREATE TABLE dim_location (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    city_name VARCHAR(100) NOT NULL,
    region_name VARCHAR(100),
    country VARCHAR(50) DEFAULT 'Estonia'
);

-- 2. Drivers
CREATE TABLE dim_driver (
    driver_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    registration_date DATE,
    city_id INT,
    rating DECIMAL(3,2),
    vehicle_type VARCHAR(50),
    -- Fixed: Added missing foreign key constraint
    FOREIGN KEY (city_id) REFERENCES dim_location(location_id),
    -- Added: Validation constraint for rating
    CONSTRAINT chk_driver_rating CHECK (rating >= 0 AND rating <= 5)
);

-- 3. Riders
CREATE TABLE dim_rider (
    rider_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    registration_date DATE,
    loyalty_status VARCHAR(20),
    -- Added: Validation constraint for loyalty status
    CONSTRAINT chk_loyalty_status CHECK (loyalty_status IN ('Bronze', 'Silver', 'Gold'))
);

-- 4. Payment types
CREATE TABLE dim_payment_type (
    payment_type_id INT PRIMARY KEY AUTO_INCREMENT,
    payment_method VARCHAR(20) NOT NULL UNIQUE
);

-- 5. Time dimension
CREATE TABLE dim_time (
    date_id INT PRIMARY KEY AUTO_INCREMENT,
    full_date DATE NOT NULL UNIQUE,
    day_of_week VARCHAR(10),
    day_of_week_num TINYINT,  -- 1=Monday, 7=Sunday
    week_of_year TINYINT,
    month INT,
    month_name VARCHAR(10),
    quarter TINYINT,
    year INT,
    is_weekend BOOLEAN,
    -- Added: Useful for analysis
    is_holiday BOOLEAN DEFAULT FALSE
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
    FOREIGN KEY (payment_type_id) REFERENCES dim_payment_type(payment_type_id),

    -- Added: Validation constraints
    CONSTRAINT chk_ride_status CHECK (status IN ('Completed', 'Cancelled', 'Refunded')),
    CONSTRAINT chk_ride_rating CHECK (rating >= 0 AND rating <= 5 OR rating IS NULL),
    CONSTRAINT chk_ride_duration CHECK (duration > 0),
    CONSTRAINT chk_ride_distance CHECK (distance >= 0),
    CONSTRAINT chk_ride_price CHECK (price >= 0),
    CONSTRAINT chk_end_after_start CHECK (end_time >= start_time),

    -- Added: Indexes for common query patterns
    INDEX idx_driver_date (driver_id, date_id),
    INDEX idx_rider_date (rider_id, date_id),
    INDEX idx_pickup_location (pickup_location_id),
    INDEX idx_dropoff_location (dropoff_location_id),
    INDEX idx_status (status),
    INDEX idx_start_time (start_time),
    INDEX idx_date_status (date_id, status)
);

-- =====================================================
--  Notes:
--  - Star schema: fact_rides (central) + 5 dimensions
--  - Added missing foreign key for driver.city_id
--  - Added CHECK constraints for data validation
--  - Added indexes for common query patterns
--  - Fixed dim_time structure for proper date dimension
--  - Includes fields for:
--      * temporal analysis (start_time, end_time, dim_time)
--      * categorical aggregation (payment_type, status)
--      * advanced window functions (LAG, LEAD, ROLLUP, CUBE)
-- =====================================================