-- Private Theater Booking Flow Database Tables
-- Execute this SQL in your Supabase SQL Editor

-- Create decorations table
CREATE TABLE IF NOT EXISTS public.decorations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    theater_id UUID NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    image_url TEXT,
    is_available BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT fk_decorations_theater_id FOREIGN KEY (theater_id) REFERENCES public.service_listings(id) ON DELETE CASCADE
);

-- Create occasions table
CREATE TABLE IF NOT EXISTS public.occasions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    icon_url TEXT,
    color_code TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create add_ons table
CREATE TABLE IF NOT EXISTS public.add_ons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    theater_id UUID NOT NULL,
    name TEXT NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    category TEXT,
    image_url TEXT,
    is_available BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    CONSTRAINT fk_add_ons_theater_id FOREIGN KEY (theater_id) REFERENCES public.service_listings(id) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_decorations_theater_id ON public.decorations(theater_id);
CREATE INDEX IF NOT EXISTS idx_decorations_is_available ON public.decorations(is_available);
CREATE INDEX IF NOT EXISTS idx_occasions_is_active ON public.occasions(is_active);
CREATE INDEX IF NOT EXISTS idx_add_ons_theater_id ON public.add_ons(theater_id);
CREATE INDEX IF NOT EXISTS idx_add_ons_is_available ON public.add_ons(is_available);
CREATE INDEX IF NOT EXISTS idx_add_ons_category ON public.add_ons(category);

-- Create updated_at trigger function if it doesn't exist
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at columns
DROP TRIGGER IF EXISTS update_decorations_updated_at ON public.decorations;
CREATE TRIGGER update_decorations_updated_at
    BEFORE UPDATE ON public.decorations
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

DROP TRIGGER IF EXISTS update_add_ons_updated_at ON public.add_ons;
CREATE TRIGGER update_add_ons_updated_at
    BEFORE UPDATE ON public.add_ons
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

-- Enable Row Level Security (RLS)
ALTER TABLE public.decorations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.occasions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.add_ons ENABLE ROW LEVEL SECURITY;

-- RLS Policies for decorations table
-- Users can view all available decorations
CREATE POLICY "Users can view available decorations" ON public.decorations
    FOR SELECT
    USING (is_available = true);

-- Theater owners can manage decorations for their theaters
-- (Assuming we have a way to identify theater owners via service_listings)
CREATE POLICY "Theater owners can manage their decorations" ON public.decorations
    FOR ALL
    USING (
        theater_id IN (
            SELECT id FROM public.service_listings 
            WHERE vendor_id = (
                SELECT vendor_id FROM public.vendors 
                WHERE user_id = auth.uid()
            )
        )
    );

-- System admins can manage all decorations (if you have admin roles)
-- CREATE POLICY "Admins can manage all decorations" ON public.decorations
--     FOR ALL
--     USING (auth.jwt() ->> 'role' = 'admin');

-- RLS Policies for occasions table
-- Users can view all active occasions
CREATE POLICY "Users can view active occasions" ON public.occasions
    FOR SELECT
    USING (is_active = true);

-- System admins can manage occasions
-- CREATE POLICY "Admins can manage occasions" ON public.occasions
--     FOR ALL
--     USING (auth.jwt() ->> 'role' = 'admin');

-- For now, allow service role to manage occasions
CREATE POLICY "Service role can manage occasions" ON public.occasions
    FOR ALL
    USING (auth.role() = 'service_role');

-- RLS Policies for add_ons table
-- Users can view all available add-ons
CREATE POLICY "Users can view available add_ons" ON public.add_ons
    FOR SELECT
    USING (is_available = true);

-- Theater owners can manage add-ons for their theaters
CREATE POLICY "Theater owners can manage their add_ons" ON public.add_ons
    FOR ALL
    USING (
        theater_id IN (
            SELECT id FROM public.service_listings 
            WHERE vendor_id = (
                SELECT vendor_id FROM public.vendors 
                WHERE user_id = auth.uid()
            )
        )
    );

-- System admins can manage all add-ons (if you have admin roles)
-- CREATE POLICY "Admins can manage all add_ons" ON public.add_ons
--     FOR ALL
--     USING (auth.jwt() ->> 'role' = 'admin');

-- Insert sample occasions data
INSERT INTO public.occasions (name, description, icon_url, color_code) VALUES
('Birthday', 'Perfect for birthday celebrations', null, '#FF6B6B'),
('Anniversary', 'Romantic anniversary celebrations', null, '#FF8E8E'),
('Date Night', 'Special moments for couples', null, '#FFB5B5'),
('Family Time', 'Quality time with loved ones', null, '#A8E6CF'),
('Friends Gathering', 'Fun times with friends', null, '#88D8C0'),
('Corporate Event', 'Business meetings and events', null, '#4ECDC4')
ON CONFLICT DO NOTHING;