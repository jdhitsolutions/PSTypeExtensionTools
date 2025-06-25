Function Import-PSTypeExtension {
    [CmdletBinding(SupportsShouldProcess)]
    [OutputType('None','PSTypeExtensionPreview')]
    [alias('itex')]
    Param(
        [Parameter(
            Mandatory,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName,
            HelpMessage = 'The name of the imported file. The extension must be .xml or .json')]
        [ValidatePattern('\.(xml|json)$')]
        [ValidateScript( { Test-Path $(Convert-Path $_) })]
        [alias('FullName')]
        [String]$Path,

        [Parameter(HelpMessage = 'Preview the type extensions without applying them. This will not modify the type data.')]
        [switch]$Preview
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting: $($MyInvocation.MyCommand)"
        If ($Preview) {
            Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Initializing a preview list"
            #initialize a generic list
            $list = New-Object System.Collections.Generic.List[PSCustomObject]
        }
    }
    Process {
        $Path = Convert-Path $Path
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Importing file $Path"
        if ($path -match '\.xml$') {
            #xml format seems to add an extra entry
            $import = Import-Clixml -Path $path | Where-Object MemberType
        }
        else {
            $import = Get-Content -Path $path | ConvertFrom-Json
        }

        foreach ($item in $import) {
            if ($item.MemberType -match '^Code') {
                Write-Warning 'Skipping Code related member'
            }
            if ($item.MemberType -match '^Script') {
                Write-Debug "[$((Get-Date).TimeOfDay) PROCESS] Creating scriptblock from value"
                $value = [scriptblock]::create($item.value)
            }
            else {
                $value = $item.Value
            }

            if ($Preview) {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Previewing $($item.MemberType) $($item.MemberName) for type $($item.TypeName)"
                $list.Add(
                    [PSCustomObject]@{
                        PSTypeName = 'PSTypeExtensionPreview'
                        TypeName   = $item.TypeName
                        MemberType = $item.MemberType
                        MemberName = $item.MemberName
                        Value      = $value
                        Source     = $Path
                    })
            }
            else {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing $($item.MemberType) : $($item.MemberName)"
                #add a custom -WhatIf message
                if ($PSCmdlet.ShouldProcess($Item.TypeName, "Adding $($item.MemberType) $($item.MemberName)")) {
                    #implement the change
                    Update-TypeData -TypeName $item.TypeName -MemberType $item.MemberType -MemberName $item.MemberName -Value $value -Force
                }
            }
        } #foreach
    }
    End {
        If ($Preview) {
            #sort the preview list for better formatting results
            $list | Sort-Object TypeName, MemberType, MemberName
        }
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending: $($MyInvocation.MyCommand)"
    }

} #end Import-PSTypeExtension
