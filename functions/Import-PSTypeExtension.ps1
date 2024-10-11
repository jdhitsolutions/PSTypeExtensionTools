Function Import-PSTypeExtension {
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = "The name of the imported file. The extension must be .xml or .json")]
        [ValidatePattern("\.(xml|json)$")]
        [ValidateScript( { Test-Path $(Convert-Path $_) })]
        [alias("FullName")]
        [String]$Path
    )

    Begin {
        Write-Verbose "Starting: $($MyInvocation.MyCommand)"
    }
    Process {
        Write-Verbose "Importing file $(Convert-Path $Path)"
        if ($path -match "\.xml$") {
            #xml format seems to add an extra entry
            $import = Import-Clixml -Path $path | Where-Object MemberType
        }
        else {
            $import = Get-Content -Path $path | ConvertFrom-Json
        }

        foreach ($item in $import) {
            Write-Verbose "Processing $($item.MemberType) : $($item.MemberName)"
            if ($item.MemberType -match "^Code") {
                Write-Warning "Skipping Code related member"
            }
            if ($item.MemberType -match "^Script") {
                Write-Verbose "Creating scriptblock from value"
                $value = [scriptblock]::create($item.value)
            }
            else {
                $value = $item.Value
            }
            #add a custom -WhatIf message
            if ($PSCmdlet.ShouldProcess($Item.TypeName, "Adding $($item.MemberType) $($item.MemberName)")) {
                #implement the change
                Update-TypeData -TypeName $item.TypeName -MemberType $item.MemberType -MemberName $item.MemberName -Value $value -Force
            }
        } #foreach
    }
    End {
        Write-Verbose "Ending: $($MyInvocation.MyCommand)"
    }

} #end Import-PSTypeExtension
