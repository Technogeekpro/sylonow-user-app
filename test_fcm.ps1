$headers = @{
    "Authorization" = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR4Z3N6cnhqeWFuYXpscnVwYXR5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTAyNzU4MjcsImV4cCI6MjA2NTg1MTgyN30.7MDiDGMCEa-E8c3HgIGxSpkOsH9kClD5i5LNSjzFul4"
    "Content-Type" = "application/json"
}

$body = @{
    vendor_id = "f2ce4767-2b62-489c-bd41-c30bb5055eb2"
    theater_name = "Luxury Theater Hall"
    customer_name = "John Doe"
    booking_date = "2024-01-15"
    time_slot = "7:00 PM - 10:00 PM"
    total_amount = 2500
    occasion_name = "Birthday Party"
} | ConvertTo-Json

try {
    $response = Invoke-WebRequest -Uri "https://txgszrxjyanazlrupaty.supabase.co/functions/v1/notify-vendor-booking" -Method POST -Headers $headers -Body $body
    Write-Host "Status Code: $($response.StatusCode)"
    Write-Host "Response: $($response.Content)"
} catch {
    Write-Host "Error: $($_.Exception.Message)"
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "Error Response: $responseBody"
    }
}