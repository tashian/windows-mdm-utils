
```
winget install Git.Git
# close terminal and reopen it
git clone https://github.com/tashian/windows-mdm-utils

# open a new PowerShell as an Administrator
Set-ExecutionPolicy RemoteSigned

# return to your user terminal and use the utilities.
.\MDMLog.ps1 SCEP
.\MDMLog.ps1 -errorsOnly WiFi
.\ListCerts.ps1 Intune
.\ListCerts.ps1 -expired MDM
.\ListCerts.ps1 -clientOnly
```
