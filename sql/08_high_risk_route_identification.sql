-- High Risk Route Identification
-- Leadership wants to quickly identify high-risk routes that are operationally unstable and may need intervention. We will classify each route based on:  High delay %, High SLA breach %, High utilization pressure


WITH route_scorecard AS (
	SELECT r.route_id, r.origin_hub, r.destination_hub, 
    COUNT(s.shipment_id) AS total_shipments,

    -- Utilization %
    ROUND(
            CASE
                WHEN SUM(s.planned_capacity) = 0 THEN 0 
                ELSE 
                    SUM(s.actual_load) * 100.0 / SUM(s.planned_capacity)
            END, 2) AS utilization_pct,

	-- Delay %
     ROUND(
            CASE 
                WHEN COUNT(s.shipment_id) = 0 THEN 0
                ELSE 
                    SUM(CASE WHEN s.arrival_delay_minutes > 0 THEN 1 ELSE 0 END) 
                    * 100.0 / COUNT(s.shipment_id)
            END, 2) AS delay_pct,

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
    GROUP BY r.route_id, r.origin_hub, r.destination_hub
)

SELECT route_id, origin_hub, destination_hub, delay_pct, sla_breach_pct, utilization_pct,
    CASE 
        WHEN delay_pct > 30 
             OR sla_breach_pct > 25 
             OR utilization_pct > 95 
        THEN 'HIGH RISK'

        WHEN delay_pct BETWEEN 15 AND 30
             OR sla_breach_pct BETWEEN 10 AND 25
        THEN 'MEDIUM RISK'

        ELSE 'LOW RISK'
    END AS risk_category

FROM route_scorecard
ORDER BY risk_category DESC, delay_pct DESC;
