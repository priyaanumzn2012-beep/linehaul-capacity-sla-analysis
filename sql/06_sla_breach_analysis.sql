-- SLA Breach Analysis
SELECT r.route_id, r.origin_hub, r.destination_hub,
    COUNT(s.shipment_id) as total_shipments,
    SUM(
        CASE 
            WHEN s.actual_transit_hours > s.sla_hours THEN 1
            ELSE 0
        END) AS sla_breached_shipments,
    ROUND(
        CASE 
            WHEN COUNT(s.shipment_id) = 0 THEN 0
            ELSE 
                 SUM(CASE WHEN s.actual_transit_hours > s.sla_hours THEN 1 ELSE 0 END) 
                * 100.0 / COUNT(s.shipment_id)
        END, 2 ) AS sla_breach_pct
        
FROM shipments as s
JOIN routes as r
    ON s.route_id = r.route_id
GROUP BY r.route_id, r.origin_hub, r.destination_hub;
