-- Add timing columns to vendors table
-- This migration adds start_time and close_time columns to track vendor business hours

-- Add start_time and close_time columns to vendors table
ALTER TABLE vendors 
ADD COLUMN IF NOT EXISTS start_time TIME DEFAULT '09:00:00',
ADD COLUMN IF NOT EXISTS close_time TIME DEFAULT '18:00:00';

-- Add advance_booking_hours column for minimum advance booking time
ALTER TABLE vendors 
ADD COLUMN IF NOT EXISTS advance_booking_hours INTEGER DEFAULT 2;

-- Add is_online column to track vendor online status
ALTER TABLE vendors 
ADD COLUMN IF NOT EXISTS is_online BOOLEAN DEFAULT false;

-- Add last_online_at column to track when vendor was last online
ALTER TABLE vendors 
ADD COLUMN IF NOT EXISTS last_online_at TIMESTAMPTZ;

-- Create index for online status queries
CREATE INDEX IF NOT EXISTS idx_vendors_is_online ON vendors(is_online);

-- Create index for timing queries
CREATE INDEX IF NOT EXISTS idx_vendors_start_time ON vendors(start_time);
CREATE INDEX IF NOT EXISTS idx_vendors_close_time ON vendors(close_time);

-- Update existing vendors with some sample timing data
UPDATE vendors SET 
  start_time = '09:00:00',
  close_time = '18:00:00',
  advance_booking_hours = 2,
  is_online = true,
  last_online_at = NOW()
WHERE start_time IS NULL;

-- Add vendor_id column to decorations table
ALTER TABLE decorations 
ADD COLUMN IF NOT EXISTS vendor_id UUID REFERENCES vendors(id) ON DELETE SET NULL;

-- Add some sample data for testing
INSERT INTO vendors (id, business_name, start_time, close_time, advance_booking_hours, is_online, last_online_at)
VALUES 
  (gen_random_uuid(), 'Morning Decorators', '06:00:00', '14:00:00', 1, true, NOW()),
  (gen_random_uuid(), 'Evening Events', '14:00:00', '22:00:00', 3, true, NOW()),
  (gen_random_uuid(), 'All Day Decor', '08:00:00', '20:00:00', 2, false, NOW() - INTERVAL '2 hours')
ON CONFLICT DO NOTHING;

-- Update existing decorations with vendor IDs (for testing)
UPDATE decorations 
SET vendor_id = (SELECT id FROM vendors WHERE business_name = 'All Day Decor' LIMIT 1)
WHERE vendor_id IS NULL;
