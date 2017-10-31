#requires -version 5.0

Function Import-MyTypeExtension {
[cmdletbinding(SupportsShouldProcess)]
Param(
[Parameter(Position=0,Mandatory,HelpMessage= "The path to a json file with type extension information")]
[ValidateScript({
if (Test-Path $_) {
   $True
}
else {
   Throw "Cannot validate path $_"
}
})]     
[string]$Path
)

Write-Verbose "Starting: $($MyInvocation.Mycommand)"
Write-Verbose "Processing $path"

$in = Get-content -path $Path  | convertfrom-json

Write-Verbose "Adding type extensions for $($in.TypeName)"

$params = @{
 Typename = $in.TypeName
 MemberType = "AliasProperty"
 MemberName = ""
 Value = ""
 Force = $True
}

foreach ($item in $in.Definitions) {
 write-verbose "Creating type extension $($item.name)"
 if ($item.ReferencedMemberName) {
    Write-Verbose "Creating an alias property for $($item.ReferencedMemberName)"
    $params.MemberName = $item.Name
    $params.Value = $item.ReferencedMemberName
 } 
 else {
    Write-Verbose "Creating a script property"
    $params.MemberName = $item.Name
    $params.memberType = "ScriptProperty"
    
    if ($item.Get) {
        Write-Verbose "Using a GET scriptblock"
        $params.Value = [scriptblock]::Create($item.Get)
    }
    else {
       Write-Verbose "Using a SET scriptblock" 
       $params.Value = [scriptblock]::Create($item.Set)
    }
 } #else scriptproperty

    #add a custom -WhatIf message
    if ($PSCmdlet.ShouldProcess($Params.typename,"Adding $($params.membertype) $($params.MemberName)")) {
        #implement the change
        Update-TypeData @params
    }
}

Write-Verbose "Ending: $($MyInvocation.Mycommand)"

} #end Import

Function Export-MyTypeExtension {
[cmdletbinding()]
Param(
[Parameter(Position = 0, Mandatory, HelpMessage = "Enter a type name")]
[ValidateNotNullorEmpty()]
[string]$Typename,
[Parameter(Mandatory, HelpMessage = "Enter a comma separated list of member names")]
[ValidateNotNullorEmpty()]
[string[]]$Members,
[Parameter(Mandatory,HelpMessage= "The path for your json file with exported type extension information")]
[ValidateNotNullorEmpty()]
[string]$Path
)

Write-Verbose "Starting: $($MyInvocation.Mycommand)"

$typedata = get-typedata -TypeName $typename      

If ($typedata) {

    #join members into a regex pattern
    $pattern = $members.foreach({"^($_)$"}) -join "|"
    Write-Verbose "Filtering where members match $pattern"
    $mymembers = $typedata.members.GetEnumerator() | where-object {$_.key -match $pattern}

    if ($mymembers.count -eq 0) {
        Write-Warning "Failed to find members that match $pattern"
        #bail out
        Return
    }
    
    $definitions = @()

    foreach ($m  in $mymembers) {
         Write-Verbose "Processing $($m.key)"
         $definitions+=$m.value | 
         Select-object Name,ReferencedMemberName,
         @{Name="Get";Expression={$_.GetScriptBlock.ToString()}},
         @{Name="Set";Expression={$_.SetScriptBlock.ToString()}}
    }

    #show members that weren't found
    $notfound = $members | where-object { -Not $mymembers.GetEnumerator().key.contains($_)}
    if ($notfound) {
        Write-Warning "Failed to find type extension: $($notfound -join ',')"
    }

    Write-Verbose "Exporting members to $Path"
    [pscustomobject]@{
     TypeName = $typedata.TypeName
     Definitions = $definitions
    } | ConvertTo-Json | Set-content -Path $path
    
}
else {
    write-Warning "Can't find type $typename"    
}

Write-Verbose "Ending: $($MyInvocation.Mycommand)"

} #end Export

Export-ModuleMember -Function 'Export-MyTypeExtension','Import-MyTypeExtension'