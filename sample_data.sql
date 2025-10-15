-- Sample data for private theater booking flow
-- Execute this after creating the main tables

-- Sample decorations data (you'll need to replace theater_id with actual UUIDs from your service_listings)
-- INSERT INTO public.decorations (theater_id, name, description, price, image_url) VALUES
-- ('your-theater-uuid-here', 'Romantic Rose Petals', 'Beautiful red rose petals scattered around the theater', 150.00, 'https://example.com/rose-petals.jpg'),
-- ('your-theater-uuid-here', 'Birthday Balloons', 'Colorful birthday balloons arrangement', 75.00, 'https://example.com/balloons.jpg'),
-- ('your-theater-uuid-here', 'LED String Lights', 'Warm white LED lights for ambient lighting', 100.00, 'https://example.com/led-lights.jpg'),
-- ('your-theater-uuid-here', 'Photo Booth Props', 'Fun photo booth props for memorable pictures', 50.00, 'https://example.com/photo-props.jpg');

-- Sample add-ons data (you'll need to replace theater_id with actual UUIDs from your service_listings)
-- INSERT INTO public.add_ons (theater_id, name, description, price, category, image_url) VALUES
-- -- Extra Special
-- ('your-theater-uuid-here', 'Personal Chef Service', 'Professional chef to prepare meals during your stay', 500.00, 'extra_special', 'https://example.com/chef.jpg'),
-- ('your-theater-uuid-here', 'Professional Photography', '2-hour professional photography session', 300.00, 'extra_special', 'https://example.com/photography.jpg'),
-- 
-- -- Gifts
-- ('your-theater-uuid-here', 'Luxury Chocolate Box', 'Premium assorted chocolates', 80.00, 'gifts', 'https://example.com/chocolates.jpg'),
-- ('your-theater-uuid-here', 'Flower Bouquet', 'Fresh flower arrangement', 120.00, 'gifts', 'https://example.com/flowers.jpg'),
-- ('your-theater-uuid-here', 'Wine Bottle', 'Premium wine selection', 200.00, 'gifts', 'https://example.com/wine.jpg'),
-- 
-- -- Special Services
-- ('your-theater-uuid-here', 'Room Decoration Service', 'Professional room decoration setup', 250.00, 'special_services', 'https://example.com/decoration.jpg'),
-- ('your-theater-uuid-here', 'Sound System Upgrade', 'Premium surround sound system', 180.00, 'special_services', 'https://example.com/sound.jpg'),
-- 
-- -- Cakes
-- ('your-theater-uuid-here', 'Custom Birthday Cake', 'Personalized birthday cake (2kg)', 150.00, 'cakes', 'https://example.com/birthday-cake.jpg'),
-- ('your-theater-uuid-here', 'Anniversary Cake', 'Romantic anniversary cake (1.5kg)', 130.00, 'cakes', 'https://example.com/anniversary-cake.jpg'),
-- ('your-theater-uuid-here', 'Chocolate Truffle Cake', 'Rich chocolate truffle cake (1kg)', 100.00, 'cakes', 'https://example.com/chocolate-cake.jpg');

-- Check if tables were created successfully
SELECT table_name, column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
AND table_name IN ('decorations', 'occasions', 'add_ons')
ORDER BY table_name, ordinal_position;