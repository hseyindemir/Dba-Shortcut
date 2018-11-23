# SqlDbaManager Nedir ? <img align="left" width="50" height="50" src="https://github.com/hseyindemir/SqlDbaManager/blob/master/Images/ps-icon.png"> <img align="right" width="50" height="50" src="https://github.com/hseyindemir/SqlDbaManager/blob/master/Images/sql-icon.png"> 

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

- Install-SqlManagementStudio : SQL Server Management Studio Kurulumu (SqlDbaManager) 
- Install-SqlDatabase : SQL Server Database Engine Kurulumu (SqlDbaManager) 
- Install-PostSql : SQL Server Kurulum Sonrası Post Script Deployment İşlemleri (SqlDbaManager) 


Versiyon 2.0.0 

- Veritabanı Versiyon Raporu : Liste halinde verilen tüm veritabanlarının versiyonlarını csv dosyasına toplayan fonksiyon

Versiyon 2.0.1 

- Veritabanı Versiyon Raporu : Error handling geliştirmeleri,verbose özelliği eklendi.

Versiyon 2.0.2

- Yeni eklenecek modüller için farklı klasör yapısı oluşturuldu.

Versiyon 3.0.2

- Invoke-SqlLogShipping : SQL Server Log Shipping Setup&Implementation (SqlDrManager) 

Versiyon 3.1.2

- Install-dbatoolsBestPractice : dbatools kütüphanesindeki tüm konfigürasyon best-practice'lerini veritabanına uygulayan fonksiyon.

Versiyon 3.2.3

- Get-DisasterHealth(SqlDrManager) : Disaster log shipping için healthcheck yapan fonksiyon geliştirildi.
- Help Menü ve fonksiyon yazarları düzenlendi.
- .gitignore dosyası oluşturuldu.
- Invoke-Logshipping (SqlDrManager) : Function import sırasında yaşanan hata düzeltildi.
- Install-SqlManagementStudio(SqlDbaManager) : Kurulum sonrası güncel SSMS bilgisini kullanıcıya ileten özellik geliştirildi.

Versiyon 3.3.3

- Generate-IndexScript : Tablo,alan isimleri ve index oluşturma parametreleri ile birlikte otomatik index scripti üreten fonksiyon geliştirmesi yapıldı. 
- Install-MaintenancePack : whoisactive ve OLA gibi temel bakım prosedürlerini veritabanına yükleyen fonksiyon geliştirmesi yapıldı.
- Maintenance-Starter-Pack klasörü eklenmesi yapıldı. Bu klasör içerinde SQL DBA için gerekli bakım scriptlerinin paylaşılması sağlandı. 

Versiyon 3.4.4

- Install-PostSql : Parametre isimleri nedeniyle yaşanan hata giderildi.
- Generate-IndexScript : Indexlerin kurulabileceği filegroup opsiyonu eklendi.