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

        Write-Verbose "Converting typename to proper type"
        $TypeName = _convertTypeName $TypeName


        Write-Verbose "Analyzing $typename"
        if ($TypeName) {
            Write-Verbose "Getting type data"
            $typedata += Get-TypeData -TypeName $typename
        }
        else {
            Write-Warning "Failed to get a typename"
            #bail out
            $typedata = $False
            return
        }

    } #process
    End {

        if ($typedata) {
            $typedata = $typedata | Select-Object -Unique
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
                                Typename   = $TypeName
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
                                Typename   = $TypeName
                            }
                        } #scriptproperty
                        "ScriptMethodData" {
                            $def = [pscustomobject]@{
                                PSTypename = 'PSTypeExtension'
                                MemberType = "ScriptMethod"
                                MemberName = $member.name
                                Value      = $member.script.ToString().trim()
                                Typename   = $TypeName
                            }
                        } #scriptmethod
                        "NotePropertyData" {
                            $def = [pscustomobject]@{
                                PSTypename = 'PSTypeExtension'
                                MemberType = "Noteproperty"
                                MemberName = $member.name
                                Value      = $member.Value
                                Typename   = $TypeName
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
                                    Typename   = $TypeName
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
                                Typename   = $TypeName
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