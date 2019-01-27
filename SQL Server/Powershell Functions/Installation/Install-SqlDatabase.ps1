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