-- Migration: Create RPC function for theater screens with distance calculation
-- Description: Adds location-based filtering and distance calculation for theater screens
-- Date: 2025-09-30

CREATE OR REPLACE FUNCTION get_theater_screens_with_distance(
  user_lat double precision,
  user_lon double precision,
  radius_km double precision
)
RETURNS TABLE (
  id uuid,
  theater_id uuid,
  screen_name character varying,
  screen_number integer,
  capacity integer,
  amenities text[],
  hourly_rate numeric,
  is_active boolean,
  created_at timestamp with time zone,
  updated_at timestamp with time zone,
  total_capacity integer,
  allowed_capacity integer,
  charges_extra_per_person numeric,
  video_url text,
  images text[],
  description text,
  time_slots jsonb,
  what_included text[],
  category_id uuid,
  -- Theater details from private_theaters join
  theater_name character varying,
  theater_latitude numeric,
  theater_longitude numeric,
  theater_address text,
  theater_rating numeric,
  theater_total_reviews integer,
  -- Calculated distance
  distance_km double precision
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    ts.id,
    ts.theater_id,
    ts.screen_name,
    ts.screen_number,
    ts.capacity,
    ts.amenities,
    ts.hourly_rate,
    ts.is_active,
    ts.created_at,
    ts.updated_at,
    ts.total_capacity,
    ts.allowed_capacity,
    ts.charges_extra_per_person,
    ts.video_url,
    ts.images,
    ts.description,
    ts.time_slots,
    ts.what_included,
    ts.category_id,
    -- Theater details
    pt.name as theater_name,
    pt.latitude as theater_latitude,
    pt.longitude as theater_longitude,
    pt.address as theater_address,
    pt.rating as theater_rating,
    pt.total_reviews as theater_total_reviews,
    -- Calculate distance using existing Haversine function
    calculate_distance(user_lat::numeric, user_lon::numeric, pt.latitude, pt.longitude)::double precision AS distance_km
  FROM theater_screens ts
  INNER JOIN private_theaters pt ON ts.theater_id = pt.id
  WHERE ts.is_active = true
    AND pt.is_active = true
    AND pt.approval_status = 'approved'
    AND pt.latitude IS NOT NULL
    AND pt.longitude IS NOT NULL
    AND calculate_distance(user_lat::numeric, user_lon::numeric, pt.latitude, pt.longitude) <= radius_km
  ORDER BY calculate_distance(user_lat::numeric, user_lon::numeric, pt.latitude, pt.longitude) ASC;
END;
$$ LANGUAGE plpgsql;

-- Add comment for documentation
COMMENT ON FUNCTION get_theater_screens_with_distance(double precision, double precision, double precision) IS
'Fetches theater screens within a specified radius from user location, including distance calculation and theater details. Returns screens sorted by distance (nearest first).';
