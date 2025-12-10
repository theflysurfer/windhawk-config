# Chercher tous les fichiers de config Windhawk
Write-Host "=== Recherche des fichiers de configuration Windhawk ===" -ForegroundColor Cyan

$searchPaths = @(
    $env:APPDATA,
    $env:LOCALAPPDATA,
    $env:PROGRAMDATA,
    "$env:USERPROFILE\.windhawk",
    "$env:USERPROFILE\Windhawk"
)

foreach ($basePath in $searchPaths) {
    $whPath = Join-Path $basePath "Windhawk"
    if (Test-Path $whPath) {
        Write-Host "`nTrouvé: $whPath" -ForegroundColor Green
        Get-ChildItem $whPath -Recurse -File | ForEach-Object {
            Write-Host "  $($_.FullName)" -ForegroundColor Gray
            # Afficher le contenu des fichiers JSON ou de config
            if ($_.Extension -in @('.json', '.ini', '.cfg', '.config', '.txt')) {
                Write-Host "    Contenu:" -ForegroundColor Yellow
                Get-Content $_.FullName -ErrorAction SilentlyContinue | ForEach-Object {
                    Write-Host "      $_" -ForegroundColor DarkGray
                }
            }
        }
    }
}

# Chercher aussi dans le dossier d'installation portable
$portablePaths = @(
    "C:\Windhawk",
    "D:\Windhawk",
    "$env:USERPROFILE\Downloads\Windhawk"
)

foreach ($path in $portablePaths) {
    if (Test-Path $path) {
        Write-Host "`nInstallation portable trouvée: $path" -ForegroundColor Green
        Get-ChildItem $path -Recurse -File -Include @("*.json", "*.ini", "*.cfg") | ForEach-Object {
            Write-Host "  $($_.FullName)" -ForegroundColor Gray
        }
    }
}

# Vérifier le registre utilisateur aussi
Write-Host "`n=== Registre utilisateur ===" -ForegroundColor Cyan
$userRegPath = "HKCU:\SOFTWARE\Windhawk"
if (Test-Path $userRegPath) {
    Write-Host "Trouvé: $userRegPath" -ForegroundColor Green
    Get-ChildItem $userRegPath -Recurse | ForEach-Object {
        Write-Host "  $($_.PSPath)" -ForegroundColor Gray
        Get-ItemProperty $_.PSPath | Format-List
    }
} else {
    Write-Host "Pas de clé HKCU:\SOFTWARE\Windhawk" -ForegroundColor Yellow
}
