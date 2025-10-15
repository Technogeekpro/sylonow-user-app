import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3';

interface OrderNotificationPayload {
  order_id: string;
  customer_name: string;
  service_title: string;
  total_amount: number;
  vendor_id?: string;
}

/** ---- Load Firebase service account from secret ---- */
const getServiceAccount = () => {
  try {
    return JSON.parse(Deno.env.get("FIREBASE_SERVICE_ACCOUNT") ?? "{}");
  } catch {
    return {};
  }
};

/** ---- Get OAuth2 access token ---- */
async function getAccessToken() {
  const sa = getServiceAccount();
  if (!sa.client_email || !sa.private_key || !sa.project_id) {
    throw new Error('Firebase service account credentials not properly configured');
  }

  const now = Math.floor(Date.now() / 1000);
  const header = {
    alg: "RS256",
    typ: "JWT"
  };
  const payload = {
    iss: sa.client_email,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600
  };
  
  const enc = (o: any) => btoa(String.fromCharCode(...new TextEncoder().encode(JSON.stringify(o))))
    .replace(/=/g, "").replace(/\+/g, "-").replace(/\//g, "_");
  const toSign = `${enc(header)}.${enc(payload)}`;
  
  const key = await crypto.subtle.importKey("pkcs8", (() => {
    const pem = sa.private_key.replace("-----BEGIN PRIVATE KEY-----", "").replace("-----END PRIVATE KEY-----", "").replace(/\n/g, "");
    const raw = atob(pem);
    const buf = new Uint8Array(raw.length);
    for (let i = 0; i < raw.length; i++) buf[i] = raw.charCodeAt(i);
    return buf.buffer;
  })(), {
    name: "RSASSA-PKCS1-v1_5",
    hash: "SHA-256"
  }, false, ["sign"]);
  
  const sigBuf = await crypto.subtle.sign("RSASSA-PKCS1-v1_5", key, new TextEncoder().encode(toSign));
  const signature = btoa(String.fromCharCode(...new Uint8Array(sigBuf)))
    .replace(/=/g, "").replace(/\+/g, "-").replace(/\//g, "_");
  const jwt = `${toSign}.${signature}`;
  
  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt
    })
  });
  
  const data = await res.json();
  if (!res.ok) throw new Error(`Token error: ${JSON.stringify(data)}`);
  return data.access_token;
}

/** ---- Send FCM with OAuth2 ---- */
async function sendFcmV1(token: string, title: string, body: string, data: Record<string, string>) {
  const sa = getServiceAccount();
  if (!sa.project_id) {
    throw new Error('Firebase project ID not configured');
  }

  const accessToken = await getAccessToken();
  const url = `https://fcm.googleapis.com/v1/projects/${sa.project_id}/messages:send`;
  
  const fcmBody = {
    message: {
      token,
      notification: {
        title,
        body
      },
      data,
      android: {
        priority: "HIGH",
        notification: {
          icon: 'ic_notification',
          color: '#FF0080',
          channel_id: 'order_notifications'
        }
      },
      apns: {
        payload: {
          aps: {
            sound: "default"
          }
        }
      }
    }
  };
  
  const r = await fetch(url, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${accessToken}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify(fcmBody)
  });
  
  const json = await r.json();
  if (!r.ok) throw new Error(`FCM error: ${JSON.stringify(json)}`);
  return json;
}

Deno.serve(async (req: Request) => {
  console.log('🚀 [EDGE FUNCTION] notify-vendor-order invoked');
  console.log('📊 [EDGE FUNCTION] Request method:', req.method);
  console.log('📊 [EDGE FUNCTION] Request headers:', Object.fromEntries(req.headers.entries()));
  
  try {
    // For database triggers, Supabase automatically handles authentication
    // No need to manually check authorization headers
    
    // Handle CORS preflight requests
    if (req.method === 'OPTIONS') {
      return new Response(null, {
        status: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'POST, OPTIONS',
          'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
        }
      });
    }
    
    // Check request method
    if (req.method !== 'POST') {
      console.log('❌ [EDGE FUNCTION] Invalid method:', req.method);
      return new Response(
        JSON.stringify({ error: 'Method not allowed' }),
        { 
          status: 405, 
          headers: { 
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
          } 
        }
      );
    }

    // Parse request body
    console.log('📥 [EDGE FUNCTION] Parsing request body...');
    let payload: OrderNotificationPayload;
    try {
      const body = await req.text();
      console.log('📥 [EDGE FUNCTION] Raw body:', body);
      
      if (!body || body.trim() === '') {
        console.log('❌ [EDGE FUNCTION] Empty request body');
        return new Response(
          JSON.stringify({ error: 'Empty request body' }),
          { 
            status: 400, 
            headers: { 
              'Content-Type': 'application/json',
              'Access-Control-Allow-Origin': '*'
            } 
          }
        );
      }
      
      payload = JSON.parse(body);
      console.log('📥 [EDGE FUNCTION] Parsed payload:', JSON.stringify(payload, null, 2));
    } catch (parseError) {
      console.log('❌ [EDGE FUNCTION] JSON parse error:', parseError);
      return new Response(
        JSON.stringify({ error: 'Invalid JSON payload' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Validate required fields (allow empty strings for customer_name)
    console.log('✅ [EDGE FUNCTION] Validating payload fields...');
    const requiredFields = ['order_id', 'service_title', 'total_amount'];
    const missingFields = requiredFields.filter(field => {
      const value = payload[field as keyof OrderNotificationPayload];
      return value === null || value === undefined;
    });
    
    // Check customer_name exists (can be empty string)
    if (payload.customer_name === null || payload.customer_name === undefined) {
      missingFields.push('customer_name');
    }
    
    if (missingFields.length > 0) {
      console.log('❌ [EDGE FUNCTION] Missing required fields:', missingFields);
      return new Response(
        JSON.stringify({ error: `Missing required fields: ${missingFields.join(', ')}` }),
        { 
          status: 400, 
          headers: { 
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
          } 
        }
      );
    }

    // REMOVED: Manual authorization header check - Supabase handles this automatically for service_role
    console.log('✅ [EDGE FUNCTION] Authentication handled by Supabase runtime');

    // Initialize Supabase client using environment variables (automatically available)
    console.log('🔧 [EDGE FUNCTION] Initializing Supabase client...');
    const supabaseUrl = Deno.env.get('SUPABASE_URL');
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY');
    
    console.log('🔧 [EDGE FUNCTION] Supabase URL present:', !!supabaseUrl);
    console.log('🔧 [EDGE FUNCTION] Service key present:', !!supabaseServiceKey);
    
    if (!supabaseUrl || !supabaseServiceKey) {
      console.log('❌ [EDGE FUNCTION] Missing Supabase environment variables');
      return new Response(
        JSON.stringify({ error: 'Missing Supabase configuration' }),
        { status: 500, headers: { 'Content-Type': 'application/json' } }
      );
    }
    
    const supabase = createClient(supabaseUrl, supabaseServiceKey);
    console.log('✅ [EDGE FUNCTION] Supabase client created successfully');

    // If vendor_id is not provided, try to look it up from the order
    let vendorId = payload.vendor_id;
    if (!vendorId) {
      console.log('🔍 [EDGE FUNCTION] vendor_id not provided, looking up from order...');
      try {
        const { data: orderData, error: orderError } = await supabase
          .from('orders')
          .select('vendor_id')
          .eq('id', payload.order_id)
          .single();
        
        if (orderError) {
          console.log('❌ [EDGE FUNCTION] Error fetching order:', orderError);
          throw orderError;
        }
        
        vendorId = orderData?.vendor_id;
        console.log('🔍 [EDGE FUNCTION] Found vendor_id from order:', vendorId);
      } catch (lookupError) {
        console.log('❌ [EDGE FUNCTION] Failed to lookup vendor_id:', lookupError);
        return new Response(
          JSON.stringify({ error: 'Failed to lookup vendor information' }),
          { status: 500, headers: { 'Content-Type': 'application/json' } }
        );
      }
    }

    if (!vendorId) {
      console.log('❌ [EDGE FUNCTION] No vendor_id found');
      return new Response(
        JSON.stringify({ error: 'No vendor ID found for this order' }),
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }

    // Get vendor FCM token
    console.log('🔍 [EDGE FUNCTION] Fetching vendor FCM token for vendor:', vendorId);
    try {
      const { data: vendorData, error: vendorError } = await supabase
        .from('vendors')
        .select('fcm_token, business_name')
        .eq('id', vendorId)
        .single();
      
      if (vendorError) {
        console.log('❌ [EDGE FUNCTION] Error fetching vendor:', vendorError);
        throw vendorError;
      }
      
      console.log('✅ [EDGE FUNCTION] Vendor data fetched:', { 
        business_name: vendorData?.business_name, 
        has_fcm_token: !!vendorData?.fcm_token 
      });
      
      if (!vendorData?.fcm_token) {
        console.log('⚠️ [EDGE FUNCTION] No FCM token found for vendor');
        return new Response(
          JSON.stringify({ 
            success: true, 
            message: 'Order notification skipped - vendor has no FCM token registered' 
          }),
          { status: 200, headers: { 'Content-Type': 'application/json' } }
        );
      }

      // Prepare notification content
      console.log('📱 [EDGE FUNCTION] Preparing FCM notification...');
      const customerDisplayName = payload.customer_name?.trim() || 'A customer';
      const notificationTitle = '🛍️ New Order Received!';
      const notificationBody = `${customerDisplayName} booked "${payload.service_title}" for ₹${payload.total_amount}`;
      const notificationData = {
        order_id: payload.order_id,
        customer_name: payload.customer_name || '',
        service_title: payload.service_title,
        total_amount: payload.total_amount.toString(),
        vendor_id: vendorId,
        click_action: 'OPEN_ORDER_DETAILS'
      };

      console.log('📱 [EDGE FUNCTION] FCM notification content prepared');

      // Check Firebase credentials
      console.log('🔑 [EDGE FUNCTION] Checking Firebase service account...');
      const sa = getServiceAccount();
      if (!sa.client_email || !sa.private_key || !sa.project_id) {
        console.log('⚠️ [EDGE FUNCTION] Firebase service account not configured, skipping notification');
        return new Response(
          JSON.stringify({ 
            success: true, 
            message: 'Vendor lookup successful, but Firebase not configured' 
          }),
          { status: 200, headers: { 'Content-Type': 'application/json' } }
        );
      }

      // Send FCM notification using OAuth2
      console.log('📤 [EDGE FUNCTION] Sending FCM notification with OAuth2...');
      const fcmResult = await sendFcmV1(
        vendorData.fcm_token,
        notificationTitle,
        notificationBody,
        notificationData
      );
      
      console.log('✅ [EDGE FUNCTION] FCM notification sent successfully:', fcmResult.name);
      
      return new Response(
        JSON.stringify({
          success: true,
          message: 'Vendor notification sent successfully',
          order_id: payload.order_id,
          vendor_id: vendorId,
          vendor_business: vendorData.business_name,
          fcm_message_id: fcmResult.name
        }),
        { status: 200, headers: { 'Content-Type': 'application/json' } }
      );
      
    } catch (vendorError) {
      console.log('❌ [EDGE FUNCTION] Error in vendor lookup/notification:', vendorError);
      return new Response(
        JSON.stringify({ error: 'Failed to process vendor notification', details: vendorError.message }),
        { status: 500, headers: { 'Content-Type': 'application/json' } }
      );
    }
    
  } catch (error) {
    console.log('💥 [EDGE FUNCTION] Unexpected error:', error);
    return new Response(
      JSON.stringify({ error: 'Internal server error', details: error.message }),
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
});