Deno.serve(async (req) => {
  const firebaseProjectId = Deno.env.get('FIREBASE_PROJECT_ID')
  const firebaseClientEmail = Deno.env.get('FIREBASE_CLIENT_EMAIL')
  const firebasePrivateKey = Deno.env.get('FIREBASE_PRIVATE_KEY')
  
  return new Response(JSON.stringify({
    firebase_project_id: firebaseProjectId ? 'SET' : 'NOT_SET',
    firebase_client_email: firebaseClientEmail ? 'SET' : 'NOT_SET',
    firebase_private_key: firebasePrivateKey ? 'SET' : 'NOT_SET',
    supabase_url: Deno.env.get('SUPABASE_URL') ? 'SET' : 'NOT_SET',
    supabase_service_role_key: Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ? 'SET' : 'NOT_SET'
  }), {
    headers: { 'Content-Type': 'application/json' },
  })
})