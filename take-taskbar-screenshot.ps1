Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$screen = [System.Windows.Forms.Screen]::PrimaryScreen
$height = 60
$y = $screen.Bounds.Height - $height

$bitmap = New-Object System.Drawing.Bitmap($screen.Bounds.Width, $height)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.CopyFromScreen($screen.Bounds.X, $y, 0, 0, $bitmap.Size)

$path = "C:\Users\julien\OneDrive\Coding\_Projets de code\2025.11 Windhawk\taskbar-screenshot.png"
$bitmap.Save($path)

$graphics.Dispose()
$bitmap.Dispose()

Write-Host "Screenshot saved to: $path"
