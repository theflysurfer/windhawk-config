# Trouver l'installation Windhawk via le raccourci
$shortcutPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\windhawk.exe - Raccourci.lnk"

if (Test-Path $shortcutPath) {
    $shell = New-Object -ComObject WScript.Shell
    $target = $shell.CreateShortcut($shortcutPath).TargetPath
    Write-Host "Windhawk exe: $target" -ForegroundColor Green

    $installDir = Split-Path $target -Parent
    Write-Host "Dossier d'installation: $installDir" -ForegroundColor Green

    Write-Host "`nContenu du dossier:" -ForegroundColor Yellow
    Get-ChildItem $installDir -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Host "  $($_.FullName)" -ForegroundColor Gray
    }

    # Chercher les fichiers de config
    Write-Host "`nFichiers de config potentiels:" -ForegroundColor Yellow
    Get-ChildItem $installDir -Recurse -Include @("*.json", "*.db", "*.sqlite", "*.ini", "*.cfg", "*.config", "*.dat") -ErrorAction SilentlyContinue | ForEach-Object {
        Write-Host "  $($_.FullName)" -ForegroundColor Cyan
        if ($_.Length -lt 50000) {
            Write-Host "  --- Contenu ---" -ForegroundColor DarkYellow
            Get-Content $_.FullName -ErrorAction SilentlyContinue | Select-Object -First 50
            Write-Host "  --- Fin ---" -ForegroundColor DarkYellow
        }
    }
} else {
    Write-Host "Raccourci non trouvé" -ForegroundColor Red
}
