-- =============================================
-- 04 - Capacity Utilization Analysis
-- =============================================

-- Row Level Utilization
SELECT shipment_id, ship_date, route_id, planned_capacity, actual_load, 
    ROUND(
        CASE 
            WHEN planned_capacity = 0 THEN 0 
            ELSE (actual_load/planned_capacity) * 100
        END, 2
    ) AS capacity_utilization_pct
FROM shipments;


-- Find shipments where: Utilization > 100 → Overloaded,  Utilization < 70 → Underutilized
SELECT shipment_id, capacity_utilization_pct,
    CASE 
        WHEN capacity_utilization_pct > 100 THEN 'Overloaded'
        WHEN capacity_utilization_pct < 70 THEN 'Underutilized'
        ELSE 'Optimal'
    END AS load_status
FROM (
    SELECT shipment_id, ship_date, route_id, planned_capacity, actual_load, 
        ROUND(
            CASE 
                WHEN planned_capacity = 0 THEN 0 
                ELSE (actual_load/planned_capacity) * 100
            END, 2
        ) AS capacity_utilization_pct
    FROM shipments
) t;


-- Count how many shipments are: Overloaded, Underutilized, Optimal
SELECT load_status, COUNT(*) as shipment_count
FROM (
    SELECT shipment_id, capacity_utilization_pct,
        CASE 
            WHEN capacity_utilization_pct > 100 THEN 'Overloaded'
            WHEN capacity_utilization_pct < 70 THEN 'Underutilized'
            ELSE 'Optimal'
        END AS load_status
    FROM (
        SELECT shipment_id, ship_date, route_id, planned_capacity, actual_load, 
            ROUND(
                CASE 
                    WHEN planned_capacity = 0 THEN 0 
                    ELSE (actual_load/planned_capacity) * 100
                END, 2
            ) AS capacity_utilization_pct
        FROM shipments
    ) t
) t2
GROUP BY load_status;


-- Hub Level Capacity Utilization
SELECT h.hub_name, 
    SUM(s.actual_load) as total_load, 
    SUM(s.planned_capacity) as total_capacity , 
    ROUND(
        CASE
            WHEN SUM(s.planned_capacity) = 0 THEN 0
            ELSE (SUM(s.actual_load)/SUM(s.planned_capacity)) * 100 
        END, 2
    ) AS utilization_pct
FROM shipments as s
INNER JOIN hubs as h
    ON s.origin_hub = h.hub_id
GROUP BY h.hub_name; 


-- Bottleneck Hub Detection
-- Find hubs where: Utilization > 100 → Overloaded hub, Utilization < 70 → Underutilized hub
WITH hub_util AS (
    SELECT h.hub_name, 
        SUM(s.actual_load) as total_load,
        SUM(s.planned_capacity) as total_capacity
    FROM shipments as s
    JOIN hubs as h
        ON s.origin_hub = h.hub_id
    GROUP BY h.hub_name
)
SELECT hub_name,
    ROUND(
        CASE 
            WHEN total_capacity = 0 THEN 0 
            ELSE (total_load/total_capacity) * 100 
        END, 2
    ) as utilization_pct, 
    CASE 
        WHEN (total_load/total_capacity) * 100 > 100 THEN 'Overloaded hub'
        WHEN (total_load / total_capacity) * 100 < 70 THEN 'Underutilized hub'
        ELSE 'Optimal hub'
    END AS hub_status
FROM hub_util;
