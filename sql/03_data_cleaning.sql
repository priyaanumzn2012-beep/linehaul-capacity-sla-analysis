-- ============================================
-- DATA CLEANING & STANDARDIZATION
-- Linehaul Capacity & SLA Risk Analysis
-- ============================================

-- 1. Remove shipments with NULL critical values
DELETE FROM shipments
WHERE shipment_id IS NULL
   OR origin_hub IS NULL
   OR destination_hub IS NULL;

-- 2. Replace negative delays with 0
UPDATE shipments
SET arrival_delay_minutes = 0
WHERE arrival_delay_minutes < 0;

-- 3. Trim unwanted spaces from text columns
UPDATE hubs
SET hub_name = TRIM(hub_name);

UPDATE routes
SET origin_hub = TRIM(origin_hub),
    destination_hub = TRIM(destination_hub);

-- 4. Handle invalid capacity values
UPDATE shipments
SET planned_capacity = NULL
WHERE planned_capacity <= 0;

-- 5. Remove rows where both capacity & load missing
DELETE FROM shipments
WHERE planned_capacity IS NULL
  AND actual_load IS NULL;
