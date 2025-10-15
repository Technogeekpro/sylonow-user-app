import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'npm:@supabase/supabase-js@2'

serve(async (req) => {
  try {
    // Check environment variables
    const supabaseUrl = Deno.env.get('SUPABASE_URL')
    const serviceRoleKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')
    const firebaseServiceAccount = Deno.env.get('FIREBASE_SERVICE_ACCOUNT')
    
    // Test Supabase connection
    const supabase = createClient(supabaseUrl!, serviceRoleKey!)
    
    // Try to query vendors table
    const { data, error } = await supabase
      .from('vendors')
      .select('id, full_name')
      .limit(1)
    
    return new Response(JSON.stringify({
      success: true,
      environment: {
        supabase_url: supabaseUrl ? 'SET' : 'NOT SET',
        service_role_key: serviceRoleKey ? 'SET' : 'NOT SET',
        firebase_service_account: firebaseServiceAccount ? 'SET' : 'NOT SET'
      },
      supabase_test: {
        data,
        error: error?.message
      }
    }), {
      headers: { 'Content-Type': 'application/json' },
    })
  } catch (error) {
    return new Response(JSON.stringify({
      success: false,
      error: error.message
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    })
  }
})