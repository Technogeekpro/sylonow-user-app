-- Create RPC functions for price calculations
-- Function 1: Calculate price WITH convenience fee (for home screen listings)
CREATE OR REPLACE FUNCTION calculate_service_listing_price(
    p_service_price DECIMAL
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_transaction_fee_rate DECIMAL := 0.0354; -- 3.54%
    v_convenience_fee DECIMAL := 28.00; -- ₹28 convenience fee
    v_transaction_fee DECIMAL;
    v_total_amount DECIMAL;
    v_result JSON;
BEGIN
    -- Calculate transaction fee (3.54% of service price)
    v_transaction_fee := p_service_price * v_transaction_fee_rate;
    
    -- Calculate total: base price + convenience fee + transaction fee
    v_total_amount := p_service_price + v_convenience_fee + v_transaction_fee;
    
    -- Build result JSON
    v_result := json_build_object(
        'service_price', ROUND(p_service_price, 2),
        'convenience_fee', ROUND(v_convenience_fee, 2),
        'transaction_fee', ROUND(v_transaction_fee, 2),
        'total_amount', ROUND(v_total_amount, 2)
    );
    
    RETURN v_result;
END;
$$;

-- Function 2: Calculate price WITHOUT convenience fee (for service detail screen and add-ons)
CREATE OR REPLACE FUNCTION calculate_service_detail_price(
    p_service_price DECIMAL,
    p_vendor_has_gst BOOLEAN DEFAULT FALSE
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_transaction_fee_rate DECIMAL := 0.0354; -- 3.54%
    v_gst_rate DECIMAL := 0.18; -- 18% GST
    v_transaction_fee DECIMAL;
    v_gst_amount DECIMAL;
    v_total_amount DECIMAL;
    v_result JSON;
BEGIN
    -- Calculate transaction fee (3.54% of service price)
    v_transaction_fee := p_service_price * v_transaction_fee_rate;
    
    -- Calculate GST if vendor has GST registration
    v_gst_amount := CASE WHEN p_vendor_has_gst THEN p_service_price * v_gst_rate ELSE 0.0 END;
    
    -- Calculate total: base price + transaction fee + GST (if applicable)
    v_total_amount := p_service_price + v_transaction_fee + v_gst_amount;
    
    -- Build result JSON
    v_result := json_build_object(
        'service_price', ROUND(p_service_price, 2),
        'transaction_fee', ROUND(v_transaction_fee, 2),
        'gst_amount', ROUND(v_gst_amount, 2),
        'total_amount', ROUND(v_total_amount, 2),
        'vendor_has_gst', p_vendor_has_gst
    );
    
    RETURN v_result;
END;
$$;

-- Grant execute permissions to authenticated users
GRANT EXECUTE ON FUNCTION calculate_service_listing_price(DECIMAL) TO authenticated;
GRANT EXECUTE ON FUNCTION calculate_service_detail_price(DECIMAL, BOOLEAN) TO authenticated;

-- Example usage:
-- For home screen (with convenience fee): SELECT calculate_service_listing_price(4500.00);
-- For service detail (without convenience fee): SELECT calculate_service_detail_price(4500.00, true);