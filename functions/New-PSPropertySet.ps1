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

        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Set typename $typename to proper case"
        $TypeName = _convertTypeName $TypeName

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