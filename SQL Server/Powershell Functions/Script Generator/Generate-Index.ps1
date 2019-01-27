function Generate-IndexScript {
    [CmdletBinding()]
    param (
        
        [Parameter(Position = 0 , Mandatory = $true , ValuefromPipeline = $true)]
        [ValidateSet('CLUSTERED','NONCLUSTERED')]
        [string]
        $IndexType,
        [Parameter(Position = 1 , Mandatory = $true , ValuefromPipeline = $true)]
        [string]
        $TableName,
        [Parameter(Position = 2 , Mandatory = $true , ValuefromPipeline = $true)]
        [String[]]
        $FieldNames,
        [Parameter(Position = 3 , Mandatory = $true , ValuefromPipeline = $true)]
        [int]
        $FillFactor,
        [Parameter(Position = 4 , Mandatory = $true , ValuefromPipeline = $true)]
        [int]
        $MaxDop,
        [Parameter(Position = 5 , Mandatory = $true , ValuefromPipeline = $true)]
        [ValidateSet('ON','OFF')]
        [string]
        $Online,
        #Drop Existing ON OFF Parameter
        [Parameter(Position = 6 , Mandatory = $true , ValuefromPipeline = $true)]
        [ValidateSet('ON','OFF')]
        [string]
        $DropExisting,
        #Included Field Parameters
        [Parameter(Position = 7, ValuefromPipeline = $true)]
        [String[]]
        $IncludedFields,
        [Parameter(Position = 8, ValuefromPipeline = $true)]
        [String[]]
        $FileGroup

    )
    
    begin 
    {
        Write-Host 'Generating Index Script in T-SQL Format' -BackgroundColor Black -ForegroundColor Green
        Write-Host '---------------------------------------------------------------------------------------'
        $IndexName = 'NCIX_' + $TableName + '_' + $FieldNames[0]
        #Make comma between FieldNames
        $FieldNamesCommaVersion = New-Object System.Collections.ArrayList

        foreach ($item in $FieldNames) 
        
        {
            $FieldNamesCommaVersion.Add($item) > $null
            $FieldNamesCommaVersion.Add(',') > $null
        }
        #$FieldNamesCommaVersion.RemoveAt($FieldNamesCommaVersion.count - 1)

        #Make comma between IncludedFields
        $IncludedFieldNamesCommaVersion = New-Object System.Collections.ArrayList
        foreach ($item in $IncludedFields) 
        
        {
            $IncludedFieldNamesCommaVersion.Add($item) > $null
            $IncludedFieldNamesCommaVersion.Add(',') > $null
        }
        #$IncludedFieldNamesCommaVersion.RemoveAt($IncludedFieldNamesCommaVersion.count - 1)


    }
    
    process 
    {
        #Generate Script if IncludedFields is Null
        if ($IncludedFields -eq 0) 
        {
            if (([string]::IsNullOrEmpty($FileGroup)))
            {
                $IndexScript = 'CREATE ' + $IndexType + ' INDEX ' + $IndexName + ' ON [dbo].'+ $TableName + '(' + $FieldNamesCommaVersion + 
                ') WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, ' + 'MAXDOP = ' + $MaxDop + ',FILFACTOR = ' + $FillFactor +',DROP_EXISTING = ' +$DropExisting+' ONLINE= '+$Online +')'
                
            }
            else 
            {
                $IndexScript = 'CREATE ' + $IndexType + ' INDEX ' + $IndexName + ' ON [dbo].'+ $TableName + '(' + $FieldNamesCommaVersion + 
                ') WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, ' + 'MAXDOP = ' + $MaxDop + ',FILFACTOR = ' + $FillFactor +',DROP_EXISTING = ' +$DropExisting+' ONLINE= '+$Online +') ON ['+ $FileGroup +']'
                
            }
           
        }
        else 
        {
            if (([string]::IsNullOrEmpty($FileGroup)))
            {
                $IndexScript = 'CREATE ' + $IndexType + ' INDEX ' + $IndexName + ' ON [dbo].'+ $TableName + '(' + $FieldNamesCommaVersion + 
                ') '+ 'INCLUDE('+$IncludedFieldNamesCommaVersion+') ' +'WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, ' + 'MAXDOP = ' + $MaxDop + ',FILFACTOR = ' + $FillFactor +',DROP_EXISTING = ' +$DropExisting+' ONLINE= '+$Online +')' 
            }
            else 
            {
                $IndexScript = 'CREATE ' + $IndexType + ' INDEX ' + $IndexName + ' ON [dbo].'+ $TableName + '(' + $FieldNamesCommaVersion + 
                ') '+ 'INCLUDE('+$IncludedFieldNamesCommaVersion+') ' +'WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF,ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, ' + 'MAXDOP = ' + $MaxDop + ',FILFACTOR = ' + $FillFactor +',DROP_EXISTING = ' +$DropExisting+' ONLINE= '+$Online +') ON ['+ $FileGroup +']' 
            }
            
        }
       
       
       
        Write-Host $IndexScript
    }
    
    end 
    {
        Write-Host '---------------------------------------------------------------------------------------'
        Write-Host 'Generated Index Script in T-SQL Format.' -BackgroundColor Black -ForegroundColor Green
    }

}
