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



