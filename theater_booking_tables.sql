-- Theater Booking System Database Tables
-- Execute this SQL in your Supabase SQL Editor or Dashboard
-- Created: 2025-07-22

-- =====================================================
-- TABLE CREATION
-- =====================================================

-- 1. Create decorations table
CREATE TABLE IF NOT EXISTS public.decorations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    theater_id UUID REFERENCES public.theaters(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC NOT NULL,
    image_url TEXT,
    is_available BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- 2. Create occasions table
CREATE TABLE IF NOT EXISTS public.occasions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    icon_url TEXT,
    color_code TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- 3. Create add_ons table
CREATE TABLE IF NOT EXISTS public.add_ons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    theater_id UUID REFERENCES public.theaters(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC NOT NULL,
    category TEXT NOT NULL CHECK (category IN ('extra_special', 'gifts', 'special_services', 'cakes')),
    image_url TEXT,
    is_available BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- 4. Create theater_bookings table
CREATE TABLE IF NOT EXISTS public.theater_bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    theater_id UUID REFERENCES public.theaters(id) ON DELETE CASCADE,
    selected_date DATE NOT NULL,
    selected_time_slot TEXT NOT NULL,
    decoration_id UUID REFERENCES public.decorations(id) ON DELETE SET NULL,
    occasion_id UUID REFERENCES public.occasions(id) ON DELETE SET NULL,
    total_price NUMERIC DEFAULT 0,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled')),
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- 5. Create theater_booking_add_ons junction table
CREATE TABLE IF NOT EXISTS public.theater_booking_add_ons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID REFERENCES public.theater_bookings(id) ON DELETE CASCADE,
    add_on_id UUID REFERENCES public.add_ons(id) ON DELETE CASCADE,
    quantity INTEGER DEFAULT 1 CHECK (quantity > 0),
    created_at TIMESTAMPTZ DEFAULT now()
);

-- =====================================================
-- FUNCTIONS AND TRIGGERS
-- =====================================================

-- Function to update updated_at column
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at columns
DROP TRIGGER IF EXISTS update_decorations_updated_at ON public.decorations;
CREATE TRIGGER update_decorations_updated_at 
    BEFORE UPDATE ON public.decorations
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS update_add_ons_updated_at ON public.add_ons;
CREATE TRIGGER update_add_ons_updated_at 
    BEFORE UPDATE ON public.add_ons
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS update_theater_bookings_updated_at ON public.theater_bookings;
CREATE TRIGGER update_theater_bookings_updated_at 
    BEFORE UPDATE ON public.theater_bookings
    FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();

-- =====================================================
-- INDEXES FOR PERFORMANCE OPTIMIZATION
-- =====================================================

-- Indexes for decorations table
CREATE INDEX IF NOT EXISTS idx_decorations_theater_id ON public.decorations(theater_id);
CREATE INDEX IF NOT EXISTS idx_decorations_is_available ON public.decorations(is_available);

-- Indexes for add_ons table
CREATE INDEX IF NOT EXISTS idx_add_ons_theater_id ON public.add_ons(theater_id);
CREATE INDEX IF NOT EXISTS idx_add_ons_category ON public.add_ons(category);
CREATE INDEX IF NOT EXISTS idx_add_ons_is_available ON public.add_ons(is_available);

-- Indexes for theater_bookings table
CREATE INDEX IF NOT EXISTS idx_theater_bookings_user_id ON public.theater_bookings(user_id);
CREATE INDEX IF NOT EXISTS idx_theater_bookings_theater_id ON public.theater_bookings(theater_id);
CREATE INDEX IF NOT EXISTS idx_theater_bookings_selected_date ON public.theater_bookings(selected_date);
CREATE INDEX IF NOT EXISTS idx_theater_bookings_status ON public.theater_bookings(status);

-- Indexes for occasions table
CREATE INDEX IF NOT EXISTS idx_occasions_is_active ON public.occasions(is_active);

-- Indexes for theater_booking_add_ons table
CREATE INDEX IF NOT EXISTS idx_theater_booking_add_ons_booking_id ON public.theater_booking_add_ons(booking_id);
CREATE INDEX IF NOT EXISTS idx_theater_booking_add_ons_add_on_id ON public.theater_booking_add_ons(add_on_id);

-- =====================================================
-- ROW LEVEL SECURITY (RLS)
-- =====================================================

-- Enable RLS on all tables
ALTER TABLE public.decorations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.occasions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.add_ons ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.theater_bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.theater_booking_add_ons ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- RLS POLICIES
-- =====================================================

-- Policies for decorations table
DROP POLICY IF EXISTS "Decorations are viewable by everyone" ON public.decorations;
CREATE POLICY "Decorations are viewable by everyone" ON public.decorations
    FOR SELECT USING (true);

DROP POLICY IF EXISTS "Only authenticated users can manage decorations" ON public.decorations;
CREATE POLICY "Only authenticated users can manage decorations" ON public.decorations
    FOR ALL USING (auth.role() = 'authenticated');

-- Policies for occasions table
DROP POLICY IF EXISTS "Occasions are viewable by everyone" ON public.occasions;
CREATE POLICY "Occasions are viewable by everyone" ON public.occasions
    FOR SELECT USING (true);

DROP POLICY IF EXISTS "Only authenticated users can manage occasions" ON public.occasions;
CREATE POLICY "Only authenticated users can manage occasions" ON public.occasions
    FOR ALL USING (auth.role() = 'authenticated');

-- Policies for add_ons table
DROP POLICY IF EXISTS "Add-ons are viewable by everyone" ON public.add_ons;
CREATE POLICY "Add-ons are viewable by everyone" ON public.add_ons
    FOR SELECT USING (true);

DROP POLICY IF EXISTS "Only authenticated users can manage add-ons" ON public.add_ons;
CREATE POLICY "Only authenticated users can manage add-ons" ON public.add_ons
    FOR ALL USING (auth.role() = 'authenticated');

-- Policies for theater_bookings table
DROP POLICY IF EXISTS "Users can view their own bookings" ON public.theater_bookings;
CREATE POLICY "Users can view their own bookings" ON public.theater_bookings
    FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can create their own bookings" ON public.theater_bookings;
CREATE POLICY "Users can create their own bookings" ON public.theater_bookings
    FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update their own bookings" ON public.theater_bookings;
CREATE POLICY "Users can update their own bookings" ON public.theater_bookings
    FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete their own bookings" ON public.theater_bookings;
CREATE POLICY "Users can delete their own bookings" ON public.theater_bookings
    FOR DELETE USING (auth.uid() = user_id);

-- Policies for theater_booking_add_ons table
DROP POLICY IF EXISTS "Users can view add-ons for their own bookings" ON public.theater_booking_add_ons;
CREATE POLICY "Users can view add-ons for their own bookings" ON public.theater_booking_add_ons
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM public.theater_bookings 
            WHERE theater_bookings.id = theater_booking_add_ons.booking_id 
            AND theater_bookings.user_id = auth.uid()
        )
    );

DROP POLICY IF EXISTS "Users can manage add-ons for their own bookings" ON public.theater_booking_add_ons;
CREATE POLICY "Users can manage add-ons for their own bookings" ON public.theater_booking_add_ons
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM public.theater_bookings 
            WHERE theater_bookings.id = theater_booking_add_ons.booking_id 
            AND theater_bookings.user_id = auth.uid()
        )
    );

-- =====================================================
-- SAMPLE DATA (Optional - uncomment to insert test data)
-- =====================================================

/*
-- Insert sample occasions
INSERT INTO public.occasions (name, description, icon_url, color_code) VALUES
('Birthday', 'Celebrate special birthdays with style', 'https://example.com/birthday-icon.svg', '#FF6B6B'),
('Anniversary', 'Romantic anniversary celebrations', 'https://example.com/anniversary-icon.svg', '#FF69B4'),
('Proposal', 'Perfect for marriage proposals', 'https://example.com/proposal-icon.svg', '#FFD700'),
('Date Night', 'Romantic date night experience', 'https://example.com/date-night-icon.svg', '#9370DB'),
('Friends Hangout', 'Fun time with friends', 'https://example.com/friends-icon.svg', '#32CD32'),
('Family Time', 'Quality family bonding', 'https://example.com/family-icon.svg', '#FF8C00');

-- Note: You'll need to replace theater_id values with actual theater IDs from your theaters table
-- INSERT INTO public.decorations (theater_id, name, description, price, image_url) VALUES
-- ('your-theater-id-here', 'Romantic Rose Setup', 'Beautiful rose petals and candles', 500.00, 'https://example.com/rose-decoration.jpg');

-- INSERT INTO public.add_ons (theater_id, name, description, price, category, image_url) VALUES
-- ('your-theater-id-here', 'Chocolate Cake', 'Delicious chocolate birthday cake', 800.00, 'cakes', 'https://example.com/chocolate-cake.jpg');
*/

-- =====================================================
-- VERIFICATION QUERIES (Optional - run to verify setup)
-- =====================================================

/*
-- Check if all tables were created successfully
SELECT table_name, table_type 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('decorations', 'occasions', 'add_ons', 'theater_bookings', 'theater_booking_add_ons')
ORDER BY table_name;

-- Check if all indexes were created
SELECT indexname, tablename 
FROM pg_indexes 
WHERE schemaname = 'public' 
AND tablename IN ('decorations', 'occasions', 'add_ons', 'theater_bookings', 'theater_booking_add_ons')
ORDER BY tablename, indexname;

-- Check RLS status
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public' 
AND tablename IN ('decorations', 'occasions', 'add_ons', 'theater_bookings', 'theater_booking_add_ons');
*/