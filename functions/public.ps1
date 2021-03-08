
Function Get-PSTypeExtension {
    [cmdletbinding()]
    [outputtype("PSTypeExtension")]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = "Enter the name of type like System.IO.FileInfo",
            ValueFromPipelineByPropertyName,
            ValueFromPipeline
        )]
        [ValidateNotNullorEmpty()]
        [ValidateScript( {
                #check if typename can be found with Get-TypeData
                if ((Get-TypeData).typename -contains "$_") {
                    $True
                }
                elseif ($_ -as [type]) {
                    #test if string resolves as a typename
                    $True
                }
                else {
                    Throw "$_ does not appear to be a valid type."
                }
            })]
        [string]$TypeName,
        [Parameter(
            HelpMessage = "Enter a comma separated list of member names",
            ParameterSetName = "members"
        )]
        [string[]]$Members,
        [Parameter(HelpMessage = "Show CodeProperty custom properties")]
        [switch]$CodeProperty
    )

    Begin {
        Write-Verbose "Starting: $($MyInvocation.Mycommand)"
        $typedata = @()
    } #begin
    Process {
        Write-Verbose "Analyzing $typename"
        $typedata += Get-TypeData -TypeName $typename

    } #process
    End {
        $typedata = $typedata | Select-Object -Unique

        if ($typedata) {
            $out = [System.Collections.Generic.List[object]]::new()
            if (-Not $Members) {
                Write-Verbose "Getting all member names"
                $Members = $typedata.members.keys

            }
            foreach ($name in $Members) {
                Try {
                    Write-Verbose "Analyzing member $name"
                    $member = $typedata.members[$name]
                    $datatype = $member.gettype().name

                    Write-Verbose "Processing type $datatype"
                    Switch ($datatype) {
                        "AliasPropertyData" {
                            $def = [pscustomobject]@{
                                PSTypename = 'PSTypeExtension'
                                MemberType = "AliasProperty"
                                MemberName = $member.name
                                Value      = $member.ReferencedMemberName
                            }
                        } #alias
                        "ScriptpropertyData" {
                            if ($member.GetScriptBlock) {
                                $code = $member.GetScriptBlock.ToString()
                            }
                            else {
                                $code = $member.SetScriptBlock.ToString()
                            }
                            $def = [pscustomobject]@{
                                PSTypename = 'PSTypeExtension'
                                MemberType = "ScriptProperty"
                                MemberName = $member.name
                                Value      = $code
                            }
                        } #scriptproperty
                        "ScriptMethodData" {
                            $def = [pscustomobject]@{
                                PSTypename = 'PSTypeExtension'
                                MemberType = "ScriptMethod"
                                MemberName = $member.name
                                Value      = $member.script.ToString().trim()
                            }
                        } #scriptmethod
                        "NotePropertyData" {
                            $def = [pscustomobject]@{
                                PSTypename = 'PSTypeExtension'
                                MemberType = "Noteproperty"
                                MemberName = $member.name
                                Value      = $member.Value
                            }
                        } #noteproperty
                        "CodePropertyData" {
                            #only show these if requested with -CodeProperty
                            if ($CodeProperty) {
                                if ($member.GetCodeReference) {
                                    $code = $member.GetCodeReference.ToString()
                                }
                                else {
                                    $code = $member.SetCodeReference.ToString()
                                }
                                $def = [pscustomobject]@{
                                    PSTypename = 'PSTypeExtension'
                                    MemberType = "CodeProperty"
                                    MemberName = $member.name
                                    Value      = $code
                                }
                            }
                            else {
                                $def = $False
                            }
                        } #codeproperty
                        Default {
                            Write-Warning "Cannot process $datatype type for $($typedata.typename)."
                            $def = [pscustomobject]@{
                                PSTypename = 'PSTypeExtension'
                                MemberType = $datatype
                                MemberName = $member.name
                                Value      = $member.Value
                            }
                        }
                    }
                    if ($def) {
                        $out.Add($def)
                    }

                }
                Catch {
                    Write-Warning "Could not find an extension member called $name"
                    Write-Debug $_.exception.message
                }

            } #foreach
            #write sorted results
            $out | Sort-Object -Property MemberType, Name
        }
        else {
            Write-Warning "Failed to find any type extensions for [$Typename]."
        }
        Write-Verbose "Ending: $($MyInvocation.Mycommand)"
    }

} #end Get-PSTypeExtension

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

        [Parameter(ParameterSetName = "object", ValueFromPipeline)]
        [object]$InputObject
    )
    Begin {
        Write-Verbose "Starting: $($MyInvocation.Mycommand)"

        $PathParent = Split-Path -Path $Path
        if (Test-Path -Path $PathParent) {
            $validPath = $true
        }
        else {
            Write-Warning "Can't find parent path $pathParent"
            $validPath = $False
        }
        #initialize a list of objects
        $data = [System.Collections.Generic.list[object]]::new()
        #@()
    }
    Process {
        #test if parent path exists
        If ($validPath) {
            if ($Inputobject) {
                Write-Verbose "Processing input type: $($InputObject.TypeName)"
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
                Write-Verbose "Saving as PS1XML"
                #create a placeholder file so that I can later convert the path
                New-Item -Path $path -Force | Out-Null
                [xml]$Doc = New-Object System.Xml.XmlDocument

                #create declaration
                $dec = $Doc.CreateXmlDeclaration("1.0", "UTF-8", $null)
                #append to document
                $doc.AppendChild($dec) | Out-Null

                #create a comment and append it in one line
                $text = @"

Custom type extensions generated by $($env:username)
$(Get-Date)

"@
                $doc.AppendChild($doc.CreateComment($text)) | Out-Null

                #create root Node
                $root = $doc.CreateNode("element", "Types", $null)
                $main = $doc.CreateNode("element", "Type", $null)
                $name = $doc.CreateElement("Name")
                $name.innerText = $data[0].TypeName
                $main.AppendChild($name) | Out-Null
                $member = $doc.CreateNode("element", "Members", $null)
                foreach ($extension in $data) {
                    Write-Verbose "Exporting $($extension.membername)"
                    $membertype = $doc.createNode("element", $extension.memberType, $null)
                    $membernameEL = $doc.CreateElement("Name")

                    $membernameEL.innertext = $extension.memberName
                    $membertype.AppendChild($membernameEL) | Out-Null

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
                    $membertype.AppendChild($memberdef) | Out-Null
                    $member.AppendChild($membertype) | Out-Null

                } #foreach
                $main.AppendChild($member) | Out-Null
                $root.AppendChild($main) | Out-Null
                $doc.AppendChild($root) | Out-Null
                $out = Convert-Path $path
                if ($PSCmdlet.ShouldProcess($out)) {
                    $doc.save($out)
                } #end Whatif
            }
            elseif ($path -match "\.xml$") {
                Write-Verbose "Saving as XML"
                $data | Export-Clixml -Path $path
            }
            else {
                Write-Verbose "Saving as JSON"
                $data | ConvertTo-Json | Set-Content -Path $Path
            }
        }

        Write-Verbose "Ending: $($MyInvocation.Mycommand)"
    }

} #end Export-PSTypeExtension

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
        [alias("fullname")]
        [string]$Path
    )

    Begin {
        Write-Verbose "Starting: $($myInvocation.mycommand)"
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
            if ($PSCmdlet.ShouldProcess($Item.typename, "Adding $($item.membertype) $($item.MemberName)")) {
                #implement the change
                Update-TypeData -TypeName $item.Typename -MemberType $item.MemberType -MemberName $item.MemberName -Value $value -Force
            }
        } #foreach
    }
    End {
        Write-Verbose "Ending: $($myInvocation.mycommand)"
    }

} #end Import-PSTypeExtension

Function Add-PSTypeExtension {
    [cmdletbinding(SupportsShouldProcess)]
    [Alias('Set-PSTypeExtension')]

    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            HelpMessage = "Enter the name of a type like system.io.fileinfo")]
        [string]$TypeName,
        [Parameter(
            Mandatory,
            HelpMessage = "The member type"
        )]
        [ValidateSet("AliasProperty", "Noteproperty", "ScriptProperty", "ScriptMethod")]
        [alias("Type")]
        [string]$MemberType,
        [Parameter(
            Mandatory,
            HelpMessage = "The name of your type extension"
        )]
        [ValidateNotNullOrEmpty()]
        [alias("Name")]
        [string]$MemberName,
        [Parameter(
            Mandatory,
            HelpMessage = "The value for your type extension. Remember to enclose scriptblocks in {} and use `$this"
        )]
        [ValidateNotNullOrEmpty()]
        [Object]$Value,
        [Parameter(HelpMessage = "Create the extension in the deserialized version of the specified type including the original type.")]
        [switch]$IncludeDeserialized

    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"

    } #begin

    Process {
        #force overwrite of existing extensions
        $PSBoundParameters.Add("Force", $True)
        if ($PSBoundParameters.ContainsKey("IncludeDeserialized")) {
            [void]$PSBoundParameters.Remove("IncludeDeserialized")
            $PSBoundParameters.Typename = "deserialized.$Typename"
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Adding $MemberType $Membername to $($psboundparameters.TypeName)"
            Update-TypeData @PSBoundParameters
            $PSBoundParameters.Typename = $Typename
        }
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Adding $MemberType $Membername to $($psboundparameters.TypeName)"
        Update-TypeData @PSBoundParameters
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"

    } #end

} #close Add-MyTypeExtension

Function New-PSPropertySet {
    [cmdletbinding(SupportsShouldProcess, DefaultParameterSetName = "new")]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Enter the object typename.")]
        [ValidateNotNullOrEmpty()]
        [string]$Typename,
        [Parameter(Mandatory, HelpMessage = "Enter the new property set name. It should be alphanumeric.")]
        [ValidatePattern("^\w+$")]
        [string]$Name,
        [Parameter(Mandatory, HelpMessage = "Enter the existing property names or aliases to belong to this property set.")]
        [ValidateNotNullOrEmpty()]
        [string[]]$Properties,
        [Parameter(Mandatory, HelpMessage = "Enter the name of the .ps1xml file to create.")]
        [ValidatePattern("\.ps1xml$")]
        [string]$FilePath,
        [Parameter(HelpMessage = "Append to an existing file.", ParameterSetName = "append")]
        [switch]$Append,
        [Parameter(HelpMessage = "Don't overwrite an existing file.", ParameterSetName = "new")]
        [switch]$NoClobber
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
        $settings = [System.Xml.XmlWriterSettings]::new()
        $settings.Indent = $True

        $newComment = @"

This file was created with New-PSPropertySet from the
PSTypeExtensionTools module which you can install from
the PowerShell Gallery.

Use Update-TypeData to append this file in your PowerShell session.

Created $(Get-Date)

"@
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Creating a property set called $Name for $Typename"
        #convert file path to a true file system path.
        $cPath = Join-Path -Path (Convert-Path (Split-Path $filepath)) -ChildPath (Split-Path $FilePath -Leaf)
        if ($Append -AND (-Not (Test-Path $FilePath))) {
            Write-Warning "Failed to find $Filepath for appending."
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Ending $($myinvocation.mycommand)"
            #bail out
            return
        }
        elseif ($Append) {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Appending to $filepath"
            [xml]$doc = Get-Content $cPath
            $members = $doc.types.SelectNodes("Type[Name='$typeName']").Members

            if ($members) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Appending to existing typename entry"
            }
            else {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Creating a new typename entry"
                $newType = $doc.CreateNode("element", "Type", $null)
                $tName = $doc.CreateElement("Name")
                $tName.InnerText = $typename
                [void]($newType.AppendChild($tname))
                $members = $doc.CreateNode("element", "Members", $null)
                $IsNewType = $True
            }

            $propSet = $doc.CreateNode("element", "PropertySet", $null)
            $eName = $doc.CreateElement("Name")
            $eName.InnerText = $Name
            [void]($propset.AppendChild($eName))
            $ref = $doc.CreateNode("element", "ReferencedProperties", $null)
            foreach ($item in $properties) {
                $prop = $doc.CreateElement("Name")
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Adding property $item"
                $prop.InnerText = $item
                [void]($ref.AppendChild($prop))
            }
            [void]($propset.AppendChild($ref))
            [void]($members.AppendChild($propset))

            if ($IsnewType) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Appending new type"
                [void]($newType.AppendChild($members))
                [void]($doc.types.AppendChild($newtype))
            }

        } #else append
        else {
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Creating a new XML document"
            <#
            use a random temp name to create the xml file. At the end of the process copy the temp file
            to the specified file path. This makes it possible to use -WhatIf
            #>
            $tmpFile = [System.IO.Path]::GetTempFileName()
            $doc = [System.Xml.XmlWriter]::Create($tmpFile, $settings)
            $doc.WriteStartDocument()
            $doc.WriteWhitespace("`n")
            $doc.WriteComment($newComment)
            $doc.WriteWhitespace("`n")
            $doc.WriteStartElement("Types")

            $doc.WriteStartElement("Type")
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Defining type as $Typename"
            $doc.WriteElementString("Name", $TypeName)

            $doc.WriteStartElement("Members")
            $doc.WriteStartElement("PropertySet")
            #the property set name
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Defining property set name $Name"
            $doc.WriteElementString("Name", $Name)

            $doc.WriteStartElement("ReferencedProperties")
            foreach ($item in $properties) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Adding property $item"
                $doc.WriteElementString("Name", $item)
            }

            #end type
            Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Closing and saving file."
            $doc.WriteEndElement()
            $doc.WriteEndDocument()
            $doc.Close()
            $doc.Dispose()
        }

        if ($PSCmdlet.ShouldProcess($cpath)) {
            if ((-Not $Append) -AND (Test-Path $tmpFile)) {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Copying temp file to $cpath"

                if ($NoClobber -AND (Test-Path $cpath)) {
                    Write-Warning "The file $cpath exists and NoClobber was specified."
                }
                else {
                    Copy-Item -Path $tmpFile -Destination $cpath
                }

                #always clean up the temp file
                Remove-Item -Path $tmpFile -WhatIf:$false -ErrorAction SilentlyContinue
            }
            else {
                Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Saving to $cpath"
                $doc.Save($cpath)
            }
        }

    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"
    } #end

} #close New-PSPropertySet