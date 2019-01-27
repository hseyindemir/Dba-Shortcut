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
