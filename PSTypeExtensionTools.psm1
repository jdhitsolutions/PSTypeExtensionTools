

Function Get-PSTypeExtension {
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Enter the name of type like System.IO.FileInfo",
            ValueFromPipelineByPropertyName, ValueFromPipeline)]
        [ValidateNotNullorEmpty()]
        [ValidateScript( {
                #check if typename can be found with Get-TypeData
                if ((get-typedata).typename -contains "$_") {
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
        [Parameter(HelpMessage = "Enter a comma separated list of member names", ParameterSetName = "members")]
        [string[]]$Members
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
                                MemberType = "ScriptProperty"
                                MemberName = $member.name  
                                Value      = $code
                            }
                        } #scriptproperty
                        "ScriptMethodData" {
                            $def = [pscustomobject]@{
                                MemberType = "ScriptMethod"
                                MemberName = $member.name  
                                Value      = $member.script.ToString().trim()
                            }
                        } #scriptmethod
                        "NotePropertyData" {
                            $def = [pscustomobject]@{
                                MemberType = "Noteproperty"
                                MemberName = $member.name
                                Value      = $member.Value
                            }
                        } #noteproperty
                        "CodePropertyData" {
                            if ($member.GetCodeReference) {
                                $code = $member.GetCodeReference.ToString()
                            }
                            else {
                                $code = $member.SetCodeReference.ToString()
                            }
                            $def = [pscustomobject]@{
                                MemberType = "CodeProperty"
                                MemberName = $member.name
                                Value      = $code
                            }
                        } #codeproperty
                        Default {
                            Write-Warning "Cannot process $datatype type for $($typedata.typename)."
                            $def = [pscustomobject]@{
                                MemberType = $datatype
                                MemberName = $member.name
                                Value      = $member.Value
                            }
                        }
                    }
            
                    $def | Add-Member -MemberType NoteProperty -Name TypeName -Value $typedata.typename
                    #insert a typename
                    $def.psobject.typenames.insert(0, 'PSTypeExtension')
                    #write the definition to the pipeline
                    Write-Output $def

                }
                Catch {
                    Write-Warning "Could not find an extension member called $name"
                    write-Debug $_.exception.message
                }
            
            } #foreach
        
        }
        else {
            Write-Warning "Failed to find any type extensions for [$Typename]."
        }
        Write-Verbose "Ending: $($MyInvocation.Mycommand)"
    }

} #end Get-PSTypeExtension

Function Get-PSType {
    [cmdletbinding()]
    Param(
        [Parameter(Position = 0, Mandatory, ValueFromPipeline)]
        [object]$Inputobject
    )

    Begin {
        Write-Verbose "Starting: $($MyInvocation.Mycommand)"
        $data = @()
    }
    Process {
        #get the type of each pipelined object
        $data += ($Inputobject | Get-Member | select-object -first 1).typename
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
        [Parameter(Position = 0, Mandatory, HelpMessage = "The type name to export like System.IO.FileInfo", ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string]$TypeName,
        [Parameter(Mandatory, HelpMessage = "The type extension name", ParameterSetName = "Name")]
        [ValidateNotNullOrEmpty()]
        [string[]]$MemberName,
        [Parameter(Mandatory, HelpMessage = "The name of the export file. The extension must be .json,.xml or .ps1xml")]
        [ValidatePattern("\.(xml|json|ps1xml)$")]
        [string]$Path,
        [Parameter(ParameterSetName = "object", ValueFromPipeline)]  
        [object]$InputObject
    )
    Begin {
        Write-Verbose "Starting: $($MyInvocation.Mycommand)"
        $data = @()
    }
    Process {
        if ($Inputobject) {
            Write-Verbose "Processing input type: $($InputObject.TypeName)"
            $data += $Inputobject
        }
        else {
            Write-Verbose "Processing type: $TypeName"
            foreach ($member in $membername) {
                $data += Get-PSTypeExtension -TypeName $Typename -Members $Member
            }
        }   
    }
    End {
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
            $main.AppendChild($name) | out-null
            $member = $doc.CreateNode("element", "Members", $null)
            foreach ($extension in $data) {        
                Write-Verbose "Exporting $($extension.membername)"
                $membertype = $doc.createNode("element", $extension.memberType, $null)
                $membernameEL = $doc.CreateElement("Name")

                $membernameEL.innertext = $extension.memberName
                $membertype.AppendChild($membernameEL) | out-null

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
                $membertype.AppendChild($memberdef)| out-null
                $member.AppendChild($membertype) | out-null
        
            } #foreach
            $main.AppendChild($member) | out-null
            $root.AppendChild($main) | Out-Null
            $doc.AppendChild($root) | out-null
            $out = Convert-Path $path
            if ($PSCmdlet.ShouldProcess($out)) {
                $doc.save($out)
            } #end Whatif
        }
        elseif ($path -match "\.xml$") {
            Write-Verbose "Saving as XML"
            $data | Export-Clixml -path $path
        }
        else {
            Write-Verbose "Saving as JSON"
            $data | ConvertTo-Json | Set-Content -Path $Path
        }

        Write-Verbose "Exporting data to $path"
        Write-Verbose "Ending: $($MyInvocation.Mycommand)"
    }
    
} #end Export-PSTypeExtension

Function Import-PSTypeExtension {
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(Mandatory,
            ValueFromPipeline,
            HelpMessage = "The name of the imported file. The extension must be .xml or .json")]
        [ValidatePattern("\.(xml|json)$")]
        [ValidateScript( {Test-Path $(Convert-Path $_)})]
        [string]$Path
    )

    Begin {
        Write-Verbose "Starting: $($myInvocation.mycommand)"
    }
    Process {
        Write-Verbose "Importing file $(Convert-path $Path)"
        if ($path -match "\.xml$") {
            #xml format seems to add an extra entry
            $import = Import-clixml -Path $path | Where-Object MemberType    
        }
        else {
            $import = Get-Content -path $path | ConvertFrom-Json
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
                Update-TypeData -TypeName $item.Typename -MemberType $item.MemberType -MemberName $item.MemberName -value $value -force
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
        [Parameter(Position = 0, Mandatory, 
            ValueFromPipeline,
            HelpMessage = "Enter the name of a type like system.io.fileinfo")]
        [string]$TypeName,
        [Parameter(Mandatory, HelpMessage = "The member type")]
        [ValidateSet("AliasProperty", "Noteproperty", "ScriptProperty", "ScriptMethod")]
        [string]$MemberType,
        [Parameter(Mandatory, HelpMessage = "The name of your type extension")]
        [ValidateNotNullOrEmpty()]
        [string]$MemberName,
        [Parameter(Mandatory, HelpMessage = "The value for your type extension. Remember to enclose scriptblocks in {} and use `$this")]
        [ValidateNotNullOrEmpty()]
        [Object]$Value

    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"

    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Adding $MemberType $Membername to $TypeName"
        #force overwrite of existing extensions
        $PSBoundParameters.Add("Force", $True)
        Update-TypeData @PSBoundParameters
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"

    } #end 

} #close Add-MyTypeExtension

#Export the Samples folder location as a variable

$PSTypeSamples = "$PSScriptRoot\samples"

Export-ModuleMember -Variable PSTypeSamples -function 'Get-PSTypeExtension', 'Get-PSType','Import-PSTypeExtension','Export-PSTypeExtension','Add-PSTypeExtension' -Alias 'Set-PSTypeExtension'