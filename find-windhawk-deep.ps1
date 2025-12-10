# Recherche approfondie de la config Windhawk
Write-Host "=== Recherche approfondie ===" -ForegroundColor Cyan

# Chercher tous les fichiers contenant "windhawk" dans le nom
Write-Host "`nFichiers contenant 'windhawk' dans AppData..." -ForegroundColor Yellow
Get-ChildItem $env:APPDATA -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*windhawk*" -or $_.Name -like "*Windhawk*" } | ForEach-Object {
    Write-Host "  $($_.FullName)" -ForegroundColor Gray
}

Write-Host "`nFichiers contenant 'windhawk' dans LocalAppData..." -ForegroundColor Yellow
Get-ChildItem $env:LOCALAPPDATA -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -like "*windhawk*" -or $_.Name -like "*Windhawk*" } | ForEach-Object {
    Write-Host "  $($_.FullName)" -ForegroundColor Gray
}

# Chercher les fichiers JSON dans ProgramData\Windhawk
Write-Host "`nTous les fichiers dans ProgramData\Windhawk..." -ForegroundColor Yellow
Get-ChildItem "C:\ProgramData\Windhawk" -Recurse -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "  $($_.FullName)" -ForegroundColor Gray
}

# Exporter le registre Windhawk complet
Write-Host "`n=== Registre HKLM Windhawk complet ===" -ForegroundColor Cyan
$exportPath = "C:\Users\julien\OneDrive\Coding\_Projets de code\2025.11 Windhawk\windhawk-registry.txt"
reg export "HKLM\SOFTWARE\Windhawk" $exportPath /y 2>$null
if (Test-Path $exportPath) {
    Write-Host "Exporté vers: $exportPath" -ForegroundColor Green
    Get-Content $exportPath | Select-Object -First 100
}
