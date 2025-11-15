# 🚀 Windows Service Installer

Windows sunucularında servis kurulumunu otomatikleştiren PowerShell scripti.

## 📋 Özellikler

- ✅ Tek tıkla Windows Service kurulumu
- ✅ Otomatik yönetici yetkisi kontrolü
- ✅ Dosya varlığı doğrulaması
- ✅ Mevcut servisleri otomatik güncelleme
- ✅ Renkli ve anlaşılır çıktı
- ✅ Hata yönetimi ve detaylı mesajlar
- ✅ Servis durumu kontrolü

## 🎯 Ne İçin Kullanılır?

Bu script, Windows Service olarak çalışan .NET uygulamalarınızı (örneğin: zamanlı görevler, API tetikleyiciler, arka plan işlemleri) sunucuya kolayca kurmanızı sağlar.

## 📦 Gereksinimler

- Windows Server 2012+ veya Windows 10/11
- PowerShell 5.1 veya üzeri
- Yönetici (Administrator) yetkisi
- Kurulacak servis executable (.exe) dosyası

## 🔧 Kurulum

### 1. Script'i İndirin

```bash
git clone https://github.com/kullaniciadi/windows-service-installer.git
cd windows-service-installer
```

Veya doğrudan `install-service.ps1` dosyasını indirin.

### 2. Script'i Düzenleyin

`install-service.ps1` dosyasını bir metin editörü ile açın ve aşağıdaki değerleri düzenleyin:

```powershell
$serviceName = "TimedApiWorker"              # Servis adı
$displayName = "API Tetikleme Servisi"       # Görünen ad
$description = "API'yi belirli araliklarla tetikleyen servis"
$serviceExePath = "C:\Services\ApiTriggerService\TimedApiWorker.exe"
$startupType = "Automatic"                   # Automatic, Manual, Disabled
```

### 3. Script'i Çalıştırın

1. **PowerShell'i yönetici olarak açın**
   - Windows tuşuna basın
   - "PowerShell" yazın
   - Sağ tıklayıp **"Yönetici olarak çalıştır"** seçin

2. **Script klasörüne gidin**
   ```powershell
   cd C:\indirilen\klasor\yolu
   ```

3. **Script'i çalıştırın**
   ```powershell
   .\install-service.ps1
   ```

## 📸 Örnek Kullanım

```powershell
PS C:\Scripts> .\install-service.ps1

=======================================
   WINDOWS SERVICE KURULUM SCRIPTI
=======================================

[KONTROL] Yonetici yetkisi: OK
[KONTROL] Service dosyasi: OK

[ISLEM] Yeni servis olusturuluyor...

[BASARILI] Servis olusturuldu!

[ISLEM] Servis baslatiliyor...
[BASARILI] Servis basladi!

=======================================
         SERVIS BILGILERI
=======================================

  Servis Adi     : TimedApiWorker
  Gorunen Ad     : API Tetikleme Servisi
  Durum          : Running
  Baslangic Tipi : Automatic
  Dosya Yolu     : C:\Services\ApiTriggerService\TimedApiWorker.exe

=======================================

[TAMAMLANDI] Kurulum basarili!
```

## 🎛️ Yapılandırma Seçenekleri

### Başlangıç Tipleri

```powershell
$startupType = "Automatic"   # Sunucu açıldığında otomatik başlar
$startupType = "Manual"      # Manuel olarak başlatılır
$startupType = "Disabled"    # Devre dışı
```

## 🔍 Servis Kontrolü

Kurulumdan sonra servisi kontrol etmek için:

### Services Management Console

```powershell
services.msc
```

### PowerShell ile Kontrol

```powershell
# Servis durumunu görme
Get-Service -Name "TimedApiWorker"

# Servisi durdurma
Stop-Service -Name "TimedApiWorker"

# Servisi başlatma
Start-Service -Name "TimedApiWorker"

# Servisi yeniden başlatma
Restart-Service -Name "TimedApiWorker"
```

## 🐛 Sorun Giderme

### Servis Başlamadı

1. **Event Viewer'ı kontrol edin:**
   ```powershell
   eventvwr.msc
   ```
   - Windows Logs → Application
   - Servis adınızla ilgili hataları arayın

2. **.NET Runtime kontrolü:**
   ```powershell
   dotnet --list-runtimes
   ```
   Servisinizin gerektirdiği runtime'ın yüklü olduğundan emin olun.

3. **Dosya yolunu kontrol edin:**
   ```powershell
   Test-Path "C:\Services\ApiTriggerService\TimedApiWorker.exe"
   ```

### Encoding Sorunu

Script'te Türkçe karakterler bozuk görünüyorsa:

- Dosyayı **UTF-8 BOM** encoding ile kaydedin
- Visual Studio Code, PowerShell ISE veya Notepad++ kullanın

### Yönetici Yetkisi Hatası

PowerShell'i mutlaka **"Yönetici olarak çalıştır"** ile açın.

## 🗑️ Servisi Kaldırma

```powershell
# Servisi durdur
Stop-Service -Name "TimedApiWorker"

# Servisi sil
sc.exe delete "TimedApiWorker"
```

## 📝 Notlar

- Script, mevcut bir servisi bulursa otomatik olarak siler ve yenisini kurar
- Servis dosyalarını silmez, sadece Windows Service kaydını günceller
- Servis başlatılırken hata alırsanız, manuel olarak başlatmayı deneyin

## 🤝 Katkıda Bulunma

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'feat: Add amazing feature'`)
4. Branch'e push edin (`git push origin feature/amazing-feature`)
5. Pull Request açın

## 📄 Lisans

MIT License - Detaylar için [LICENSE](LICENSE) dosyasına bakın.

## 📧 İletişim

Sorularınız veya önerileriniz için issue açabilirsiniz.

---

**⭐ Faydalı bulduysanız yıldız vermeyi unutmayın!**
