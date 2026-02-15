-- Route Performance Scorecard
-- Ops leadership wants a single view per route showing: Capacity pressure (utilization),  Service reliability (SLA breaches), Operational delays


SELECT r.route_id, r.origin_hub, r.destination_hub, 
	COUNT(s.shipment_id) AS total_shipments,

    -- Utilization %
    ROUND(
		CASE
			WHEN sum(s.planned_capacity) = 0 THEN 0 
            ELSE 
				SUM(s.actual_load) / sum(s.planned_capacity) * 100.0
		END, 2) AS utilization_pct,

	-- Delay %
	ROUND(
		CASE 
			WHEN COUNT(s.shipment_id) = 0 THEN 0 
            ELSE
				SUM(CASE WHEN s.arrival_delay_minutes > 0 THEN 1 ELSE 0 END) * 100.0 / COUNT(s.shipment_id)
		END, 2)  AS delay_pct,

	-- SLA Breach %
     ROUND(
        CASE 
            WHEN COUNT(s.shipment_id) = 0 THEN 0
            ELSE 
                SUM(CASE WHEN s.actual_transit_hours > s.sla_hours THEN 1 ELSE 0 END) 
                * 100.0 / COUNT(s.shipment_id)
        END, 2) AS sla_breach_pct

FROM shipments s
JOIN routes r
    ON s.route_id = r.route_id
GROUP BY r.route_id, r.origin_hub, r.destination_hub;
