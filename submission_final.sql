SELECT 
    TABLE_NAME AS table_name,
    COLUMN_NAME AS column_name,
    DATA_TYPE AS data_type
FROM 
    information_schema.COLUMNS
WHERE 
    TABLE_SCHEMA = 'dep-project'
ORDER BY 
    TABLE_NAME, ORDINAL_POSITION;
    
USE `dep-project`;


SELECT 
    start_station_id, 
    AVG(duration_min) AS avg_duration
FROM 
    bike_rides
WHERE 
    start_station_id BETWEEN 'A' AND 'M'
GROUP BY 
    start_station_id
ORDER BY 
    avg_duration DESC
LIMIT 10;
--  ------ 
SELECT 'bike_rides' AS table_name, COUNT(*) AS row_count FROM bike_rides
UNION ALL
SELECT 'bike_stations', COUNT(*) FROM bike_stations
UNION ALL
SELECT 'subway_fare_category', COUNT(*) FROM subway_fare_category
UNION ALL
SELECT 'subway_hourly_rides', COUNT(*) FROM subway_hourly_rides
UNION ALL
SELECT 'subway_stations', COUNT(*) FROM subway_stations
UNION ALL
SELECT 'time', COUNT(*) FROM time
UNION ALL
SELECT 'weather', COUNT(*) FROM weather;
-- --------

SELECT 
    w.temperature,
    w.wind_speed,
    w.precipitation,
    COUNT(b.ride_id) AS total_rides
FROM 
    weather w
LEFT JOIN 
    bike_rides b ON w.time_id = b.time_id
GROUP BY 
    w.temperature, w.wind_speed, w.precipitation
ORDER BY 
    w.temperature;
    
-- ----------
SELECT 
    temperature_range_start,
    temperature_range_end,
    AVG(wind_speed) AS avg_wind_speed,
    AVG(precipitation) AS avg_precipitation,
    SUM(total_rides) AS total_rides
FROM (
    SELECT 
        FLOOR(w.temperature / 5) * 5 AS temperature_range_start,
        FLOOR(w.temperature / 5) * 5 + 4 AS temperature_range_end,
        w.wind_speed,
        w.precipitation,
        CASE WHEN b.ride_id IS NOT NULL THEN 1 ELSE 0 END AS total_rides
    FROM 
        weather w
    LEFT JOIN 
        bike_rides b ON w.time_id = b.time_id
) AS grouped_data
GROUP BY 
    temperature_range_start, temperature_range_end
ORDER BY 
    temperature_range_start
LIMIT 0, 1000;
-- Find the sites with the highest number of cycles per hour

SELECT 
    bhr.time_id, 
    bhr.start_station_id, 
    bs.station_name, 
    bs.latitude, 
    bs.longitude, 
    MAX(bhr.total_rides) AS max_rides
FROM 
    bike_hourly_rides bhr
JOIN 
    bike_stations bs ON bhr.start_station_id = bs.station_id
GROUP BY 
    bhr.time_id, bhr.start_station_id, bs.station_name, bs.latitude, bs.longitude
ORDER BY 
    max_rides DESC;
-- Multi-modal traffic analysis combining metro and bicycle

SELECT 
    t.time_id,
    t.year,
    t.month,
    t.day,
    t.hour,
    COALESCE(SUM(bhr.total_rides), 0) AS total_bike_rides,
    COALESCE(SUM(shr.ridership), 0) AS total_subway_ridership
FROM 
    time t
LEFT JOIN 
    bike_hourly_rides bhr ON t.time_id = bhr.time_id
LEFT JOIN 
    subway_hourly_rides shr ON t.time_id = shr.time_id
GROUP BY 
    t.time_id, t.year, t.month, t.day, t.hour
ORDER BY 
    t.year, t.month, t.day, t.hour;
    
    -- Weather effects on bicycle and subway use
SELECT 
    w.temperature,
    w.wind_speed,
    w.precipitation,
    AVG(bhr.total_rides) AS avg_bike_rides,
    AVG(shr.ridership) AS avg_subway_ridership
FROM 
    weather w
LEFT JOIN 
    bike_hourly_rides bhr ON w.time_id = bhr.time_id
LEFT JOIN 
    subway_hourly_rides shr ON w.time_id = shr.time_id
GROUP BY 
    w.temperature, w.wind_speed, w.precipitation
ORDER BY 
    w.temperature DESC;
    
-- Peak time period analysis
SELECT 
    t.day_of_week,
    CASE 
        WHEN t.hour BETWEEN 7 AND 9 THEN 'Morning Peak'
        WHEN t.hour BETWEEN 17 AND 19 THEN 'Evening Peak'
        ELSE 'Off-Peak'
    END AS time_period,
    SUM(bhr.total_rides) AS total_bike_rides,
    SUM(shr.ridership) AS total_subway_ridership
FROM 
    time t
LEFT JOIN 
    bike_hourly_rides bhr ON t.time_id = bhr.time_id
LEFT JOIN 
    subway_hourly_rides shr ON t.time_id = shr.time_id
GROUP BY 
    t.day_of_week, time_period
ORDER BY 
    t.day_of_week, time_period;


