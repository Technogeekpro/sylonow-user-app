-- Create decorations table
CREATE TABLE decorations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    theater_id UUID REFERENCES theaters(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC NOT NULL,
    image_url TEXT,
    is_available BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Create occasions table
CREATE TABLE occasions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT,
    icon_url TEXT,
    color_code TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Create add_ons table
CREATE TABLE add_ons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    theater_id UUID REFERENCES theaters(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC NOT NULL,
    category TEXT NOT NULL CHECK (category IN ('extra_special', 'gifts', 'special_services', 'cakes')),
    image_url TEXT,
    is_available BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Create theater_bookings table
CREATE TABLE theater_bookings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    theater_id UUID REFERENCES theaters(id) ON DELETE CASCADE,
    selected_date DATE NOT NULL,
    selected_time_slot TEXT NOT NULL,
    decoration_id UUID REFERENCES decorations(id) ON DELETE SET NULL,
    occasion_id UUID REFERENCES occasions(id) ON DELETE SET NULL,
    total_price NUMERIC DEFAULT 0,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled')),
    created_at TIMESTAMPTZ DEFAULT now(),
    updated_at TIMESTAMPTZ DEFAULT now()
);

-- Create theater_booking_add_ons junction table
CREATE TABLE theater_booking_add_ons (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID REFERENCES theater_bookings(id) ON DELETE CASCADE,
    add_on_id UUID REFERENCES add_ons(id) ON DELETE CASCADE,
    quantity INTEGER DEFAULT 1 CHECK (quantity > 0),
    created_at TIMESTAMPTZ DEFAULT now()
);

-- Create function to update updated_at column
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at columns
CREATE TRIGGER update_decorations_updated_at 
    BEFORE UPDATE ON decorations
    FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_add_ons_updated_at 
    BEFORE UPDATE ON add_ons
    FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

CREATE TRIGGER update_theater_bookings_updated_at 
    BEFORE UPDATE ON theater_bookings
    FOR EACH ROW EXECUTE PROCEDURE update_updated_at_column();

-- Create indexes for performance optimization
CREATE INDEX idx_decorations_theater_id ON decorations(theater_id);
CREATE INDEX idx_decorations_is_available ON decorations(is_available);

CREATE INDEX idx_add_ons_theater_id ON add_ons(theater_id);
CREATE INDEX idx_add_ons_category ON add_ons(category);
CREATE INDEX idx_add_ons_is_available ON add_ons(is_available);

CREATE INDEX idx_theater_bookings_user_id ON theater_bookings(user_id);
CREATE INDEX idx_theater_bookings_theater_id ON theater_bookings(theater_id);
CREATE INDEX idx_theater_bookings_selected_date ON theater_bookings(selected_date);
CREATE INDEX idx_theater_bookings_status ON theater_bookings(status);

CREATE INDEX idx_theater_booking_add_ons_booking_id ON theater_booking_add_ons(booking_id);
CREATE INDEX idx_theater_booking_add_ons_add_on_id ON theater_booking_add_ons(add_on_id);

-- Enable Row Level Security (RLS)
ALTER TABLE decorations ENABLE ROW LEVEL SECURITY;
ALTER TABLE occasions ENABLE ROW LEVEL SECURITY;
ALTER TABLE add_ons ENABLE ROW LEVEL SECURITY;
ALTER TABLE theater_bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE theater_booking_add_ons ENABLE ROW LEVEL SECURITY;

-- RLS Policies for decorations table
CREATE POLICY "Decorations are viewable by everyone" ON decorations
    FOR SELECT USING (true);

CREATE POLICY "Only authenticated users can manage decorations" ON decorations
    FOR ALL USING (auth.role() = 'authenticated');

-- RLS Policies for occasions table
CREATE POLICY "Occasions are viewable by everyone" ON occasions
    FOR SELECT USING (true);

CREATE POLICY "Only authenticated users can manage occasions" ON occasions
    FOR ALL USING (auth.role() = 'authenticated');

-- RLS Policies for add_ons table
CREATE POLICY "Add-ons are viewable by everyone" ON add_ons
    FOR SELECT USING (true);

CREATE POLICY "Only authenticated users can manage add-ons" ON add_ons
    FOR ALL USING (auth.role() = 'authenticated');

-- RLS Policies for theater_bookings table
CREATE POLICY "Users can view their own bookings" ON theater_bookings
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own bookings" ON theater_bookings
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own bookings" ON theater_bookings
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own bookings" ON theater_bookings
    FOR DELETE USING (auth.uid() = user_id);

-- RLS Policies for theater_booking_add_ons table
CREATE POLICY "Users can view add-ons for their own bookings" ON theater_booking_add_ons
    FOR SELECT USING (
        EXISTS (
            SELECT 1 FROM theater_bookings 
            WHERE theater_bookings.id = theater_booking_add_ons.booking_id 
            AND theater_bookings.user_id = auth.uid()
        )
    );

CREATE POLICY "Users can manage add-ons for their own bookings" ON theater_booking_add_ons
    FOR ALL USING (
        EXISTS (
            SELECT 1 FROM theater_bookings 
            WHERE theater_bookings.id = theater_booking_add_ons.booking_id 
            AND theater_bookings.user_id = auth.uid()
        )
    );