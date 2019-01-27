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
# Geliştirme Aşamasındaki Özellikler

Mevcut Versiyon : 3.4.4

| Özellik Tanımı  | Kullanıma Açılacak Versiyon |
| ------------- | ------------- |
| Failover Script Üreten Fonksiyonu(Powershell-SQL Server)  | 3.4.5  |
| Toplu Sunucu Restart Yönetim Fonksiyonu(Powershell-SQL Server)  | 3.4.5  |
| Idle in Transaction Temizliği(PLSQL-PostgreSQL)  | 3.4.5  |