function Restore-FullBackup {

    <#
    .SYNOPSIS
    SQL Server Restore İşlemleri için Kullanılan Fonksiyon.
    .DESCRIPTION
    SQL Server backup path'i verildikten sonra o dizinde bulunan son full backup ve üzerine transaction log backupları restore eden fonksiyondur.
    .EXAMPLE
   Restore-FullBackup -RestoreServer localhost -DatabaseName test -NoRecovery -Path \\network\B$\Backup
   Restore-FullBackup -RestoreServer localhost -DatabaseName test -NoRecovery -Path B:\Backup
   Restore-FullBackup -RestoreServer localhost -DatabaseName test -Path B:\Backup
    .NOTES
    Author: Huseyin Demir
    Date:   January 27, 2019    
#>
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory=$true)][string]$RestoreServer,
        [Parameter(Mandatory=$true)][string]$DatabaseName,
        [Parameter(Mandatory=$false)][switch]$NoRecovery,
        [Parameter(Mandatory=$true)][string]$Path
        
    )
    
    begin 
    {
        $StartDate = Get-Date
        Write-Host ($StartDate).ToString("yyyy-MM-dd HH:mm:ss") "Started. `r" 

      

    }
    
    process 
    {
        if ($NoRecovery) 
        {
            Restore-DbaDatabase -SqlInstance $RestoreServer -DatabaseName $DatabaseName -Path $Path -UseDestinationDefaultDirectories -WithReplace -NoRecovery
          
        }
        else 
        {
            Restore-DbaDatabase -SqlInstance $RestoreServer -DatabaseName $DatabaseName -Path $Path -UseDestinationDefaultDirectories -WithReplace
        }
      
    }
    
    end 
    {
        $RestoreInformation = Get-DbaRestoreHistory -SqlInstance $RestoreServer -Database $DatabaseName -Last | Select-Object Date,From,RestoreType
        Write-Host "Last Restored File: " $RestoreInformation.From
        Write-Host "Last Restored File Type: " $RestoreInformation.RestoreType
        Write-Host "Last Restored Date: " $RestoreInformation.Date

    }
}