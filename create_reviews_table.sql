-- Create reviews table that matches ReviewModel structure
CREATE TABLE IF NOT EXISTS reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    service_id UUID NOT NULL REFERENCES service_listings(id) ON DELETE CASCADE,
    user_name TEXT NOT NULL,
    user_avatar TEXT,
    rating DECIMAL(2,1) NOT NULL CHECK (rating >= 1.0 AND rating <= 5.0),
    comment TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now())
);

-- Create updated_at trigger function if it doesn't exist
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create updated_at trigger for reviews
CREATE TRIGGER update_reviews_updated_at
    BEFORE UPDATE ON reviews
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_reviews_service_id ON reviews(service_id);
CREATE INDEX IF NOT EXISTS idx_reviews_user_id ON reviews(user_id);
CREATE INDEX IF NOT EXISTS idx_reviews_rating ON reviews(rating);
CREATE INDEX IF NOT EXISTS idx_reviews_created_at ON reviews(created_at DESC);

-- Enable RLS
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

-- RLS Policies for reviews
CREATE POLICY "Anyone can view reviews"
    ON reviews FOR SELECT
    TO PUBLIC
    USING (true);

CREATE POLICY "Authenticated users can insert their own reviews"
    ON reviews FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own reviews"
    ON reviews FOR UPDATE
    TO authenticated
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own reviews"
    ON reviews FOR DELETE
    TO authenticated
    USING (auth.uid() = user_id);

-- Function to update service ratings after review changes
CREATE OR REPLACE FUNCTION update_service_rating()
RETURNS TRIGGER AS $$
BEGIN
    -- Update the service_listings table with new rating and count
    UPDATE service_listings 
    SET 
        rating = (
            SELECT ROUND(AVG(rating), 1) 
            FROM reviews 
            WHERE service_id = COALESCE(NEW.service_id, OLD.service_id)
        ),
        reviews_count = (
            SELECT COUNT(*) 
            FROM reviews 
            WHERE service_id = COALESCE(NEW.service_id, OLD.service_id)
        ),
        updated_at = NOW()
    WHERE id = COALESCE(NEW.service_id, OLD.service_id);
    
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Create triggers to update service ratings automatically
CREATE TRIGGER update_service_rating_on_insert
    AFTER INSERT ON reviews
    FOR EACH ROW EXECUTE FUNCTION update_service_rating();

CREATE TRIGGER update_service_rating_on_update
    AFTER UPDATE ON reviews
    FOR EACH ROW EXECUTE FUNCTION update_service_rating();

CREATE TRIGGER update_service_rating_on_delete
    AFTER DELETE ON reviews
    FOR EACH ROW EXECUTE FUNCTION update_service_rating();

-- Insert sample reviews for testing (replace UUIDs with actual ones from your database)
-- First, let's get a sample service_id and user_id
INSERT INTO reviews (user_id, service_id, user_name, rating, comment, user_avatar)
SELECT 
    u.id as user_id,
    s.id as service_id,
    COALESCE(up.full_name, 'Sample User') as user_name,
    5.0 as rating,
    'Absolutely wonderful service! The decoration was exactly what I envisioned for my daughter''s birthday party. The team was professional and completed everything on time. Highly recommended!' as comment,
    up.avatar_url as user_avatar
FROM auth.users u
CROSS JOIN service_listings s
LEFT JOIN user_profiles up ON u.id = up.user_id
WHERE u.email IS NOT NULL 
AND s.is_active = true
LIMIT 1
ON CONFLICT DO NOTHING;

INSERT INTO reviews (user_id, service_id, user_name, rating, comment)
SELECT 
    u.id as user_id,
    s.id as service_id,
    'Priya Sharma' as user_name,
    4.5 as rating,
    'Great experience overall. The decorations were beautiful and the setup was done efficiently. Only minor issue was a slight delay in starting, but the end result was fantastic.' as comment
FROM auth.users u
CROSS JOIN service_listings s
WHERE u.email IS NOT NULL 
AND s.is_active = true
LIMIT 1
ON CONFLICT DO NOTHING;

INSERT INTO reviews (user_id, service_id, user_name, rating, comment)
SELECT 
    u.id as user_id,
    s.id as service_id,
    'Anita Patel' as user_name,
    5.0 as rating,
    'Exceeded my expectations! The attention to detail was remarkable. The floral arrangements were fresh and beautifully arranged. Will definitely book again for future events.' as comment
FROM auth.users u
CROSS JOIN service_listings s
WHERE u.email IS NOT NULL 
AND s.is_active = true
LIMIT 1
ON CONFLICT DO NOTHING;

INSERT INTO reviews (user_id, service_id, user_name, rating, comment)
SELECT 
    u.id as user_id,
    s.id as service_id,
    'Mohammed Ali' as user_name,
    4.0 as rating,
    'Good service and reasonable pricing. The team was courteous and worked within our budget. The decoration looked elegant and matched our theme perfectly.' as comment
FROM auth.users u
CROSS JOIN service_listings s
WHERE u.email IS NOT NULL 
AND s.is_active = true
LIMIT 1
ON CONFLICT DO NOTHING;

INSERT INTO reviews (user_id, service_id, user_name, rating, comment)
SELECT 
    u.id as user_id,
    s.id as service_id,
    'Sneha Gupta' as user_name,
    5.0 as rating,
    'Amazing work! They transformed our venue completely. The lighting, flowers, and overall ambiance were perfect for our anniversary celebration. Thank you for making our day special!' as comment
FROM auth.users u
CROSS JOIN service_listings s
WHERE u.email IS NOT NULL 
AND s.is_active = true
LIMIT 1
ON CONFLICT DO NOTHING;