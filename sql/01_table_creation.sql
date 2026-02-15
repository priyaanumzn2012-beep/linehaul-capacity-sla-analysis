CREATE TABLE hubs (
    hub_id INT PRIMARY KEY,
    hub_name VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE routes (
    route_id INT PRIMARY KEY,
    origin_hub INT,
    destination_hub INT
);

CREATE TABLE shipments (
    shipment_id INT PRIMARY KEY,
    route_id INT,
    planned_capacity INT,
    actual_load INT,
    arrival_delay_minutes INT
);
