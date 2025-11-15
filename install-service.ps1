# Windows Service Kurulum Scripti
# Bu scripti YONETICI olarak calistirin!
# Dosyayi UTF-8 BOM ile kaydedin!

# ========================================
# AYARLAR - Buradan duzenleyin
# ========================================
$serviceName = "TimedApiWorker"
$displayName = "API Tetikleme Servisi"
$description = "API'yi belirli araliklarla tetikleyen servis"
$serviceExePath = "C:\Services\ApiTriggerService\TimedApiWorker.exe"
$startupType = "Automatic"  # Automatic, Manual, Disabled

# ========================================
# KURULUM
# ========================================

Clear-Host
Write-Host ""
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host "   WINDOWS SERVICE KURULUM SCRIPTI     " -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan
Write-Host ""

# Yonetici kontrolu
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "[HATA] Bu script yonetici yetkisiyle calistirilmali!" -ForegroundColor Red
    Write-Host "       PowerShell'i sag tiklayip 'Yonetici olarak calistir' secin." -ForegroundColor Yellow
    Write-Host ""
    pause
    exit
}

Write-Host "[KONTROL] Yonetici yetkisi: OK" -ForegroundColor Green

# Dosya kontrolu
if (-not (Test-Path $serviceExePath)) {
    Write-Host ""
    Write-Host "[HATA] Service dosyasi bulunamadi!" -ForegroundColor Red
    Write-Host "       Yol: $serviceExePath" -ForegroundColor Yellow
    Write-Host ""
    pause
    exit
}

Write-Host "[KONTROL] Service dosyasi: OK" -ForegroundColor Green
Write-Host ""

# Mevcut service kontrolu
$existingService = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
if ($existingService) {
    Write-Host "[UYARI] '$serviceName' zaten mevcut!" -ForegroundColor Yellow
    Write-Host "[ISLEM] Mevcut servis siliniyor..." -ForegroundColor Yellow
    
    # Servisi durdur
    if ($existingService.Status -eq 'Running') {
        Stop-Service -Name $serviceName -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        Write-Host "[BASARILI] Servis durduruldu" -ForegroundColor Green
    }
    
    # Servisi sil
    sc.exe delete $serviceName | Out-Null
    Start-Sleep -Seconds 3
    Write-Host "[BASARILI] Eski servis silindi" -ForegroundColor Green
    Write-Host ""
}

# Yeni servisi olustur
Write-Host "[ISLEM] Yeni servis olusturuluyor..." -ForegroundColor Cyan
Write-Host ""

try {
    $result = New-Service -Name $serviceName `
                -BinaryPathName $serviceExePath `
                -DisplayName $displayName `
                -Description $description `
                -StartupType $startupType `
                -ErrorAction Stop
    
    Write-Host "[BASARILI] Servis olusturuldu!" -ForegroundColor Green
    Write-Host ""
    
    # Servisi baslat
    Write-Host "[ISLEM] Servis baslatiliyor..." -ForegroundColor Cyan
    Start-Sleep -Seconds 2
    
    try {
        Start-Service -Name $serviceName -ErrorAction Stop
        Write-Host "[BASARILI] Servis basladi!" -ForegroundColor Green
    } catch {
        Write-Host "[HATA] Servis baslatilamadi!" -ForegroundColor Red
        Write-Host "       Hata: $($_.Exception.Message)" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "[IPUCU] Servisi manuel baslatmayi deneyin:" -ForegroundColor Yellow
        Write-Host "        1. services.msc acin" -ForegroundColor Gray
        Write-Host "        2. '$displayName' bulun" -ForegroundColor Gray
        Write-Host "        3. Sag tikla > Start" -ForegroundColor Gray
    }
    
    Write-Host ""
    Start-Sleep -Seconds 2
    
    # Durum kontrolu
    $service = Get-Service -Name $serviceName
    Write-Host "=======================================" -ForegroundColor Cyan
    Write-Host "         SERVIS BILGILERI              " -ForegroundColor Cyan
    Write-Host "=======================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  Servis Adi     : " -NoNewline -ForegroundColor Gray
    Write-Host $service.Name -ForegroundColor White
    Write-Host "  Gorunen Ad     : " -NoNewline -ForegroundColor Gray
    Write-Host $service.DisplayName -ForegroundColor White
    Write-Host "  Durum          : " -NoNewline -ForegroundColor Gray
    if ($service.Status -eq 'Running') {
        Write-Host $service.Status -ForegroundColor Green
    } else {
        Write-Host $service.Status -ForegroundColor Red
    }
    Write-Host "  Baslangic Tipi : " -NoNewline -ForegroundColor Gray
    Write-Host $startupType -ForegroundColor White
    Write-Host "  Dosya Yolu     : " -NoNewline -ForegroundColor Gray
    Write-Host $serviceExePath -ForegroundColor White
    Write-Host ""
    Write-Host "=======================================" -ForegroundColor Cyan
    Write-Host ""
    
    if ($service.Status -eq 'Running') {
        Write-Host "[TAMAMLANDI] Kurulum basarili!" -ForegroundColor Green
    } else {
        Write-Host "[UYARI] Servis kuruldu ama calismadi!" -ForegroundColor Yellow
        Write-Host "         Event Viewer'dan log kontrolu yapin" -ForegroundColor Yellow
    }
    
    Write-Host ""
    Write-Host "Kontrol icin 'services.msc' yazin veya:" -ForegroundColor Gray
    Write-Host "Get-Service -Name $serviceName" -ForegroundColor Cyan
    
} catch {
    Write-Host "[HATA] Servis olusturulamadi!" -ForegroundColor Red
    Write-Host "       $($_.Exception.Message)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Enter'a basin..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")