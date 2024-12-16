# UNCLASSIFIED
<#
.SYNOPSIS
This script will start Tableau server on Windows.

.DESCRIPTION
This script will start the Windows Tableau server services. Once started it will wait for them to all report running before running the 'tsm start' command.

This script can be ran as a scheduled task to automatically start Tableau on system startup. Set the trigger to 'At startup' and set the 'Delay task for:' value to 5 minutes. This will allow the system to fully boot (drives unlocked, networking up, etc) before attempting to start Tableua. For the action, select 'Start a program'. For the 'Program/script:' value, use 'powershell.exe'. Add the following under 'Add arguments (optional):' '-NoProfile -ExecutionPolicy Bypass -File "C:\Path\to\Start-Tableau.ps1"'

The whole startup process took ~15min from the time the tested system came up after a reboot.

.NOTES
Name        : Start-Tableau.ps1
Author      : Darren Hollinrake
Version     : 1.0
Date Created: 2024-04-11
Date Updated: 

- There is no check to see if the Windows services are already running.
- There is no check to see if tsm is already running.
- There is no log indicating why/which service failed to start.

.EXAMPLE
./Start-Tableau

#>

# Tableau Services
$Services = 'activationservice_0', 'appzookeeper_0', 'clientfileservice_0', 'licenseservice_0', 'tabadminagent_0', 'tabadmincontroller_0', 'tabsvc_0'

Start-Service $Services

# Ensure the services are running before continuing
foreach ($Service in (Get-Service $Services)) {
    try {
        $Service.WaitForStatus('Running', '00:05:00')
    }
    catch {
        Write-Error "The service $($Service.Name) failed to start. Error: $_"
        return
    }
}

# Start Tableau Server Manager
tsm start
