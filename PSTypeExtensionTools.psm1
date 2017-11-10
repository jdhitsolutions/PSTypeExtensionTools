#requires -version 5.0


Function Get-MyTypeExtension {
    [cmdletbinding(DefaultParameterSetName = "members")]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage = "Enter the name of type like System.IO.FileInfo",
            ValueFromPipelineByPropertyName,ValueFromPipeline)]
        [ValidateNotNullorEmpty()]
        [string]$TypeName,
        [Parameter(Mandatory, HelpMessage = "Enter a comma separated list of member names", ParameterSetName = "members")]
        [ValidateNotNullorEmpty()]
        [string[]]$Members,
        [Parameter(ParameterSetName = "all")]
        [switch]$All
    )
    
    Begin {
        Write-Verbose "Starting: $($MyInvocation.Mycommand)"
    }
    Process {
        $typedata = Get-TypeData -TypeName $typename
    
        if ($typedata) {
    
            if ($all) {
                Write-Verbose "Getting all member names"
                $Members = $typedata.members.keys
    
            }
            foreach ($name in $Members) {
                Try {
                    Write-Verbose "Analyzing member $name"
                    $member = $typedata.members[$name]
                    $datatype = $member.gettype().name
        
                    write-verbose "Processing type $datatype"
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
                            Write-Warning "Cannot process $datatype type"
                            $def = [pscustomobject]@{
                                MemberType = $datatype
                                MemberName = $member.name
                                Value      = $member.Value
                            }
                        }
                    }
            
                    #$obj.Definitions+=$def
                    $def | Add-Member -MemberType NoteProperty -Name TypeName -Value $typedata.typename
                    $def
                }
                Catch {
                    Write-Warning "Could not find an extension member called $name"
                    write-Debug $_.exception.message
                }
            
            } #foreach
        
            Write-Output $obj
        }
        else {
            Write-Warning "Failed to find type $Typename or no extensions are defined."
        }
    }
    End {  
        Write-Verbose "Ending: $($MyInvocation.Mycommand)"
    }

} #end Get-MyTypeExtension

Function Get-PSType {
    [cmdletbinding()]
    Param(
    [Parameter(Position = 0,Mandatory,ValueFromPipeline)]
    [object]$Inputobject
    )

    Begin {
        Write-Verbose "Starting: $($MyInvocation.Mycommand)"
        $data = @()
    }
    Process {
        #get the type of each pipelined object
        $data+= $Inputobject.GetType().Fullname
    }
    End {
        #write unique values to the pipeline
        $data | Get-Unique
        Write-Verbose "Ending: $($MyInvocation.Mycommand)"
    }
} #end Get-PSType

Function Export-MyTypeExtension {
[cmdletbinding(DefaultParameterSetName="name")]
Param(
    [Parameter(Position = 0, Mandatory,
    HelpMessage = "The type name to export like System.IO.FileInfo",
    ParameterSetName = "name")]
    [ValidateNotNullOrEmpty()]
    [string]$TypeName,
    [Parameter(Mandatory,HelpMessage="The type extension name", 
    ParameterSetName = "name")]
    [ValidateNotNullOrEmpty()]
    [string[]]$MemberName,
    [Parameter(ParameterSetName="input",ValueFromPipeline)]
    #It is assumed the inputobject comes from Get-MyTypeExtension
    [object]$InputObject,
    [Parameter(Mandatory,HelpMessage = "The name of the exported file. The extension must be .xml or .json")]
    [ValidatePattern("\.(xml|json)$")]
    [string]$Path
)
Begin {
    Write-Verbose "Starting: $($MyInvocation.Mycommand)"
    $data = @()
}
Process {
    if ($PSCmdlet.ParameterSetName -eq 'input') {
        Write-Verbose "Using input for type $($inputobject.Typename)"
        $data+=$inputobject
    }
    else {
        Write-Verbose "Processing type: $TypeName"
        $data+= Get-MyTypeExtension -TypeName $Typename -Members $MemberName 
    }
}
End {
    Write-Verbose "Exporting data to $path"
    if ($path -match "xml$") {
        $data | Export-Clixml -path $path
    }
    else {
        $data | ConvertTo-Json | Set-Content -Path $Path
    }
    Write-Verbose "Ending: $($MyInvocation.Mycommand)"
}

} #end Export-MyTypeExtension

Function Import-MyTypeExtension {
    [CmdletBinding(SupportsShouldProcess)]
    Param(
    [Parameter(Mandatory,HelpMessage = "The name of the imported file. The extension must be .xml or .json")]
    [ValidatePattern("\.(xml|json)$")]
    [ValidateScript({Test-Path $_})]
    [string]$Path
    )

    Write-Verbose "Starting: $($myInvocation.mycommand)"
    if ($path -match "\.xml$") {
        #xml format seems to add an extra entry
        $import = Import-clixml -Path $path | Where MemberType    
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

    Write-Verbose "Ending: $($myInvocation.mycommand)"
} #end Import-MyTypeExtension

Function Add-MyTypeExtension {
    [cmdletbinding(SupportsShouldProcess)]
    Param(
        [Parameter(Position = 0, Mandatory, HelpMessage= "Enter the name of a type like system.io.fileinfo")]
        [string]$TypeName,
        [Parameter(Mandatory,HelpMessage="The member type")]
        [ValidateSet("AliasProperty","Noteproperty","ScriptProperty","ScriptMethod")]
        [string]$MemberType,
        [Parameter(Mandatory,HelpMessage="The name of your type extension")]
        [ValidateNotNullOrEmpty()]
        [string]$MemberName,
        [Parameter(Mandatory,HelpMessage="The value for your type extension. Remember to enclose scriptblocks in {} and use `$this")]
        [ValidateNotNullOrEmpty()]
        [Object]$Value

    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeofDay) BEGIN  ] Starting $($myinvocation.mycommand)"
        #force overwrite of existing extensions
        $PSBoundParameters.Add("Force",$True)
    } #begin

    Process {
        Write-Verbose "[$((Get-Date).TimeofDay) PROCESS] Adding $MemberType $Membername to  $TypeName "
        Update-TypeData @PSBoundParameters
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeofDay) END    ] Ending $($myinvocation.mycommand)"

    } #end 

} #close Add-MyTypeExtension



Export-ModuleMember -Function 'Get-MyTypeExtension', 'Get-PSType',
'Import-MyTypeExtension','Export-MyTypeExtension','Add-MyTypeExtension'