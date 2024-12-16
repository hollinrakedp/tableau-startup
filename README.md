# Start-Tableau
This script was created to start Tableau Server without requiring the manual startup of the associated Windows services and the TSM CLI commands.

## Running the Script
The script can be ran manually or set as a scheduled task. Ensure the script has been copied to the system before continuing.

To run successfully, you will need administrative rights on the Tableau server.

### Manual Run
A manual run is a good idea if you want to verify the script is able to successfully start Tableau.

Complete the following steps to run the script manually:
1. Open an elevated terminal/PowerShell window.
1. Change to the directory
   - ```cd C:\Path\To\Script```
1. Run the script
   - ```.\Start-Tableau.ps1```
   - Note: You may need to set your execution policy to allow for running scripts if it has not already been set
1. Once the script has finished running, you can check the status of the Windows services to ensure they're all running
   - ```Get-Service -DisplayName "*Tableau*"```
1. Check the status of Tableau using the tsm commands
   - ```tsm status```
   - ```tsm status --verbose```

### Scheduled Task
A scheduled task is a good way to ensure Tableua starts if the server rebooted.

Complete the following steps to create a scheduled task:
1. Open Task Scheduler
1. Create Task...
   1. General
      - Name: App - Start Tableau
      - Description: This task will start the Tableau Windows services. Once all services are running, it will issue the 'start tsm' command.
      - When running the task, use the following user account: SYSTEM
      - Configure for: Windows Server 2019
   1. Triggers
      - Begin the task: At startup
      - Delay task for: 5 minutes (Checked)
   1. Actions
      - Action: Start a program
      - Program/script: powershell.exe
      - Add arguements (optional): -NoProfile -ExecutionPolicy Bypass -File "C:\Path\to\Start-Tableau.ps1"
   1. Conditions
      - Start only if the following network connection is available: Checked (optional)
         - Any connection (or the network connection used by Tableau)