function Install-SqlManagementStudio {
    [CmdletBinding()]
    param 
    (
        
        [Parameter(ValueFromPipeline)]
        [string]
        $ssmsSetupPath
    )
    
    begin {

        $filepath="$ssmsSetupPath\SSMS-Setup-ENU.exe"
         
        #If SSMS not present, download on next release
        if (!(Test-Path $filepath)){
        
        Write-Host "SSMS Not Found" -ForegroundColor Red
         
        }
        else {
         
        write-host "Located the SQL SSMS Installer binaries, moving on to install..."
        }
    }
    
    process 
    {
       
        try 
        {
            write-host "Beginning SSMS 2017 install..." -nonewline
            $Parms = " /Install /Quiet /Norestart /Logs log.txt"
            $Prms = $Parms.Split(" ")
            & "$filepath" $Prms | Out-Null
            Write-Host "SSMS installation complete" -ForegroundColor Green
        }
        catch 
        {
            Write-Host "SSMS installation could not Complete" -ForegroundColor Red
        }
        
       
    }
    
    end 
    {
        #Get SQL Server Management Studio Software Details on Next Release

        Write-Host "Please Check Your Installation" -ForegroundColor Green
    }
}

function Export-DatabaseVersionReport {
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
        $serverListFilePath,
        [Parameter(ValueFromPipeline)]
        [string]
        $reportFilePath
    )
    
    begin 
    {
        $databaseList = Get-Content -Path $serverListFilePath
        if (Test-Path -Path $reportFilePath) 
        {
            Remove-Item -Path $reportFilePath
        }
      
        

    }
    
    process 
    {
        foreach ($db in $databaseList) 
        {
            Get-SqlInstance -ServerInstance $db |Select-Object DisplayName,Edition,VersionString | Export-Csv -Path $reportFilePath -Append -NoTypeInformation
            
        }


    }
    
    end 
    {

        Write-Host "Database Version Report Completed in CSV File Format. Your Report is Available" $reportFilePath -BackgroundColor Black -ForegroundColor Green

    }
}

function Install-SqlDatabase {
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
        # Declare Localhost Parameters
        $serverName = "localhost"
        $databaseName = "master"
        Write-Host "Starting Post Installation on SQL Server..." -ForegroundColor Green -BackgroundColor Black
    }
    
    process 
    {
        try {      
            Write-Host "Started Post Installation on SQL Server" -ForegroundColor Green -BackgroundColor Black
            
            foreach ($f in Get-ChildItem -path $filepath -Filter *.sql -ea 1 | sort-object fullname )  { 
               
                $SqlFile = $f.fullname
                invoke-sqlcmd -ServerInstance $serverName -Database $databaseName -InputFile $f.fullname -ea 1 -QueryTimeout 600 # | out-file -filepath $out -ea 0
                Write-Host "# OK: $SqlFile"
                $SqlFile = $NULL
                #Start-Sleep -Seconds 1
                }
            ############### End of SQL Scripts Loop ###############
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


function Test-PendingReboot
{
 if (Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -EA Ignore) { return $true }
 if (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -EA Ignore) { return $true }
 if (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -EA Ignore) { return $true }
 try { 
   $util = [wmiclass]"\\.\root\ccm\clientsdk:CCM_ClientUtilities"
   $status = $util.DetermineIfRebootPending()
   if(($status -ne $null) -and $status.RebootPending){
     return $true
   }
 }catch{}
 
 return $false
}
function Export-RebootAndPatch {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(ValueFromPipeline)]
        [string]
        $excelPath,
        # Parameter help description
        [Parameter(ValueFromPipeline)]
        [string]
        $excelFileName,
        # Parameter help description
        [Parameter(ValueFromPipeline)]
        [string]
        $serverListPath
    )
    
    begin 
    {
        $servers = Get-Content $serverListPath
        #Create New Data Table
        $dt4RebootPatch = New-Object System.Data.DataTable("RebootAndPatchTable")
        $serverColumn = New-Object system.Data.DataColumn ServerName,([string])
        $rebootColumn = New-Object system.Data.DataColumn RebootStatus,([string])
        $patchColumn = New-Object system.Data.DataColumn PatchLevel,([string])
        $dt4RebootPatch.Columns.Add($serverColumn)
        $dt4RebootPatch.Columns.Add($rebootColumn)
        $dt4RebootPatch.Columns.Add($patchColumn)

    }
    
    process 
    {
        foreach ($server in $servers) 
        {
            Write-Host "Collecting Information For " $server -BackgroundColor Black -ForegroundColor Green
            $sqlVersion = Invoke-Sqlcmd -ServerInstance $server -Query "select @@version" | Select-Object Column1
            Write-Host $sqlVersion

            $newRecord = $dt4RebootPatch.NewRow()
            $newRecord.ServerName = $server

            #Write Reboot Status Check Code
            $reboot=Invoke-Command -ScriptBlock ${function:Test-PendingReboot} -ComputerName $server
            Write-Host $reboot
            $newRecord.RebootStatus = $reboot
            $newRecord.PatchLevel = $sqlVersion

            #Son Patch Bilgisini Çeken Fonksiyon(Opsiyonel)

            $dt4RebootPatch.Rows.Add($newRecord)
           
            
        }
        #Done
        #Get-Process | Export-Csv -Path "$excelPath\$excelFileName" -Delimiter ";"
        $dt4RebootPatch | Format-Table -AutoSize
        $dt4RebootPatch | Export-Csv -Path "$excelPath\$excelFileName" -Delimiter ";" -NoTypeInformation
    }
    
    end {
    }
}

