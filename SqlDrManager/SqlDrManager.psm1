function Invoke-SqlLogShipping {
      <#
        .SYNOPSIS
        Fiziksel log shipping işlemini yapan fonksiyondur.
        .DESCRIPTION
        SQL Server Veritabanı seviyesinde full ve t-log backupları okuyarak belirlenen zamana kadar restore eden fonksiyondur. 
        .EXAMPLE
        Invoke-SqlLogShipping -SourceServer "sour-server-name -SourceDatabase "db-name" -DestinationServer "destination-server-name" -DestinationDataPath "data-file-path-destination" -DestinationLogPath "log-file-path-destination -DelayMinute 60
        .EXAMPLE
        Invoke-SqlLogShipping -SourceServer "sour-server-name -SourceDatabase "db-name" -DestinationServer "destination-server-name" -DestinationDataPath "data-file-path-destination" -DestinationLogPath "log-file-path-destination -Initialize -DelayMinute 60
    #>
    [CmdletBinding()] param (
    [Parameter(Mandatory=$true)][string]$SourceServer,
    [Parameter(Mandatory=$true)][string]$SourceDatabase,
    [Parameter(Mandatory=$true)][string]$DestinationServer,
    [string]$DestinationDatabase,
    [string]$DestinationDataPath,
    [string]$DestinationLogPath,
    [switch]$Initialize,
    $SqlCred,
    [int]$DelayMinute = 60
        )
    
        Write-Host (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") "Started. `r" 
    
        try {
            $Global:sequence = 1;
            $Global:seq = 1;
            if (!$DestinationDatabase) {$DestinationDatabase = $SourceDatabase}
    
            if ($Initialize) {$d = Get-DbaBackupHistory -SqlInstance $SourceServer -Database $SourceDatabase -IncludeCopyOnly -LastFull | select -ExpandProperty Start}
            else {$d = (Get-Date).AddDays(-2)}


    
            $files = Get-DbaBackupHistory -SqlInstance $SourceServer -Database $SourceDatabase -IncludeCopyOnly -Since $d -Raw | Sort-Object -Property backupsetid | where -Property Start -LE (Get-Date).AddMinutes(-$DelayMinute) | select server, Start, Path, Type, @{Label = “rowid”; Expression = {$Global:seq; $Global:seq++;}}

            if (!$d) 
            {
                Write-Host "Could not retrieve backup history. Please check backup dates and files."
            }
            else 
            
            {
                if ($Initialize) {
                    $file = $files | where Type -EQ "Full" | select -ExpandProperty Path
                    if (($file.Substring(1,2)) -eq ":\" ) {$file = "\\$SourceServer\" +  $file.replace(":","$")} 
                    Write-Host (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") "Restoring Full Backup..." $file " `r"
                    Restore-DbaDatabase -Path $file -SqlInstance $DestinationServer -NoRecovery -DestinationDataDirectory $DestinationDataPath -DestinationLogDirectory $DestinationLogPath -EnableException 
                }
                else {
                    $LastRestoredFileName = Get-DbaRestoreHistory -SqlInstance $DestinationServer -Database $DestinationDatabase -Last | select -ExpandProperty From | Split-Path -leaf
                    $files2 = $files | select *, @{n='Path2';e={Split-Path $_.Path -Leaf | Split-Path -Leaf}}
                    $LastRestoredFileId = $files2 | where -Property Path2 -eq $LastRestoredFileName | select -ExpandProperty rowid
                    $files = $files | where -Property rowid -GT $LastRestoredFileId
                    
                }
        
                $files = $files | Where-Object -Property Type -NE "Full"
                
                [string]$DefaultBackupPath =  Get-DbaDefaultPath -SqlInstance $DestinationServer | select -ExpandProperty Backup
                foreach ($file in $files.Path) { 
                    if (($file.Substring(1,2)) -eq ":\" ) {$file = "\\$SourceServer\" +  $file.replace(":","$")} 
                    Write-Host (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") "Restoring Log Backup..." $file " `r"
                    Invoke-Sqlcmd2 -SqlInstance $DestinationServer -Database master -QueryTimeout 0 -Query "
                    IF EXISTS(SELECT * FROM sys.databases d WITH (NOLOCK) WHERE d.state = 0 AND d.name = '$DestinationDatabase') BEGIN
                        ALTER DATABASE [$DestinationDatabase] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
                    END
                    RESTORE LOG [$DestinationDatabase] FROM DISK = N'$file' WITH FILE = 1, STANDBY = N'$DefaultBackupPath\ROLLBACK_UNDO_$DestinationDatabase.bak', NOUNLOAD, STATS = 10; 
                    ALTER DATABASE [$DestinationDatabase] SET MULTI_USER;
                    " 
                }
        
        
                Write-Host (Get-Date).ToString("yyyy-MM-dd HH:mm:ss") "Finished. `r" 
          
            }
        }
            catch {
                $ErrorMsg = $_.Exception.Message
                return $ErrorMsg
                exit 2
            }
            }
    
            
        
    }