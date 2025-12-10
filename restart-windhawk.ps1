# Redémarrer Windhawk
Write-Host "Recherche de Windhawk..." -ForegroundColor Yellow

# Trouver et arrêter le processus Windhawk
$procs = Get-Process | Where-Object { $_.ProcessName -like "*Windhawk*" }
if ($procs) {
    Write-Host "Arrêt de Windhawk..." -ForegroundColor Yellow
    $procs | Stop-Process -Force
    Start-Sleep -Seconds 2
}

# Trouver l'exécutable Windhawk
$windhawkPath = $null
$possiblePaths = @(
    "$env:ProgramFiles\Windhawk\Windhawk.exe",
    "${env:ProgramFiles(x86)}\Windhawk\Windhawk.exe",
    "$env:LocalAppData\Windhawk\Windhawk.exe",
    "$env:AppData\Windhawk\Windhawk.exe"
)

foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        $windhawkPath = $path
        break
    }
}

# Chercher via le registre
if (-not $windhawkPath) {
    $regPaths = @(
        "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )

    foreach ($regPath in $regPaths) {
        $app = Get-ItemProperty $regPath -ErrorAction SilentlyContinue | Where-Object { $_.DisplayName -like "*Windhawk*" }
        if ($app -and $app.InstallLocation) {
            $testPath = Join-Path $app.InstallLocation "Windhawk.exe"
            if (Test-Path $testPath) {
                $windhawkPath = $testPath
                break
            }
        }
    }
}

# Chercher dans les raccourcis du menu démarrer
if (-not $windhawkPath) {
    $shortcut = Get-ChildItem "$env:ProgramData\Microsoft\Windows\Start Menu\Programs" -Recurse -Filter "*Windhawk*.lnk" -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($shortcut) {
        $shell = New-Object -ComObject WScript.Shell
        $target = $shell.CreateShortcut($shortcut.FullName).TargetPath
        if (Test-Path $target) {
            $windhawkPath = $target
        }
    }
}

if ($windhawkPath) {
    Write-Host "Démarrage de Windhawk depuis: $windhawkPath" -ForegroundColor Green
    Start-Process $windhawkPath
} else {
    Write-Host "Windhawk non trouvé. Chemins vérifiés:" -ForegroundColor Red
    $possiblePaths | ForEach-Object { Write-Host "  - $_" -ForegroundColor Gray }
    Write-Host ""
    Write-Host "Veuillez démarrer Windhawk manuellement." -ForegroundColor Yellow
}
