-- Fix the RPC function with the EXACT formulas from Canvas app
DROP FUNCTION IF EXISTS calculate_advance_payment(UUID, DECIMAL, DECIMAL);

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
    -- Constants from Canvas app formulas
    v_fixed_tax DECIMAL := 28.00; -- F = 28
    v_percent_tax DECIMAL := 3.54; -- p = 3.54%
    v_commission_percent DECIMAL := 5.00; -- c = 5%
    v_commission_gst_percent DECIMAL := 18.00; -- g = 18%
    v_advance_factor DECIMAL := 40.00; -- adv = 40%
    
    -- Variables for calculations (S = service, A = addons)
    v_S DECIMAL := p_service_discounted_price;
    v_A DECIMAL := p_addons_discounted_price;
    
    -- Step-by-step calculations
    v_service_with_all DECIMAL;
    v_addons_with_all DECIMAL;
    v_commission DECIMAL;
    v_total_commission DECIMAL;
    v_total_vendor_payout DECIMAL;
    v_total_price_user_sees DECIMAL;
    v_user_advance_payment DECIMAL;
    
    v_result JSON;
BEGIN
    -- Step 1: Service with all taxes
    -- service_with_all = S + F + S * (p/100)
    v_service_with_all := v_S + v_fixed_tax + v_S * (v_percent_tax / 100);
    
    -- Step 2: Add-ons with all taxes  
    -- addons_with_all = A + A * (p/100)
    v_addons_with_all := v_A + v_A * (v_percent_tax / 100);
    
    -- Step 3: Commission
    -- commission = (S + A) * (c/100)
    v_commission := (v_S + v_A) * (v_commission_percent / 100);
    
    -- Step 4: Total commission (commission + GST on commission)
    -- total_commission = commission * (1 + g/100)
    v_total_commission := v_commission * (1 + v_commission_gst_percent / 100);
    
    -- Step 5: Total vendor payout
    -- total_vendor_payout = (S + A) - total_commission
    v_total_vendor_payout := (v_S + v_A) - v_total_commission;
    
    -- Step 6: Total price user sees
    -- total_price_user_sees = service_with_all + addons_with_all
    v_total_price_user_sees := v_service_with_all + v_addons_with_all;
    
    -- Step 7: User advance payment
    -- user_advance_payment = total_price_user_sees - total_vendor_payout * (adv/100)
    v_user_advance_payment := v_total_price_user_sees - v_total_vendor_payout * (v_advance_factor / 100);
    
    -- Build result JSON
    v_result := json_build_object(
        'service_with_all_taxes', ROUND(v_service_with_all, 2),
        'addons_with_all_taxes', ROUND(v_addons_with_all, 2),
        'commission', ROUND(v_commission, 2),
        'total_commission', ROUND(v_total_commission, 2),
        'total_vendor_payout', ROUND(v_total_vendor_payout, 2),
        'total_price_user_sees', ROUND(v_total_price_user_sees, 2),
        'user_advance_payment', ROUND(v_user_advance_payment, 2),
        'remaining_payment', ROUND(v_total_price_user_sees - v_user_advance_payment, 2)
    );
    
    RETURN v_result;
END;
$$;

-- Grant execute permission to authenticated users
GRANT EXECUTE ON FUNCTION calculate_advance_payment(UUID, DECIMAL, DECIMAL) TO authenticated;

-- Test with the example from Canvas: S=1000, A=200 should give user_advance_payment=818.80
-- SELECT calculate_advance_payment('00000000-0000-0000-0000-000000000000', 1000.00, 200.00);