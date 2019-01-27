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
