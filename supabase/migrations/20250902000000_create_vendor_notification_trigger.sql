-- First, create vendor_notifications table if it doesn't exist
CREATE TABLE IF NOT EXISTS vendor_notifications (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  vendor_id UUID REFERENCES vendors(id) ON DELETE CASCADE,
  order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  message TEXT NOT NULL,
  type VARCHAR(50) DEFAULT 'new_order',
  is_read BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_vendor_notifications_vendor_id ON vendor_notifications(vendor_id);
CREATE INDEX IF NOT EXISTS idx_vendor_notifications_created_at ON vendor_notifications(created_at DESC);

-- Create RLS policies for vendor_notifications
ALTER TABLE vendor_notifications ENABLE ROW LEVEL SECURITY;

-- Vendors can only see their own notifications
CREATE POLICY vendor_notifications_select_policy ON vendor_notifications
  FOR SELECT USING (auth.uid()::text = vendor_id::text);

-- Create function to send notification via edge function
CREATE OR REPLACE FUNCTION notify_vendor_new_order()
RETURNS TRIGGER AS $$
DECLARE
  vendor_uuid UUID;
BEGIN
  -- Get the vendor_id from the new order
  vendor_uuid := NEW.vendor_id;
  
  -- Only send notification if vendor_id is not null
  IF vendor_uuid IS NOT NULL THEN
    -- Call the edge function asynchronously using pg_net extension
    -- This requires pg_net extension to be enabled
    PERFORM 
      net.http_post(
        url := 'https://wxhqpjzlkbpvnfbvqkpq.supabase.co/functions/v1/vendor-notification',
        headers := '{"Content-Type": "application/json", "Authorization": "Bearer ' || current_setting('app.service_role_key', true) || '"}'::jsonb,
        body := jsonb_build_object(
          'vendor_id', vendor_uuid,
          'order_id', NEW.id,
          'customer_name', NEW.customer_name,
          'service_title', NEW.service_title,
          'total_amount', NEW.total_amount,
          'booking_date', NEW.booking_date::text
        )
      );
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger that fires after INSERT on orders table
DROP TRIGGER IF EXISTS trigger_notify_vendor_new_order ON orders;
CREATE TRIGGER trigger_notify_vendor_new_order
  AFTER INSERT ON orders
  FOR EACH ROW
  EXECUTE FUNCTION notify_vendor_new_order();