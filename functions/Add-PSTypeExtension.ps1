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