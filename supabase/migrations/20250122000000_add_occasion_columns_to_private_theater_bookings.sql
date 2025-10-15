-- Add occasion columns to private_theater_bookings table
ALTER TABLE public.private_theater_bookings 
ADD COLUMN occasion_id uuid NULL,
ADD COLUMN occasion_name character varying(255) NULL;

-- Add foreign key constraint to occasions table if it exists
-- ALTER TABLE public.private_theater_bookings 
-- ADD CONSTRAINT fk_private_theater_bookings_occasion 
-- FOREIGN KEY (occasion_id) REFERENCES occasions (id) ON DELETE SET NULL;

-- Add index for better query performance
CREATE INDEX IF NOT EXISTS idx_private_theater_bookings_occasion_id 
ON public.private_theater_bookings USING btree (occasion_id);

-- Add comment for documentation
COMMENT ON COLUMN public.private_theater_bookings.occasion_id IS 'Reference to the occasion selected for this booking';
COMMENT ON COLUMN public.private_theater_bookings.occasion_name IS 'Name of the occasion for this booking';