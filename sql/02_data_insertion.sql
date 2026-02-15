-- ============================================
-- DATA INSERTION / LOADING FROM CSV FILES
-- ============================================

-- Load hubs data
-- (Use appropriate method based on your SQL engine)

-- MySQL Example:
-- LOAD DATA INFILE 'hubs.csv'
-- INTO TABLE hubs
-- FIELDS TERMINATED BY ','
-- IGNORE 1 ROWS;

-- PostgreSQL Example:
-- COPY hubs FROM 'hubs.csv' DELIMITER ',' CSV HEADER;

-- --------------------------------------------

-- Load routes data

-- MySQL:
-- LOAD DATA INFILE 'routes.csv'
-- INTO TABLE routes
-- FIELDS TERMINATED BY ','
-- IGNORE 1 ROWS;

-- PostgreSQL:
-- COPY routes FROM 'routes.csv' DELIMITER ',' CSV HEADER;

-- --------------------------------------------

-- Load shipments data

-- MySQL:
-- LOAD DATA INFILE 'shipments_1000.csv'
-- INTO TABLE shipments
-- FIELDS TERMINATED BY ','
-- IGNORE 1 ROWS;

-- PostgreSQL:
-- COPY shipments FROM 'shipments_1000.csv' DELIMITER ',' CSV HEADER;
