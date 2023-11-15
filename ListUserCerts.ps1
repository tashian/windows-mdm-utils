param (
    [string]$searchString = $null
)

# Function to display certificate information
function Show-CertificateInfo($cert, $storeLocation) {
    Write-Host "Trust Store: $storeLocation"
    Write-Host "Subject: $($cert.Subject)"
    Write-Host "Issuer: $($cert.Issuer)"
    Write-Host "Thumbprint: $($cert.Thumbprint)"
    Write-Host "Friendly Name: $($cert.FriendlyName)"
    Write-Host "Not Before: $($cert.NotBefore)"
    Write-Host "Not After: $($cert.NotAfter)"
    Write-Host "`n"  # Add a newline for better readability
}

# Get certificates from both CurrentUser and LocalMachine stores
$stores = @("CurrentUser\Root", "CurrentUser\CA", "CurrentUser\My", "LocalMachine\Root", "LocalMachine\CA", "LocalMachine\My")

foreach ($storePath in $stores) {
    $storeLocation = $storePath -replace "(.*?)\\.*", '$1'
    $storeName = $storePath -replace ".*?\\(.*)", '$1'
    
    $certificates = Get-ChildItem -Path "Cert:\$storePath"

    foreach ($cert in $certificates) {
        # If a search string is provided and the subject contains the search string (case-insensitive), display the certificate
        if (-not $searchString -or $cert.Subject -like "*$searchString*") {
            Show-CertificateInfo -cert $cert -storeLocation $storeLocation
        }
    }
}
