-- Create RPC function to calculate advance payment for orders
CREATE OR REPLACE FUNCTION calculate_advance_payment(
    p_vendor_id UUID,
    p_service_discounted_price DECIMAL,
    p_addons_discounted_price DECIMAL DEFAULT 0
)
RETURNS JSON
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    v_vendor_has_gst BOOLEAN := FALSE;
    v_service_with_taxes DECIMAL;
    v_addons_with_taxes DECIMAL;
    v_commission DECIMAL;
    v_total_commission DECIMAL;
    v_total_vendor_payout DECIMAL;
    v_user_advance_payment DECIMAL;
    v_result JSON;
BEGIN
    -- Check if vendor has GST registration
    SELECT (gst_number IS NOT NULL AND gst_number != '') 
    INTO v_vendor_has_gst
    FROM vendor_private_details 
    WHERE vendor_id = p_vendor_id;
    
    -- If no record found, assume no GST
    IF v_vendor_has_gst IS NULL THEN
        v_vendor_has_gst := FALSE;
    END IF;
    
    -- Calculate service with all taxes
    -- service with all taxes = service discounted price + 28 rupee + 3.54%
    v_service_with_taxes := p_service_discounted_price + 28.00 + (p_service_discounted_price * 0.0354);
    
    -- Calculate add-ons with all taxes  
    -- add-ons with all taxes = addons price discounted price + 3.54%
    v_addons_with_taxes := p_addons_discounted_price + (p_addons_discounted_price * 0.0354);
    
    -- Calculate commission
    -- commission = (service discounted price + addons discount price) * 0.05
    v_commission := (p_service_discounted_price + p_addons_discounted_price) * 0.05;
    
    -- Calculate total commission with GST if vendor has GST
    -- total_commission = (commission * 0.18) + commission (if vendor has GST)
    -- total_commission = commission (if vendor doesn't have GST)
    IF v_vendor_has_gst THEN
        v_total_commission := (v_commission * 0.18) + v_commission;
    ELSE
        v_total_commission := v_commission;
    END IF;
    
    -- Calculate total vendor payout
    -- total vendor payout = (service discounted price + addons discount price) - total_commission
    v_total_vendor_payout := (p_service_discounted_price + p_addons_discounted_price) - v_total_commission;
    
    -- Calculate user advance payment
    -- user advance payment = (service with all taxes + add-ons with all taxes) - total vendor payout * 0.40
    v_user_advance_payment := (v_service_with_taxes + v_addons_with_taxes) - (v_total_vendor_payout * 0.40);
    
    -- Build result JSON
    v_result := json_build_object(
        'vendor_has_gst', v_vendor_has_gst,
        'service_with_taxes', ROUND(v_service_with_taxes, 2),
        'addons_with_taxes', ROUND(v_addons_with_taxes, 2),
        'commission', ROUND(v_commission, 2),
        'total_commission', ROUND(v_total_commission, 2),
        'total_vendor_payout', ROUND(v_total_vendor_payout, 2),
        'user_advance_payment', ROUND(v_user_advance_payment, 2),
        'total_user_payment', ROUND(v_service_with_taxes + v_addons_with_taxes, 2),
        'remaining_payment', ROUND((v_service_with_taxes + v_addons_with_taxes) - v_user_advance_payment, 2)
    );
    
    RETURN v_result;
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION calculate_advance_payment(UUID, DECIMAL, DECIMAL) TO authenticated;

-- Example usage:
-- SELECT calculate_advance_payment('vendor-uuid-here', 1000.00, 200.00);