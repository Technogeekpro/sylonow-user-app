import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'npm:@supabase/supabase-js@2'

interface BookingPayload {
  vendor_id: string
  theater_id?: string
  theater_name: string
  customer_name: string
  booking_date: string
  time_slot: string
  total_amount: number
  occasion_name?: string
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
    const payload: BookingPayload = await req.json()
    
    // Get vendor's FCM token from vendors table
    // First try to find vendor directly by vendor_id
    let { data } = await supabase
      .from('vendors')
      .select('fcm_token, full_name, business_name')
      .eq('id', payload.vendor_id)
      .single()

    // If vendor not found by vendor_id, try to find by theater owner_id
    if (!data) {
      // Get theater details first
      const { data: theaterData } = await supabase
        .from('private_theaters')
        .select('owner_id')
        .eq('id', payload.theater_id || '')
        .single()
      
      if (theaterData?.owner_id) {
        // Try to find vendor by theater owner_id
        const { data: vendorByOwner } = await supabase
          .from('vendors')
          .select('fcm_token, full_name, business_name')
          .eq('id', theaterData.owner_id)
          .single()
        
        data = vendorByOwner
      }
    }

    if (!data?.fcm_token) {
      throw new Error('Vendor FCM token not found')
    }

    const fcmToken = data.fcm_token as string
    const vendorName = data.full_name || data.business_name || 'Vendor'

    // Prepare notification message
    const notificationTitle = '🎬 New Theater Booking!'
    const notificationBody = `New booking from ${payload.customer_name} for ${payload.theater_name} on ${payload.booking_date} at ${payload.time_slot}. Amount: ₹${payload.total_amount}${payload.occasion_name ? ` (${payload.occasion_name})` : ''}`

    // Send FCM notification
    const result = await sendFcmV1(fcmToken, notificationTitle, notificationBody, {
      vendor_id: payload.vendor_id,
      theater_name: payload.theater_name,
      customer_name: payload.customer_name,
      booking_date: payload.booking_date,
      time_slot: payload.time_slot,
      total_amount: payload.total_amount.toString(),
      occasion_name: payload.occasion_name || '',
      click_action: "FLUTTER_NOTIFICATION_CLICK"
    })

    return new Response(JSON.stringify({
      success: true,
      message: 'Notification sent successfully',
      vendor_name: vendorName,
      fcm_message_id: result.name
    }), {
      headers: { 'Content-Type': 'application/json' },
    })
  } catch (error) {
    console.error('FCM Error:', error)
    return new Response(JSON.stringify({
      success: false,
      error: error.message || 'Unknown error occurred'
    }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    })
  }
})