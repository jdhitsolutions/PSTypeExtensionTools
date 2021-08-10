Function Export-PSTypeExtension {
    [cmdletbinding(SupportsShouldProcess, DefaultParameterSetName = "Object")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "The type name to export like System.IO.FileInfo",
            ParameterSetName = "Name"
        )]
        [ValidateNotNullOrEmpty()]
        [string]$TypeName,

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
        [string]$Path,

        [Parameter(ParameterSetName = "Object", ValueFromPipeline)]
        [object]$InputObject,

        [switch]$Passthru
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
        Write-Verbose "Starting: $($MyInvocation.Mycommand)"
        Write-Verbose "Detected parameter set $($pscmdlet.ParameterSetName)"
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
            Write-Verbose "Converting $typename to properly cased type name."
            $TypeName = _convertTypeName $TypeName
        }
    }
    Process {
        #test if parent path exists
        If ($validPath) {
            if ($Inputobject) {
                Write-Verbose "Processing input type: $($InputObject.TypeName)"

                Write-Verbose "Converting $($InputObject.typename) to properly cased type name."
                $TypeName = _convertTypeName $InputObject.TypeName

                $data.Add($InputObject)
            }
            else {
                Write-Verbose "Processing type: $TypeName"
                foreach ($member in $membername) {
                    $typemember = Get-PSTypeExtension -TypeName $Typename -Members $Member
                    $data.Add($typemember)
                }
            }
        } #test path parent
    }
    End {
        if ($validPath) {
            Write-Verbose "Exporting data to $path"

            if ($Path -match "\.ps1xml$") {

                if ($PSBoundParameters["Append"]) {
                    $cpath = Convert-Path $path
                    Write-Verbose "Appending to $cpath"

                    [xml]$doc = Get-Content $cPath
                    $members = $doc.types.SelectNodes("Type[Name='$typeName']").Members

                    if ($members) {
                        Write-Verbose "Appending to existing typename entry"
                    }
                    else {
                        Write-Verbose "Creating a new typename entry for $TypeName"
                        $main = $doc.CreateNode("element", "Type", $null)
                        $tName = $doc.CreateElement("Name")
                        $tName.InnerText = $typename
                        [void]($main.AppendChild($tname))
                        $members = $doc.CreateNode("element", "Members", $null)
                        $IsNewType = $True
                    }

                    foreach ($extension in $data) {
                        Write-Verbose "Exporting $($extension.membername)"
                        $membertype = $doc.createNode("element", $extension.memberType, $null)
                        $membernameEL = $doc.CreateElement("Name")

                        $membernameEL.innertext = $extension.memberName
                        [void]($membertype.AppendChild($membernameEL))

                        Switch ($extension.Membertype) {
                            "ScriptMethod" {
                                $memberdef = $doc.createelement("Script")
                            }
                            "ScriptProperty" {
                                $memberdef = $doc.createelement("GetScriptBlock")
                            }
                            "AliasProperty" {
                                $memberdef = $doc.createelement("ReferencedMemberName")
                            }
                            "NoteProperty" {
                                $memberdef = $doc.createelement("Value")
                            }
                            Default {
                                Throw "Can't process a type of $($extension.MemberType)"
                            }
                        } #switch membertype

                        $memberdef.InnerText = $extension.value
                        [void]($membertype.AppendChild($memberdef))
                        [void]($members.AppendChild($membertype))

                    } #foreach extension

                    if ($IsnewType) {
                        Write-Verbose "Appending new type"
                        [void]($main.AppendChild($members))
                        [void]($doc.types.AppendChild($main))
                    }

                    if ($PSCmdlet.ShouldProcess($cpath)) {
                        $doc.save($cpath)
                    } #end Whatif

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
                    $name.innerText = $data[0].TypeName
                    [void]($main.AppendChild($name))
                    $members = $doc.CreateNode("element", "Members", $null)
                    foreach ($extension in $data) {
                        Write-Verbose "Exporting $($extension.membername)"
                        $membertype = $doc.createNode("element", $extension.memberType, $null)
                        $membernameEL = $doc.CreateElement("Name")

                        $membernameEL.innertext = $extension.memberName
                        [void]($membertype.AppendChild($membernameEL))

                        Switch ($extension.Membertype) {
                            "ScriptMethod" {
                                $memberdef = $doc.createelement("Script")
                            }
                            "ScriptProperty" {
                                $memberdef = $doc.createelement("GetScriptBlock")
                            }
                            "AliasProperty" {
                                $memberdef = $doc.createelement("ReferencedMemberName")
                            }
                            "NoteProperty" {
                                $memberdef = $doc.createelement("Value")
                            }
                            Default {
                                Throw "Can't process a type of $($extension.MemberType)"
                            }
                        }
                        $memberdef.InnerText = $extension.value
                        [void]($membertype.AppendChild($memberdef))
                        [void]($members.AppendChild($membertype))

                    } #foreach extension
                    [void]($main.AppendChild($members))
                    [void]($root.AppendChild($main))
                    [void]($doc.AppendChild($root))
                    $out = Convert-Path $path
                    if ($PSCmdlet.ShouldProcess($out)) {
                        $doc.save($out)
                    } #end Whatif
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

        if ($Passthru) {
            Get-Item -Path $Path
        }
        Write-Verbose "Ending: $($MyInvocation.Mycommand)"
    }

} #end Export-PSTypeExtension
