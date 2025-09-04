import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'npm:@supabase/supabase-js@2'

interface OrderPayload {
  vendor_id: string
  order_id: string
  customer_name: string
  service_title: string
  total_amount: number
  booking_date: string
  booking_time?: string
  message?: string
}

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
)

/** ---- Load Firebase service account from secret ---- */
const sa = JSON.parse(Deno.env.get("FIREBASE_SERVICE_ACCOUNT") ?? "{}")
const PROJECT_ID = sa.project_id

/** ---- Get OAuth2 access token ---- */
async function getAccessToken() {
  const now = Math.floor(Date.now() / 1000)
  const header = {
    alg: "RS256",
    typ: "JWT"
  }
  const payload = {
    iss: sa.client_email,
    scope: "https://www.googleapis.com/auth/firebase.messaging",
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600
  }
  const enc = (o: any) => btoa(String.fromCharCode(...new TextEncoder().encode(JSON.stringify(o)))).replace(/=/g, "").replace(/\+/g, "-").replace(/\//g, "_")
  const toSign = `${enc(header)}.${enc(payload)}`
  const key = await crypto.subtle.importKey("pkcs8", (() => {
    const pem = sa.private_key.replace("-----BEGIN PRIVATE KEY-----", "").replace("-----END PRIVATE KEY-----", "").replace(/\n/g, "")
    const raw = atob(pem)
    const buf = new Uint8Array(raw.length)
    for (let i = 0; i < raw.length; i++) buf[i] = raw.charCodeAt(i)
    return buf.buffer
  })(), {
    name: "RSASSA-PKCS1-v1_5",
    hash: "SHA-256"
  }, false, [
    "sign"
  ])
  const sigBuf = await crypto.subtle.sign("RSASSA-PKCS1-v1_5", key, new TextEncoder().encode(toSign))
  const signature = btoa(String.fromCharCode(...new Uint8Array(sigBuf))).replace(/=/g, "").replace(/\+/g, "-").replace(/\//g, "_")
  const jwt = `${toSign}.${signature}`
  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt
    })
  })
  const data = await res.json()
  if (!res.ok) throw new Error(`Token error: ${JSON.stringify(data)}`)
  return data.access_token
}

/** ---- Send FCM ---- */
async function sendFcmV1(token: string, title: string, body: string, data: Record<string, string>) {
  const accessToken = await getAccessToken()
  const url = `https://fcm.googleapis.com/v1/projects/${PROJECT_ID}/messages:send`
  const fcmBody = {
    message: {
      token,
      notification: {
        title,
        body
      },
      data,
      android: {
        priority: "HIGH"
      },
      apns: {
        payload: {
          aps: {
            sound: "default"
          }
        }
      }
    }
  }
  const r = await fetch(url, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${accessToken}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify(fcmBody)
  })
  const json = await r.json()
  if (!r.ok) throw new Error(`FCM error: ${JSON.stringify(json)}`)
  return json
}

/** ---- HTTP handler ---- */
serve(async (req) => {
  try {
    const payload: OrderPayload = await req.json()
    
    console.log('📧 Processing vendor notification for order:', payload.order_id);

    // Validate required fields
    if (!payload.vendor_id || !payload.order_id || !payload.customer_name || !payload.service_title) {
      throw new Error('Missing required fields: vendor_id, order_id, customer_name, service_title')
    }
    
    // Get vendor's FCM token from vendors table
    const { data: vendorData } = await supabase
      .from('vendors')
      .select('fcm_token, full_name, business_name')
      .eq('id', payload.vendor_id)
      .single()

    if (!vendorData?.fcm_token) {
      console.log('⚠️ Vendor FCM token not found for vendor:', payload.vendor_id)
      // Still create in-app notification even without FCM token
    }

    const vendorName = vendorData?.full_name || vendorData?.business_name || 'Vendor'
    
    // Create notification message
    const bookingDateFormatted = new Date(payload.booking_date).toLocaleDateString()
    const timeInfo = payload.booking_time ? ` at ${payload.booking_time}` : ''
    
    const notificationTitle = '🛍️ New Service Booking!'
    const notificationBody = `New booking from ${payload.customer_name} for ${payload.service_title} on ${bookingDateFormatted}${timeInfo}. Amount: ₹${payload.total_amount}`

    // Store in-app notification in vendor_notifications table
    const { data: notification, error: dbError } = await supabase
      .from('vendor_notifications')
      .insert({
        vendor_id: payload.vendor_id,
        order_id: payload.order_id,
        title: notificationTitle,
        message: notificationBody,
        type: 'new_order',
        is_read: false
      })
      .select()
      .single()

    if (dbError) {
      console.error('❌ Error inserting notification:', dbError)
      throw new Error(`Failed to create notification: ${dbError.message}`)
    }

    let fcmResult = null
    
    // Send FCM notification if token exists
    if (vendorData?.fcm_token) {
      try {
        fcmResult = await sendFcmV1(vendorData.fcm_token, notificationTitle, notificationBody, {
          vendor_id: payload.vendor_id,
          order_id: payload.order_id,
          service_title: payload.service_title,
          customer_name: payload.customer_name,
          booking_date: payload.booking_date,
          total_amount: payload.total_amount.toString(),
          booking_time: payload.booking_time || '',
          click_action: "FLUTTER_NOTIFICATION_CLICK"
        })
        
        console.log('✅ FCM notification sent successfully:', fcmResult.name)
      } catch (fcmError) {
        console.error('❌ FCM sending failed:', fcmError)
        // Don't throw error here, in-app notification was still created
      }
    }

    return new Response(JSON.stringify({
      success: true,
      message: 'Vendor notification sent successfully',
      vendor_name: vendorName,
      notification_id: notification.id,
      fcm_message_id: fcmResult?.name || null,
      fcm_sent: !!fcmResult
    }), {
      headers: { 'Content-Type': 'application/json' },
    })
    
  } catch (error) {
    console.error('❌ Error in vendor-notification function:', error)
    return new Response(JSON.stringify({
      success: false,
      error: error.message || 'Unknown error occurred'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    })
  }
})