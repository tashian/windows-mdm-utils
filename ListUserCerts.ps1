# Get all certificates from the CurrentUser\Root store
$certificates = Get-ChildItem -Path Cert:\CurrentUser\Root

# Display certificate information
foreach ($cert in $certificates) {
    Write-Host "Subject: $($cert.Subject)"
    Write-Host "Issuer: $($cert.Issuer)"
    Write-Host "Thumbprint: $($cert.Thumbprint)"
    Write-Host "Friendly Name: $($cert.FriendlyName)"
    Write-Host "Not Before: $($cert.NotBefore)"
    Write-Host "Not After: $($cert.NotAfter)"
    Write-Host "`n"  # Add a newline for better readability
}
