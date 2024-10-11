Function New-PSPropertySet {
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = "new")]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Enter the object TypeName.")]
        [ValidateNotNullOrEmpty()]
        [String]$TypeName,
        [Parameter(Mandatory, HelpMessage = "Enter the new property set name. It should be alphanumeric.")]
        [ValidatePattern("^\w+$")]
        [String]$Name,
        [Parameter(Mandatory, HelpMessage = "Enter the existing property names or aliases to belong to this property set.")]
        [ValidateNotNullOrEmpty()]
        [string[]]$Properties,
        [Parameter(Mandatory, HelpMessage = "Enter the name of the .ps1xml file to create.")]
        [ValidatePattern("\.ps1xml$")]
        [String]$FilePath,
        [Parameter(HelpMessage = "Append to an existing file.", ParameterSetName = "append")]
        [Switch]$Append,
        [Parameter(HelpMessage = "Don't overwrite an existing file.", ParameterSetName = "new")]
        [Switch]$NoClobber
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"

        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Set TypeName $TypeName to proper case"
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
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Creating a property set called $Name for $TypeName"
        #convert file path to a true file system path.
        $cPath = Join-Path -Path (Convert-Path (Split-Path $filepath)) -ChildPath (Split-Path $FilePath -Leaf)
        if ($Append -AND (-Not (Test-Path $FilePath))) {
            Write-Warning "Failed to find $Filepath for appending."
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Ending $($MyInvocation.MyCommand)"
            #bail out
            return
        }
        elseif ($Append) {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Appending to $filepath"
            [xml]$doc = Get-Content $cPath
            $members = $doc.types.SelectNodes("Type[Name='$TypeName']").Members

            if ($members) {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Appending to existing TypeName entry"
            }
            else {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Creating a new TypeName entry"
                $newType = $doc.CreateNode("element", "Type", $null)
                $tName = $doc.CreateElement("Name")
                $tName.InnerText = $TypeName
                [void]($newType.AppendChild($tName))
                $members = $doc.CreateNode("element", "Members", $null)
                $IsNewType = $True
            }

            $propSet = $doc.CreateNode("element", "PropertySet", $null)
            $eName = $doc.CreateElement("Name")
            $eName.InnerText = $Name
            [void]($propSet.AppendChild($eName))
            $ref = $doc.CreateNode("element", "ReferencedProperties", $null)
            foreach ($item in $properties) {
                $prop = $doc.CreateElement("Name")
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Adding property $item"
                $prop.InnerText = $item
                [void]($ref.AppendChild($prop))
            }
            [void]($propSet.AppendChild($ref))
            [void]($members.AppendChild($propSet))

            if ($IsNewType) {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Appending new type"
                [void]($newType.AppendChild($members))
                [void]($doc.types.AppendChild($newType))
            }

        } #else append
        else {
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Creating a new XML document"
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
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Defining type as $TypeName"
            $doc.WriteElementString("Name", $TypeName)

            $doc.WriteStartElement("Members")
            $doc.WriteStartElement("PropertySet")
            #the property set name
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Defining property set name $Name"
            $doc.WriteElementString("Name", $Name)

            $doc.WriteStartElement("ReferencedProperties")
            foreach ($item in $properties) {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Adding property $item"
                $doc.WriteElementString("Name", $item)
            }

            #end type
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Closing and saving file."
            $doc.WriteEndElement()
            $doc.WriteEndDocument()
            $doc.Close()
            $doc.Dispose()
        }

        if ($PSCmdlet.ShouldProcess($cPath)) {
            if ((-Not $Append) -AND (Test-Path $tmpFile)) {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Copying temp file to $cPath"

                if ($NoClobber -AND (Test-Path $cPath)) {
                    Write-Warning "The file $cPath exists and NoClobber was specified."
                }
                else {
                    Copy-Item -Path $tmpFile -Destination $cPath
                }

                #always clean up the temp file
                Remove-Item -Path $tmpFile -WhatIf:$false -ErrorAction SilentlyContinue
            }
            else {
                Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Saving to $cPath"
                $doc.Save($cPath)
            }
        }
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"
    } #end

} #close New-PSPropertySet
