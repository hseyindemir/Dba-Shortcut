# SqlDbaManager Nedir ? 

SQL Veritabanı Yöneticileri için powershell üzerinde yazılmış açık kaynak bir kütüphanedir. Bu modül, Veritabanı yöneticisinin karşılaştığı operasyonel işlerin yönettiği tüm ortamlara standart bir şekilde uygulaması için geliştirilmektedir. 


# SqlDbaManager Örnek Kullanımları

```powershell
#SQL Server Database Engine Kurulumu : 

Install-SqlDatabase -setupPath F:\setup.exe -configFilePath C:\config_file_ismi.ini -setupAccount DOMAIN\account_ismi -accountPasswd account_sifre -saPassWd saSifresi

#SQL Server Management Studio Kurulum : 

Install-SqlManagementStudio -ssmsSetupPath C:\Users\sqldba\Desktop\DBA\"

```

# SqlDbaManager Kurulumu

1. SqlDbaManager Modülünü git clone yöntemi ile download edin.

$ git clone git@github.com:hseyindemir/SqlDbaManager.git

2. SqlDbaManager klasörü altından aşağıdaki powershell komutunu çalıştırın
```powershell

Import-Module SqlDbaManager_dosya_yolu\SqlDbaManager.psd1

```
# Versiyon Listesi ve İçerikleri

Versiyon 1.0.0 

- Install-SqlManagementStudio : SQL Server Management Studio Kurulumu
- Install-SqlDatabase : SQL Server Database Engine Kurulumu
- Install-PostSql : SQL Server Kurulum Sonrası Post Script Deployment İşlemleri


Versiyon 2.0.0 

- Veritabanı Versiyon Raporu : Liste halinde verilen tüm veritabanlarının versiyonlarını csv dosyasına toplayan fonksiyon

Versiyon 2.0.1 

- Veritabanı Versiyon Raporu : Error handling geliştirmeleri,verbose özelliği eklendi.

# Geliştirilmekte Olan Özellikler

1. dbatools Best Practice : dbatools kütüphanesindeki tüm konfigürasyon best-practice'lerini veritabanına uygulayan fonksiyon geliştiriliyor.
2. Install-PostSql : Uzak Sunucu için post-installation özelliği geliştiriliyor.



