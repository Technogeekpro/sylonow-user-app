-- Remove unnecessary columns from theater_time_slots table
-- Keep only base_price and discounted_price for simplified pricing

ALTER TABLE theater_time_slots
DROP COLUMN IF EXISTS price_per_hour,
DROP COLUMN IF EXISTS weekday_multiplier,
DROP COLUMN IF EXISTS weekend_multiplier,
DROP COLUMN IF EXISTS holiday_multiplier,
DROP COLUMN IF EXISTS max_duration_hours,
DROP COLUMN IF EXISTS min_duration_hours;

-- Note: hourly_rate and price_multiplier columns are not in the current schema
-- so they don't need to be dropped