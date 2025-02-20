USE `dep-project`;

-- create 7 table schema
CREATE TABLE time (
    time_id VARCHAR(50) PRIMARY KEY,
    year INT NOT NULL,
    month INT NOT NULL,
    day INT NOT NULL,
    hour INT NOT NULL,
    day_of_week VARCHAR(20) NOT NULL
);

CREATE TABLE weather (
    time_id VARCHAR(50) PRIMARY KEY,
    temperature FLOAT NOT NULL,
    wind_speed FLOAT NOT NULL,
    precipitation FLOAT NOT NULL
);

CREATE TABLE subway_fare_category (
    fare_category_id INT PRIMARY KEY,
    fare_class_category VARCHAR(100) NOT NULL
);

CREATE TABLE subway_stations (
    station_complex_id INT PRIMARY KEY,
    station_complex VARCHAR(255) NOT NULL,
    latitude FLOAT NOT NULL,
    longitude FLOAT NOT NULL
);

CREATE TABLE subway_hourly_rides (
    time_id VARCHAR(50) NOT NULL,
    transit_mode VARCHAR(50) NOT NULL,
    station_complex_id INT NOT NULL,
    borough VARCHAR(100) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    fare_class_category_id INT NOT NULL,
    ridership INT NOT NULL,
    transfers INT NOT NULL,
    PRIMARY KEY (time_id, station_complex_id, transit_mode)
);


CREATE TABLE bike_stations (
    station_id VARCHAR(50) PRIMARY KEY,
    station_name VARCHAR(255) NOT NULL,
    latitude FLOAT NOT NULL,
    longitude FLOAT NOT NULL
);

CREATE TABLE bike_rides (
    ride_id VARCHAR(50) PRIMARY KEY,
    started_at DATETIME NOT NULL,
    ended_at DATETIME NOT NULL,
    start_station_id VARCHAR(50) NOT NULL,
    end_station_id VARCHAR(50) NOT NULL,
    duration_min FLOAT NOT NULL,
    time_id VARCHAR(50) NOT NULL
);

-- aggregrated table
CREATE TABLE bike_hourly_rides (
	time_id VARCHAR(50) NOT NULL,
    start_station_id VARCHAR(50) NOT NULL,
    total_rides INT NOT NULL
);

CREATE TABLE bike_duration_stats_hourly (
	time_id VARCHAR(50) NOT NULL,
    max_duration FLOAT NOT NULL,
    min_duration FLOAT NOT NULL,
    avg_duration FLOAT NOT NULL
);


-- keep only the data within time of interest
SET SQL_SAFE_UPDATES = 0;

DELETE FROM weather
WHERE time_id NOT IN (SELECT time_id FROM time);

DELETE FROM subway_hourly_rides
WHERE time_id NOT IN (SELECT time_id FROM time);

DELETE FROM bike_rides
WHERE time_id NOT IN (SELECT time_id FROM time);

SET SQL_SAFE_UPDATES = 1;


SET net_read_timeout = 600;
SET net_write_timeout = 600;
SET wait_timeout = 600;
SET interactive_timeout = 600;


-- connect the tables
-- some were connected mannually, some are by code
-- 1
ALTER TABLE weather
ADD CONSTRAINT fk_weather_time
FOREIGN KEY (time_id)
REFERENCES time(time_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- 2
ALTER TABLE subway_hourly_rides
ADD CONSTRAINT fk_subway_hourly_rides_time
FOREIGN KEY (time_id)
REFERENCES time(time_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM subway_hourly_rides
WHERE station_complex_id NOT IN (SELECT station_complex_id FROM subway_stations);





DELIMITER //

CREATE PROCEDURE DeleteInvalidRows()
BEGIN
    DECLARE rows_affected INT DEFAULT 1;
    WHILE rows_affected > 0 DO
        DELETE FROM subway_hourly_rides
        WHERE station_complex_id NOT IN (SELECT station_complex_id FROM subway_stations)
        LIMIT 1000;
        SET rows_affected = ROW_COUNT();
    END WHILE;
END //

DELIMITER ;

CALL DeleteInvalidRows();

ALTER TABLE subway_hourly_rides
ADD CONSTRAINT fk_subway_hourly_rides_station
FOREIGN KEY (station_complex_id)
REFERENCES subway_stations(station_complex_id)
ON DELETE CASCADE
ON UPDATE CASCADE;




ALTER TABLE subway_hourly_rides
ADD CONSTRAINT fk_subway_hourly_rides_fare
FOREIGN KEY (fare_class_category_id)
REFERENCES subway_fare_category(fare_category_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

