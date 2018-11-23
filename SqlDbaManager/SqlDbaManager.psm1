function Install-SqlManagementStudio {
<#
        .SYNOPSIS
        SQL Serve Management Studio Kurulumu
        .DESCRIPTION
        SQL Server Management Studio kurulumunu için setup dosyasinin dizini parametre alarak gerekli kurulumu yapan fonksiyon
        .EXAMPLE
        Install-SqlManagementStudio -ssmsSetupPath F:\
        .NOTES
        Author: Huseyin Demir
        Date:   June 15, 2018    
#>
    [CmdletBinding()]
    param 
    (
        
        [Parameter(ValueFromPipeline)]
        [string]
        $ssmsSetupPath
    )
    
    begin {

        $filepath="$ssmsSetupPath\SSMS-Setup-ENU.exe"
         
        
        if (!(Test-Path $filepath)){
        
        Write-Host "SSMS File Named SSMS-Setup-ENU.exe Not Found" -ForegroundColor Red
         
        }
        else 
        {
         
        write-host "Located the SQL SSMS Installer binaries, moving on to install..."
        }
    }
    
    process 
    {
       
        try 
        {
            write-host "Beginning SSMS 2017 install..." -nonewline
            $Parms = " /Install /Quiet /Norestart /INDICATEPROGRESS /Logs mySSMS.txt"
            $Prms = $Parms.Split(" ")
            & "$filepath" $Prms | Out-String
            
            Write-Host "SSMS installation complete" -ForegroundColor Green
        }
        catch 
        {
            Write-Host "SSMS installation could not Complete" -ForegroundColor Red
        }
        
       
    }
    
    end 
    {
        
        Get-WmiObject -Class Win32_Product | Select-Object Name,Version | Where-Object { $_.Name -like '*SQL Server Management Studio*'}
        Write-Host "Please Check Your Installation" -ForegroundColor Green
    }
}



function Install-SqlDatabase {

    <#
        .SYNOPSIS
        SQL Server Database Engine Kurulumu
        .DESCRIPTION
        SQL Server Database Engine kurulumunu için configuration file ve setup accountları ile yapan fonksiyon.
        .EXAMPLE
       Install-SqlDatabase -setupPath F:\setup.exe -configFilePath C:\config_file_ismi.ini -setupAccount DOMAIN\account_ismi -accountPasswd account_sifre -saPassWd saSifresi
        .NOTES
        Author: Huseyin Demir
        Date:   June 15, 2018    
#>
    [CmdletBinding()]
    param (
       
        [Parameter(ValueFromPipeline)]
        [ValidateScript({
            if(-Not ($_ | Test-Path) ){
                throw "File or folder does not exist" 
            }
            if(-Not ($_ | Test-Path -PathType Leaf) ){
                throw "The Path argument must be a file. Folder paths are not allowed."
            }
            return $true
        })]
        [string]
        $setupPath,
        
        [Parameter(ValueFromPipeline)]
        [string]
        $setupAccount,
        [Parameter(ValueFromPipeline)]
        [ValidateScript({
            if(-Not ($_ | Test-Path) ){
                throw "File or folder does not exist" 
            }
            if(-Not ($_ | Test-Path -PathType Leaf) ){
                throw "The Path argument must be a file. Folder paths are not allowed."
            }
            return $true
        })]
        [string]
        $configFilePath,
        [Parameter(ValueFromPipeline)]
        [string]
        $accountPasswd,
        [Parameter(ValueFromPipeline)]
        [string]
        $saPassWd
    )
    
    begin 
    {

    }
    
    process 
    {
        try 
        {
        
        $parametersForInstallation = "/Q /ConfigurationFile=$configFilePath /AGTSVCACCOUNT=$setupAccount /AGTSVCPASSWORD=$accountPasswd /SQLSVCACCOUNT=$setupAccount /SQLSVCPASSWORD=$accountPasswd /SAPWD=$saPassWd"
        $parametersForInstallation = $parametersForInstallation.Split(" ")
        & "$setupPath" $parametersForInstallation | Out-Null
        Write-Host "Sql Server Database was Installed" -ForegroundColor Green
            
        }
        catch 
        {
            Write-Host "Sql Server Database was not Installed" -ForegroundColor Red
        }
        
    }
    
    end 
    {
        Write-Host "Please Check Your Installation" -ForegroundColor Green
    }
}

function Install-PostSql {

    
    <#
        .SYNOPSIS
        SQL Server Kurulum Sonrası Post Configuration Fonksiyonu
        .DESCRIPTION
        SQL Server Kurulum sonrası tamamlanmak istenen post .sql uzantili dosyalarin toplu bir şekilde deploy edilmesini saglayan fonksiyon
        .EXAMPLE
       Install-PostSql -postScriptPath C:\postfolder\
        .NOTES
        Author: Huseyin Demir
        Date:   June 15, 2018    
#>
    [CmdletBinding()]
    param (
        
        [Parameter(ValueFromPipeline)]
        [ValidateScript({
            if(-Not ($_ | Test-Path) ){
                throw "File or folder does not exist" 
            }
            return $true
        })]
        [string]
        $postScriptPath
    )
    
    begin 
    {
       
        $serverName = "localhost"
        $databaseName = "master"
        Write-Host "Starting Post Installation on SQL Server..." -ForegroundColor Green -BackgroundColor Black
    }
    
    process 
    {
        try {      
            Write-Host "Started Post Installation on SQL Server" -ForegroundColor Green -BackgroundColor Black
            
            foreach ($f in Get-ChildItem -path $postScriptPath -Filter *.sql -ea 1 | sort-object fullname )  { 
               
                $SqlFile = $f.fullname
                invoke-sqlcmd -ServerInstance $serverName -Database $databaseName -InputFile $f.fullname -ea 1 -QueryTimeout 600 # | out-file -filepath $out -ea 0
                Write-Host "# OK: $SqlFile"
                $SqlFile = $NULL
                Start-Sleep -Seconds 1
                }
           
             Write-Host "Finished Post Installation on SQL Server"
        }
        catch {
            $ErrorMsg = $_.Exception.Message
            return "# FAILED: $SqlFile | $ErrorMsg"
        }
    }
    
    end 
    {
        Write-Host "Sql Post Installation Function Completed" -ForegroundColor White -BackgroundColor Black
    }
}

function Install-dbatoolsBestPractice {

        <#
        .SYNOPSIS
        SQL Server Kurulum Sonrası Post Configuration Fonksiyonu
        .DESCRIPTION
        SQL Server Kurulum sonrası tamamlanmak istenen best-practice configuration ayarlarının yapıld fonksiyon.
        .EXAMPLE
       Install-PostSql -postScriptPath C:\postfolder\
        .NOTES
        Author: Huseyin Demir
        Date:   June 15, 2018    
#>
    [CmdletBinding()]
    param 
    (
        
        
    )
    
    begin 
    {
        $serverName = "localhost"
    }
    
    process {

        try {
            
             $env:PSModulePath=[Environment]::GetEnvironmentVariable("PSModulePath", "Machine")
    
            if (Get-Module -ListAvailable -Name dbatools) {Write-Output "dbatools module exists."} 
            else {Write-Output "dbatools module does not exist."
                Invoke-Expression (Invoke-WebRequest -UseBasicParsing https://dbatools.io/in)}
    
            
            Write-Host "# Started dbatools"
            Set-DbaPowerPlan -ComputerName $serverName
            Write-Host "Powerplan Configuration was Done" -ForegroundColor Green -BackgroundColor Black
            Set-DbaMaxDop -SqlServer $serverName -MaxDop 4
            Write-Host "MaxDop Configuration was Done" -ForegroundColor Green -BackgroundColor Black
            Set-DbaMaxMemory -SqlServer $serverName
            Write-Host "MaxMemory Configuration was Done" -ForegroundColor Green -BackgroundColor Black
            Write-Host "# Finished dbatools"
            
        }
        catch {
            $ErrorMsg = $_.Exception.Message 
            return "# FAILED - SqlConfig: $ErrorMsg"
        }
    }
}

function Install-ManintenancePack {

    
    <#
        .SYNOPSIS
        SQL Server Kurulum Sonrası Bakım Prosedürleri için Gerekli Fonksiyon
        .DESCRIPTION
        SQL Server Kurulum sonrası tamamlanmak istenen dba bakımları için gerekli .sql uzantili dosyalarin toplu bir şekilde deploy edilmesini saglayan fonksiyon
        .EXAMPLE
       Install-PostSql -postScriptPath C:\Maintenance-Starter-Pack\
        .NOTES
        Author: Huseyin Demir
        Date:   June 15, 2018    
#>
    [CmdletBinding()]
    param (
        
        [Parameter(ValueFromPipeline)]
        [ValidateScript({
            if(-Not ($_ | Test-Path) ){
                throw "File or folder does not exist" 
            }
            return $true
        })]
        [string]
        $postScriptPath
    )
    
    begin 
    {
       
        $serverName = "localhost"
        $databaseName = "master"
        Write-Host "Starting Maintenance-Pack on SQL Server..." -ForegroundColor Green -BackgroundColor Black
    }
    
    process 
    {
        try {      
            Write-Host "Started Maintenance-Pack on SQL Server..." -ForegroundColor Green -BackgroundColor Black
            
            foreach ($f in Get-ChildItem -path $postScriptPath -Filter *.sql -ea 1 | sort-object fullname )  { 
               
                $SqlFile = $f.fullname
                invoke-sqlcmd -ServerInstance $serverName -Database $databaseName -InputFile $f.fullname -ea 1 -QueryTimeout 600 # | out-file -filepath $out -ea 0
                Write-Host "# OK: $SqlFile"
                $SqlFile = $NULL
                #Start-Sleep -Seconds 1
                }
           
             Write-Host "Finished Maintenance-Pack on SQL Server..."
        }
        catch {
            $ErrorMsg = $_.Exception.Message
            return "# FAILED: $SqlFile | $ErrorMsg"
        }
    }
    
    end 
    {
        Write-Host "Maintenance-Pack on SQL Server..." -ForegroundColor White -BackgroundColor Black
        Write-Host "Resource 1 : http://whoisactive.com/downloads/" -ForegroundColor White -BackgroundColor Black
        Write-Host "Resource 2 : https://ola.hallengren.com/" -ForegroundColor White -BackgroundColor Black
    }
}
