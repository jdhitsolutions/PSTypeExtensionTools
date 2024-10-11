Function Get-PSTypeExtension {
    [CmdletBinding()]
    [OutputType('PSTypeExtension')]
    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            HelpMessage = 'Enter the name of type like System.IO.FileInfo',
            ValueFromPipelineByPropertyName,
            ValueFromPipeline
        )]
        [ValidateNotNullOrEmpty()]
        [String]$TypeName,
        [Parameter(
            HelpMessage = 'Enter a comma separated list of member names',
            ParameterSetName = 'members'
        )]
        [string[]]$Members,
        [Parameter(HelpMessage = 'Show CodeProperty custom properties')]
        [Switch]$CodeProperty
    )

    Begin {
        Write-Verbose "Starting: $($MyInvocation.MyCommand)"
        $TypeData = @()

    } #begin
    Process {

        Write-Verbose 'Converting TypeName to proper type'
        $TypeName = _convertTypeName $TypeName


        Write-Verbose "Analyzing $TypeName"
        if ($TypeName) {
            Write-Verbose 'Getting type data'
            $TypeData += Get-TypeData -TypeName $TypeName
        }
        else {
            Write-Warning 'Failed to get a TypeName'
            #bail out
            $TypeData = $False
            return
        }

    } #process
    End {

        if ($TypeData) {
            $TypeData = $TypeData | Select-Object -Unique
            $out = [System.Collections.Generic.List[object]]::new()
            if (-Not $Members) {
                Write-Verbose 'Getting all member names'
                $Members = $TypeData.members.keys
            }
            foreach ($name in $Members) {
                Try {
                    Write-Verbose "Analyzing member $name"
                    $member = $TypeData.members[$name]
                    $datatype = $member.GetType().name

                    Write-Verbose "Processing type $datatype"
                    Switch ($datatype) {
                        'AliasPropertyData' {
                            $def = [PSCustomObject]@{
                                PSTypeName = 'PSTypeExtension'
                                MemberType = 'AliasProperty'
                                MemberName = $member.name
                                Value      = $member.ReferencedMemberName
                                TypeName   = $TypeName
                            }
                        } #alias
                        'ScriptPropertyData' {
                            if ($member.GetScriptBlock) {
                                $code = $member.GetScriptBlock.ToString()
                            }
                            else {
                                $code = $member.SetScriptBlock.ToString()
                            }
                            $def = [PSCustomObject]@{
                                PSTypeName = 'PSTypeExtension'
                                MemberType = 'ScriptProperty'
                                MemberName = $member.name
                                Value      = $code
                                TypeName   = $TypeName
                            }
                        } #scriptproperty
                        'ScriptMethodData' {
                            $def = [PSCustomObject]@{
                                PSTypeName = 'PSTypeExtension'
                                MemberType = 'ScriptMethod'
                                MemberName = $member.name
                                Value      = $member.script.ToString().trim()
                                TypeName   = $TypeName
                            }
                        } #scriptmethod
                        'NotePropertyData' {
                            $def = [PSCustomObject]@{
                                PSTypeName = 'PSTypeExtension'
                                MemberType = 'NoteProperty'
                                MemberName = $member.name
                                Value      = $member.Value
                                TypeName   = $TypeName
                            }
                        } #NoteProperty
                        'CodePropertyData' {
                            #only show these if requested with -CodeProperty
                            if ($CodeProperty) {
                                if ($member.GetCodeReference) {
                                    $code = $member.GetCodeReference.ToString()
                                }
                                else {
                                    $code = $member.SetCodeReference.ToString()
                                }
                                $def = [PSCustomObject]@{
                                    PSTypeName = 'PSTypeExtension'
                                    MemberType = 'CodeProperty'
                                    MemberName = $member.name
                                    Value      = $code
                                    TypeName   = $TypeName
                                }
                            }
                            else {
                                $def = $False
                            }
                        } #codeproperty
                        Default {
                            Write-Warning "Cannot process $datatype type for $($TypeData.TypeName)."
                            $def = [PSCustomObject]@{
                                PSTypeName = 'PSTypeExtension'
                                MemberType = $datatype
                                MemberName = $member.name
                                Value      = $member.Value
                                TypeName   = $TypeName
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
            Write-Warning "Failed to find any type extensions for [$TypeName]."
        }
        Write-Verbose "Ending: $($MyInvocation.MyCommand)"
    }

} #end Get-PSTypeExtension
