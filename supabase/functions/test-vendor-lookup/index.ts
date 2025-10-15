import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    const { vendor_id } = await req.json()
    console.log('Testing vendor lookup for ID:', vendor_id)

    // Test vendor query
    const { data: vendorProfile, error: vendorError } = await supabaseClient
      .from('vendors')
      .select('fcm_token, full_name')
      .eq('id', vendor_id)
      .single()

    console.log('Vendor query result:', { vendorProfile, vendorError })

    return new Response(
      JSON.stringify({ 
        success: true,
        vendor_profile: vendorProfile,
        vendor_error: vendorError,
        vendor_name: vendorProfile?.full_name || 'Unknown'
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    console.error('Error:', error)
    return new Response(
      JSON.stringify({ 
        success: false, 
        error: error.message 
      }),
      { 
        status: 500,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' } 
      }
    )
  }
})