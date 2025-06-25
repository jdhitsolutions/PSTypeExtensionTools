#preview settings from a ps1xml file

#TODO: process multiple types in the same ps1xml file
Function Get-PSTypeDataPreview {
    [cmdletbinding()]
    [OutputType('PSTypeUpdatePreview')]
    Param(
        [Parameter(
            Position = 0,
            ValueFromPipeline,
            HelpMessage = 'Specify the path to the ps1xml file containing the type extension setting you will import using Update-TypeData.'
        )]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({ Test-Path $_ })]
        [ValidatePattern('^.+\.ps1xml$')]
        [ArgumentCompleter({
                param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
                Get-ChildItem -Path $wordToComplete -Filter '*.ps1xml' -ErrorAction Ignore | ForEach-Object { $_.FullName }
            })]
        [string]$Path
    )

    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Running under PowerShell version $($PSVersionTable.PSVersion)"
    } #begin

    Process {
        $Path = Convert-Path $Path
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing $Path"
        Try {
            #Assuming one type per file
            [xml]$typeData = Get-Content -Path $Path -ErrorAction Stop
        }
        Catch {
            $_
            return
        }
        if ($typeData) {
            Foreach ($data in $typeData.Types.Type) {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Processing type $($data.Types.Type.Name)"

            $typeName = $data.Name

            If ($data.Members.AliasProperty) {
                $alias = $data.Members.AliasProperty |
                ForEach-Object {
                    [PSCustomObject]@{
                        Name      = $_.Name
                        Reference = $_.ReferencedMemberName
                    }
                }
            }
            If ($data.Members.NoteProperty) {
                $note = $data.Members.NoteProperty |
                ForEach-Object {
                    [PSCustomObject]@{
                        Name  = $_.Name
                        Value = $_.Value
                    }
                }
            }
            if ($data.Members.ScriptProperty) {
                $scriptProperty = $data.Members.ScriptProperty |
                ForEach-Object {
                    [PSCustomObject]@{
                        Name = $_.Name
                        Get  = $_.GetScriptBlock
                        Set  = $_.SetScriptBlock
                    }
                }
            }
            if ($data.Members.PropertySet) {
                $propertySet = $data.Members.PropertySet |
                ForEach-Object {
                    [PSCustomObject]@{
                        Name       = $_.Name
                        Properties = $_.ReferencedProperties.Name
                    }
                }
            }

            [PSCustomObject]@{
                PSTypeName     = 'PSTypeUpdatePreview'
                TypeName       = $typeName
                AliasProperty  = $alias
                NoteProperty   = $note
                ScriptProperty = $scriptProperty
                PropertySet    = $propertySet
                Path           = $Path
            }
} #foreach data
        } #if typeDate
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end
}
