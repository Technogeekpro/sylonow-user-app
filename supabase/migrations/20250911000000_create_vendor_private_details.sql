-- Create vendor_private_details table for sensitive vendor information
CREATE TABLE IF NOT EXISTS public.vendor_private_details (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    vendor_id UUID NOT NULL REFERENCES vendors(id) ON DELETE CASCADE,
    gst_number TEXT NULL, -- GST registration number, null if not registered
    pan_number TEXT NULL, -- PAN card number
    bank_account_number TEXT NULL, -- Bank account number
    ifsc_code TEXT NULL, -- Bank IFSC code
    bank_name TEXT NULL, -- Bank name
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    
    -- Ensure one record per vendor
    UNIQUE(vendor_id)
);

-- Create index for better performance
CREATE INDEX IF NOT EXISTS idx_vendor_private_details_vendor_id ON public.vendor_private_details(vendor_id);
CREATE INDEX IF NOT EXISTS idx_vendor_private_details_gst_number ON public.vendor_private_details(gst_number) WHERE gst_number IS NOT NULL;

-- Enable Row Level Security (RLS)
ALTER TABLE public.vendor_private_details ENABLE ROW LEVEL SECURITY;

-- RLS Policy: Vendors can only access their own private details
CREATE POLICY "Vendors can access their own private details" ON public.vendor_private_details
    FOR ALL
    USING (
        vendor_id IN (
            SELECT id FROM public.vendors 
            WHERE user_id = auth.uid()
        )
    );

-- RLS Policy: Service role can access all records (for order processing)
CREATE POLICY "Service role can access all vendor private details" ON public.vendor_private_details
    FOR SELECT
    USING (auth.role() = 'service_role');

-- Create updated_at trigger
DROP TRIGGER IF EXISTS update_vendor_private_details_updated_at ON public.vendor_private_details;
CREATE TRIGGER update_vendor_private_details_updated_at
    BEFORE UPDATE ON public.vendor_private_details
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

-- Insert some sample data for testing (optional)
-- Note: In production, this data should be entered by vendors through their dashboard
INSERT INTO public.vendor_private_details (vendor_id, gst_number, pan_number)
SELECT 
    v.id as vendor_id,
    CASE 
        WHEN v.business_name LIKE '%Premium%' OR v.business_name LIKE '%Luxury%' THEN '27AAACC1234567890' -- Sample GST for premium vendors
        WHEN v.business_name LIKE '%All Day%' THEN '19BBBDD5678901234' -- Sample GST for some vendors
        ELSE NULL -- No GST for other vendors
    END as gst_number,
    CASE 
        WHEN v.business_name LIKE '%Premium%' OR v.business_name LIKE '%Luxury%' THEN 'AAACC1234A'
        WHEN v.business_name LIKE '%All Day%' THEN 'BBBDD5678B'
        ELSE NULL
    END as pan_number
FROM public.vendors v
ON CONFLICT (vendor_id) DO NOTHING;