Function Export-PSTypeExtension {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "Object")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "The type name to export like System.IO.FileInfo",
            ParameterSetName = "Name"
        )]
        [ValidateNotNullOrEmpty()]
        [String]$TypeName,

        [Parameter(
            Mandatory,
            HelpMessage = "The type extension name",
            ParameterSetName = "Name"
        )]
        [ValidateNotNullOrEmpty()]
        [string[]]$MemberName,

        [Parameter(
            Mandatory,
            HelpMessage = "The name of the export file. The extension must be .json,.xml or .ps1xml"
        )]
        [ValidatePattern("\.(xml|json|ps1xml)$")]
        [String]$Path,

        [Parameter(ParameterSetName = "Object", ValueFromPipeline)]
        [object]$InputObject,

        [Switch]$PassThru
    )
    DynamicParam {
        #create a dynamic parameter to append to .ps1xml files.
        if ($Path -match '\.ps1xml$') {

            #define a parameter attribute object
            $attributes = New-Object System.Management.Automation.ParameterAttribute
            $attributes.HelpMessage = "Append to an existing .ps1xml file"

            #define a collection for attributes
            $attributeCollection = New-Object -Type System.Collections.ObjectModel.Collection[System.Attribute]
            $attributeCollection.Add($attributes)

            #define the dynamic param
            $dynParam1 = New-Object -Type System.Management.Automation.RuntimeDefinedParameter("Append", [Switch], $attributeCollection)

            #create array of dynamic parameters
            $paramDictionary = New-Object -Type System.Management.Automation.RuntimeDefinedParameterDictionary
            $paramDictionary.Add("Append", $dynParam1)
            #use the array
            return $paramDictionary

        } #if
    } #dynamic parameter

    Begin {
        Write-Verbose "Starting: $($MyInvocation.MyCommand)"
        Write-Verbose "Detected parameter set $($PSCmdlet.ParameterSetName)"
        $PathParent = Split-Path -Path $Path

        if (Test-Path -Path $PathParent) {
            $validPath = $true
        }
        else {
            Write-Warning "Can't find parent path $pathParent"
            $validPath = $False
        }

        #test if appending
        if ($append -AND (Test-Path $Path)) {
            $validPath = $true
        }
        elseif ($append) {
            Write-Warning "Can't find $path for appending."
            $validPath = $False
        }

        #initialize a list of objects
        $data = [System.Collections.Generic.list[object]]::new()

        if ($TypeName) {
            Write-Verbose "Converting $TypeName to properly cased type name."
            $TypeName = _convertTypeName $TypeName
        }
    }
    Process {
        #test if parent path exists
        If ($validPath) {
            if ($InputObject) {
                Write-Verbose "Processing input type: $($InputObject.TypeName)"

                Write-Verbose "Converting $($InputObject.TypeName) to properly cased type name."
                $TypeName = _convertTypeName $InputObject.TypeName

                $data.Add($InputObject)
            }
            else {
                Write-Verbose "Processing type: $TypeName"
                foreach ($member in $MemberName) {
                    $TypeMember = Get-PSTypeExtension -TypeName $TypeName -Members $Member
                    $data.Add($TypeMember)
                }
            }
        } #test path parent
    }
    End {
        if ($validPath) {
            Write-Verbose "Exporting data to $path"

            if ($Path -match "\.ps1xml$") {
                if ($PSBoundParameters["Append"]) {
                    $cPath = Convert-Path $path
                    Write-Verbose "Appending to $cPath"

                    [xml]$doc = Get-Content $cPath
                    $members = $doc.types.SelectNodes("Type[Name='$TypeName']").Members

                    if ($members) {
                        Write-Verbose "Appending to existing TypeName entry"
                    }
                    else {
                        Write-Verbose "Creating a new TypeName entry for $TypeName"
                        $main = $doc.CreateNode("element", "Type", $null)
                        $tName = $doc.CreateElement("Name")
                        $tName.InnerText = $TypeName
                        [void]($main.AppendChild($tName))
                        $members = $doc.CreateNode("element", "Members", $null)
                        $IsNewType = $True
                    }

                    foreach ($extension in $data) {
                        Write-Verbose "Exporting $($extension.MemberName)"
                        $MemberType = $doc.createNode("element", $extension.MemberType, $null)
                        $MemberNameEL = $doc.CreateElement("Name")

                        $MemberNameEL.InnerText = $extension.MemberName
                        [void]($MemberType.AppendChild($MemberNameEL))

                        Switch ($extension.MemberType) {
                            "ScriptMethod" {
                                $MemberDef = $doc.CreateElement("Script")
                            }
                            "ScriptProperty" {
                                $MemberDef = $doc.CreateElement("GetScriptBlock")
                            }
                            "AliasProperty" {
                                $MemberDef = $doc.CreateElement("ReferencedMemberName")
                            }
                            "NoteProperty" {
                                $MemberDef = $doc.CreateElement("Value")
                            }
                            Default {
                                Throw "Can't process a type of $($extension.MemberType)"
                            }
                        } #switch MemberType

                        $MemberDef.InnerText = $extension.value
                        [void]($MemberType.AppendChild($MemberDef))
                        [void]($members.AppendChild($MemberType))

                    } #foreach extension

                    if ($IsnewType) {
                        Write-Verbose "Appending new type"
                        [void]($main.AppendChild($members))
                        [void]($doc.types.AppendChild($main))
                    }

                    if ($PSCmdlet.ShouldProcess($cPath)) {
                        $doc.save($cPath)
                    } #end WhatIf

                } #if append

                else {
                    Write-Verbose "Saving as new PS1XML"
                    #create a placeholder file so that I can later convert the path
                    [void](New-Item -Path $path -Force)
                    [xml]$Doc = New-Object System.Xml.XmlDocument

                    #create declaration
                    $dec = $Doc.CreateXmlDeclaration("1.0", "UTF-8", $null)
                    #append to document
                    [void]($doc.AppendChild($dec))

                    #create a comment and append it in one line
                    $text = @"

This file was created with Export-PSTypeExtenstion from the
PSTypeExtensionTools module which you can install from
the PowerShell Gallery.

Use Update-TypeData to import this file in your PowerShell session.

Created $(Get-Date)

"@
                    [void]($doc.AppendChild($doc.CreateComment($text)))

                    #create root Node
                    $root = $doc.CreateNode("element", "Types", $null)
                    $main = $doc.CreateNode("element", "Type", $null)
                    $name = $doc.CreateElement("Name")
                    $name.InnerText = $data[0].TypeName
                    [void]($main.AppendChild($name))
                    $members = $doc.CreateNode("element", "Members", $null)
                    foreach ($extension in $data) {
                        Write-Verbose "Exporting $($extension.MemberName)"
                        $MemberType = $doc.createNode("element", $extension.MemberType, $null)
                        $MemberNameEL = $doc.CreateElement("Name")

                        $MemberNameEL.InnerText = $extension.MemberName
                        [void]($MemberType.AppendChild($MemberNameEL))

                        Switch ($extension.MemberType) {
                            "ScriptMethod" {
                                $MemberDef = $doc.CreateElement("Script")
                            }
                            "ScriptProperty" {
                                $MemberDef = $doc.CreateElement("GetScriptBlock")
                            }
                            "AliasProperty" {
                                $MemberDef = $doc.CreateElement("ReferencedMemberName")
                            }
                            "NoteProperty" {
                                $MemberDef = $doc.CreateElement("Value")
                            }
                            Default {
                                Throw "Can't process a type of $($extension.MemberType)"
                            }
                        }
                        $MemberDef.InnerText = $extension.value
                        [void]($MemberType.AppendChild($MemberDef))
                        [void]($members.AppendChild($MemberType))

                    } #foreach extension
                    [void]($main.AppendChild($members))
                    [void]($root.AppendChild($main))
                    [void]($doc.AppendChild($root))
                    $out = Convert-Path $path
                    if ($PSCmdlet.ShouldProcess($out)) {
                        $doc.save($out)
                    } #end WhatIf
                } #else
            } #if ps1xml
            elseif ($path -match "\.xml$") {
                Write-Verbose "Saving as XML"
                $data | Export-Clixml -Path $path
            }
            else {
                Write-Verbose "Saving as JSON"
                $data | ConvertTo-Json | Set-Content -Path $Path
            }
        } #if valid path

        if ($PassThru) {
            Get-Item -Path $Path
        }
        Write-Verbose "Ending: $($MyInvocation.MyCommand)"
    }

} #end Export-PSTypeExtension
