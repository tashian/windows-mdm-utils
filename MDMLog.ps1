# Specify the event log and the number of events to retrieve
$logName = "Microsoft-Windows-DeviceManagement-Enterprise-Diagnostics-Provider/Admin"
$numberOfEvents = 50

# Retrieve the most recent 50 events from the specified log
$events = Get-WinEvent -LogName $logName -MaxEvents $numberOfEvents | Sort-Object TimeCreated -Descending

# Display details of each event
foreach ($event in $events) {
    Write-Host "Event ID: $($event.Id) | Time Created: $($event.TimeCreated) | Provider Name: $($event.ProviderName) | Level: $($event.LevelDisplayName)"

    # Display additional lines for the message
    $messageLines = $event.Message -split "`r`n"
    foreach ($line in $messageLines) {
        Write-Host "  $line"
    }

    Write-Host "`n"  # Add a newline for better readability
}
