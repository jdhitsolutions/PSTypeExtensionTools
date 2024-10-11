Function Get-PSType {
    [CmdletBinding()]
    [OutputType("System.String")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline
        )]
        [object]$InputObject
    )

    Begin {
        Write-Verbose "Starting: $($MyInvocation.MyCommand)"
        $data = @()
    }
    Process {
        #get the type of each pipelined object
        $data += ($InputObject | Get-Member | Select-Object -First 1).TypeName
    }
    End {
        #write unique values to the pipeline
        $data | Get-Unique
        Write-Verbose "Ending: $($MyInvocation.MyCommand)"
    }
} #end Get-PSType
