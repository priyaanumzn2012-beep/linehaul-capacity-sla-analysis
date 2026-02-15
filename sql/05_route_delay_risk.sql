-- Route Delay Risk Analysis
SELECT r.route_id, r.origin_hub, r.destination_hub,
    COUNT(s.shipment_id) AS total_shipments,
    SUM(
        CASE 
            WHEN s.arrival_delay_minutes > 0 THEN 1 
            ELSE 0 
        END
    ) AS delayed_shipments,
    ROUND(
        CASE 
            WHEN COUNT(s.shipment_id) = 0 THEN 0
            ELSE 
                SUM(CASE WHEN s.arrival_delay_minutes > 0 THEN 1 ELSE 0 END) 
                * 100.0 / COUNT(s.shipment_id)
        END, 2
    ) AS delay_pct
FROM shipments s
JOIN routes r
    ON s.route_id = r.route_id
GROUP BY r.route_id, r.origin_hub, r.destination_hub
ORDER BY delay_pct DESC;
