-- Theater Time Slots with Pricing and Availability
-- Execute this SQL in your Supabase SQL Editor
-- Created: 2025-07-26

-- =====================================================
-- CREATE THEATER TIME SLOTS TABLE
-- =====================================================

-- Create theater_time_slots table for dynamic pricing and availability
CREATE TABLE IF NOT EXISTS public.theater_time_slots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    theater_id UUID REFERENCES public.theaters(id) ON DELETE CASCADE,
    slot_name TEXT NOT NULL, -- e.g., 'Morning Show', 'Matinee Show'
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    base_price NUMERIC NOT NULL, -- Base price for this slot
    price_per_hour NUMERIC NOT NULL, -- Additional price per hour
    weekday_multiplier NUMERIC DEFAULT 1.0, -- Pricing multiplier for weekdays
    weekend_multiplier NUMERIC DEFAULT 1.5, -- Pricing multiplier for weekends
    holiday_multiplier NUMERIC DEFAULT 2.0, -- Pricing multiplier for holidays
    max_duration_hours INTEGER DEFAULT 2, -- Maximum booking duration in hours
    min_duration_hours INTEGER DEFAULT 2, -- Minimum booking duration in hours
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    
    -- Ensure start_time is before end_time
    CONSTRAINT check_time_order CHECK (start_time < end_time),
    -- Ensure multipliers are positive
    CONSTRAINT check_positive_multipliers CHECK (
        weekday_multiplier > 0 AND 
        weekend_multiplier > 0 AND 
        holiday_multiplier > 0
    ),
    -- Ensure prices are positive
    CONSTRAINT check_positive_prices CHECK (base_price >= 0 AND price_per_hour >= 0),
    -- Unique slot per theater
    CONSTRAINT unique_theater_slot UNIQUE (theater_id, start_time, end_time)
);

-- =====================================================
-- CREATE THEATER SLOT BOOKINGS TABLE
-- =====================================================

-- Track individual slot bookings with specific dates
CREATE TABLE IF NOT EXISTS public.theater_slot_bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    theater_id UUID REFERENCES public.theaters(id) ON DELETE CASCADE,
    time_slot_id UUID REFERENCES public.theater_time_slots(id) ON DELETE CASCADE,
    booking_date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    status TEXT DEFAULT 'available' CHECK (status IN ('available', 'booked', 'blocked', 'maintenance')),
    booking_id UUID REFERENCES public.theater_bookings(id) ON DELETE SET NULL,
    slot_price NUMERIC NOT NULL, -- Final calculated price for this specific booking
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now(),
    
    -- Ensure one booking per theater per date per time slot
    CONSTRAINT unique_theater_slot_booking UNIQUE (theater_id, time_slot_id, booking_date)
);

-- =====================================================
-- PRICING CALCULATION FUNCTION
-- =====================================================

-- Function to calculate slot price based on date and theater
CREATE OR REPLACE FUNCTION calculate_slot_price(
    p_theater_id UUID,
    p_time_slot_id UUID,
    p_booking_date DATE,
    p_duration_hours INTEGER DEFAULT 2
) RETURNS NUMERIC AS $$
DECLARE
    slot_info RECORD;
    day_of_week INTEGER;
    multiplier NUMERIC;
    final_price NUMERIC;
BEGIN
    -- Get slot information
    SELECT 
        base_price,
        price_per_hour,
        weekday_multiplier,
        weekend_multiplier,
        holiday_multiplier
    INTO slot_info
    FROM public.theater_time_slots
    WHERE id = p_time_slot_id AND theater_id = p_theater_id AND is_active = true;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Time slot not found or not active';
    END IF;
    
    -- Get day of week (0 = Sunday, 6 = Saturday)
    day_of_week := EXTRACT(DOW FROM p_booking_date);
    
    -- Determine multiplier based on day type
    IF day_of_week IN (0, 6) THEN -- Weekend
        multiplier := slot_info.weekend_multiplier;
    ELSE -- Weekday
        multiplier := slot_info.weekday_multiplier;
    END IF;
    
    -- TODO: Add holiday check logic here
    -- For now, we'll use weekend multiplier for holidays
    
    -- Calculate final price
    final_price := (slot_info.base_price + (slot_info.price_per_hour * p_duration_hours)) * multiplier;
    
    RETURN ROUND(final_price, 2);
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- AVAILABILITY CHECK FUNCTION
-- =====================================================

-- Function to check if a slot is available for booking
CREATE OR REPLACE FUNCTION is_slot_available(
    p_theater_id UUID,
    p_time_slot_id UUID,
    p_booking_date DATE
) RETURNS BOOLEAN AS $$
DECLARE
    booking_status TEXT;
BEGIN
    -- Check if slot exists and get its status
    SELECT status INTO booking_status
    FROM public.theater_slot_bookings
    WHERE theater_id = p_theater_id 
    AND time_slot_id = p_time_slot_id 
    AND booking_date = p_booking_date;
    
    -- If no record exists, slot is available
    IF NOT FOUND THEN
        RETURN true;
    END IF;
    
    -- Return true only if status is 'available'
    RETURN booking_status = 'available';
END;
$$ LANGUAGE plpgsql;

-- =====================================================
-- TRIGGERS
-- =====================================================

-- Update updated_at trigger for theater_time_slots
DROP TRIGGER IF EXISTS update_theater_time_slots_updated_at ON public.theater_time_slots;
CREATE TRIGGER update_theater_time_slots_updated_at 
    BEFORE UPDATE ON public.theater_time_slots
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- Update updated_at trigger for theater_slot_bookings
DROP TRIGGER IF EXISTS update_theater_slot_bookings_updated_at ON public.theater_slot_bookings;
CREATE TRIGGER update_theater_slot_bookings_updated_at 
    BEFORE UPDATE ON public.theater_slot_bookings
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =====================================================
-- INDEXES
-- =====================================================

-- Indexes for theater_time_slots
CREATE INDEX IF NOT EXISTS idx_theater_time_slots_theater_id ON public.theater_time_slots(theater_id);
CREATE INDEX IF NOT EXISTS idx_theater_time_slots_is_active ON public.theater_time_slots(is_active);
CREATE INDEX IF NOT EXISTS idx_theater_time_slots_start_time ON public.theater_time_slots(start_time);

-- Indexes for theater_slot_bookings
CREATE INDEX IF NOT EXISTS idx_theater_slot_bookings_theater_id ON public.theater_slot_bookings(theater_id);
CREATE INDEX IF NOT EXISTS idx_theater_slot_bookings_time_slot_id ON public.theater_slot_bookings(time_slot_id);
CREATE INDEX IF NOT EXISTS idx_theater_slot_bookings_booking_date ON public.theater_slot_bookings(booking_date);
CREATE INDEX IF NOT EXISTS idx_theater_slot_bookings_status ON public.theater_slot_bookings(status);

-- =====================================================
-- ROW LEVEL SECURITY
-- =====================================================

-- Enable RLS
ALTER TABLE public.theater_time_slots ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.theater_slot_bookings ENABLE ROW LEVEL SECURITY;

-- RLS Policies for theater_time_slots
DROP POLICY IF EXISTS "Time slots are viewable by everyone" ON public.theater_time_slots;
CREATE POLICY "Time slots are viewable by everyone" ON public.theater_time_slots
    FOR SELECT USING (true);

DROP POLICY IF EXISTS "Only authenticated users can manage time slots" ON public.theater_time_slots;
CREATE POLICY "Only authenticated users can manage time slots" ON public.theater_time_slots
    FOR ALL USING (auth.role() = 'authenticated');

-- RLS Policies for theater_slot_bookings
DROP POLICY IF EXISTS "Slot bookings are viewable by everyone" ON public.theater_slot_bookings;
CREATE POLICY "Slot bookings are viewable by everyone" ON public.theater_slot_bookings
    FOR SELECT USING (true);

DROP POLICY IF EXISTS "Only authenticated users can manage slot bookings" ON public.theater_slot_bookings;
CREATE POLICY "Only authenticated users can manage slot bookings" ON public.theater_slot_bookings
    FOR ALL USING (auth.role() = 'authenticated');

-- =====================================================
-- SAMPLE DATA FOR TESTING
-- =====================================================

-- Insert sample time slots (you'll need to replace theater_id with actual IDs)
/*
-- Example for a theater (replace 'YOUR_THEATER_ID' with actual theater ID)
INSERT INTO public.theater_time_slots (
    theater_id, slot_name, start_time, end_time, base_price, price_per_hour, 
    weekday_multiplier, weekend_multiplier, holiday_multiplier
) VALUES
    ('YOUR_THEATER_ID', 'Morning Show', '09:00', '11:00', 1500.00, 500.00, 1.0, 1.3, 1.8),
    ('YOUR_THEATER_ID', 'Matinee Show', '11:30', '13:30', 1800.00, 600.00, 1.0, 1.3, 1.8),
    ('YOUR_THEATER_ID', 'Afternoon Show', '14:00', '16:00', 2000.00, 700.00, 1.0, 1.3, 1.8),
    ('YOUR_THEATER_ID', 'Evening Show', '16:30', '18:30', 2500.00, 800.00, 1.2, 1.5, 2.0),
    ('YOUR_THEATER_ID', 'Night Show', '19:00', '21:00', 3000.00, 900.00, 1.2, 1.5, 2.0),
    ('YOUR_THEATER_ID', 'Late Night Show', '21:30', '23:30', 2800.00, 850.00, 1.1, 1.4, 1.9);

-- Create availability slots for next 30 days
DO $$
DECLARE
    theater_uuid UUID := 'YOUR_THEATER_ID'; -- Replace with actual theater ID
    slot_record RECORD;
    current_date DATE;
    end_date DATE;
BEGIN
    current_date := CURRENT_DATE;
    end_date := current_date + INTERVAL '30 days';
    
    -- Loop through each date
    WHILE current_date <= end_date LOOP
        -- Loop through each time slot for this theater
        FOR slot_record IN 
            SELECT id, start_time, end_time 
            FROM public.theater_time_slots 
            WHERE theater_id = theater_uuid AND is_active = true
        LOOP
            -- Calculate price for this slot on this date
            INSERT INTO public.theater_slot_bookings (
                theater_id, time_slot_id, booking_date, start_time, end_time, 
                status, slot_price
            ) VALUES (
                theater_uuid,
                slot_record.id,
                current_date,
                slot_record.start_time,
                slot_record.end_time,
                'available',
                calculate_slot_price(theater_uuid, slot_record.id, current_date, 2)
            )
            ON CONFLICT (theater_id, time_slot_id, booking_date) DO NOTHING;
        END LOOP;
        
        current_date := current_date + INTERVAL '1 day';
    END LOOP;
END $$;
*/

-- =====================================================
-- UTILITY QUERIES FOR TESTING
-- =====================================================

/*
-- Get available slots for a specific theater and date
SELECT 
    ts.slot_name,
    ts.start_time,
    ts.end_time,
    tsb.slot_price,
    tsb.status,
    calculate_slot_price(ts.theater_id, ts.id, CURRENT_DATE, 2) as calculated_price
FROM public.theater_time_slots ts
LEFT JOIN public.theater_slot_bookings tsb ON (
    tsb.theater_id = ts.theater_id 
    AND tsb.time_slot_id = ts.id 
    AND tsb.booking_date = CURRENT_DATE
)
WHERE ts.theater_id = 'YOUR_THEATER_ID'
AND ts.is_active = true
ORDER BY ts.start_time;

-- Check slot availability
SELECT is_slot_available('YOUR_THEATER_ID', 'YOUR_TIME_SLOT_ID', CURRENT_DATE) as is_available;

-- Calculate price for a specific slot
SELECT calculate_slot_price('YOUR_THEATER_ID', 'YOUR_TIME_SLOT_ID', CURRENT_DATE, 2) as slot_price;
*/