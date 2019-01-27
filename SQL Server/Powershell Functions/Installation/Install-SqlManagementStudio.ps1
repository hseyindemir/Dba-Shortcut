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