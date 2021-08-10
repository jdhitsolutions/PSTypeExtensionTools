Function Get-PSType {
    [cmdletbinding()]
    [outputtype("System.String")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline
        )]
        [object]$Inputobject
    )

    Begin {
        Write-Verbose "Starting: $($MyInvocation.Mycommand)"
        $data = @()
    }
    Process {
        #get the type of each pipelined object
        $data += ($Inputobject | Get-Member | Select-Object -First 1).typename
    }
    End {
        #write unique values to the pipeline
        $data | Get-Unique
        Write-Verbose "Ending: $($MyInvocation.Mycommand)"
    }
} #end Get-PSType