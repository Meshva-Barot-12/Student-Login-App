$ErrorActionPreference = "Stop"

Write-Host "Preparing Android and Web platform files for the existing Flutter project..." -ForegroundColor Cyan
flutter create . --platforms=android,web
flutter pub get
Write-Host "Platform files are ready." -ForegroundColor Green
Write-Host "Next: flutter run -d chrome OR press F5 in VS Code." -ForegroundColor Yellow
