param (
    [string]$searchString,
    [switch]$clientOnly,
    [switch]$expired
)

# Function to check if a certificate has Client Authentication extended key usage
function HasClientAuthenticationExtendedKeyUsage($cert) {
    $extendedKeyUsageList = $cert.Extensions | Where-Object { $_.Oid.FriendlyName -eq "Enhanced Key Usage" }

    if ($extendedKeyUsageList) {
        $usage = $extendedKeyUsageList.Format(0)
        return $usage -like "*Client Authentication*"
    }

    return $false
}

# Function to display certificate information
function Show-CertificateInfo($cert, $storeLocation) {
    Write-Host "Trust Store: $storeLocation"
    Write-Host "Subject: $($cert.Subject)"
    Write-Host "Issuer: $($cert.Issuer)"
    Write-Host "Thumbprint: $($cert.Thumbprint)"
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
        # If a search string is provided and (the subject or issuer contains the search string or the clientOnly switch is specified and the certificate has Client Authentication extended key usage)
        # Also, check if the certificate is currently valid or the -expired switch is specified
        if (
            (-not $searchString -or $cert.Subject -like "*$searchString*" -or $cert.Issuer -like "*$searchString*") -and
            (-not $clientOnly -or (HasClientAuthenticationExtendedKeyUsage $cert)) -and
            ($expired.IsPresent -or ($cert.NotBefore -le (Get-Date) -and $cert.NotAfter -ge (Get-Date)))
        ) {
            Show-CertificateInfo -cert $cert -storeLocation $storeLocation
        }
    }
}
