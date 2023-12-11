param (
    [switch]$errorsOnly,
    [string]$searchString
)

# Specify the event log and the number of events to retrieve
$logName = "Microsoft-Windows-DeviceManagement-Enterprise-Diagnostics-Provider/Admin"
$numberOfEvents = 50

# Retrieve the most recent 50 events from the specified log
$events = Get-WinEvent -LogName $logName -MaxEvents $numberOfEvents | Sort-Object TimeCreated -Descending
[array]::Reverse($events)

# Display details of each event
foreach ($event in $events) {
    # Check if only errors should be displayed
    # Check if a search string is provided and the message contains the search string
    if ((-not $errorsOnly -or $event.LevelDisplayName -eq "Error") -and (-not $searchString -or $event.Message -like "*$searchString*")) {
        Write-Host "$($event.LevelDisplayName) $($event.TimeCreated) $($event.Id)"

        # Display additional lines for the message
        $messageLines = $event.Message -split "`r`n"
        foreach ($line in $messageLines) {
            Write-Host "  $line"
        }

        Write-Host "`n"  # Add a newline for better readability
    }
}
