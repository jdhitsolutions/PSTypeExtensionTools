Function Add-PSTypeExtension {
    [CmdletBinding(SupportsShouldProcess)]
    [Alias('Set-PSTypeExtension')]

    Param(
        [Parameter(
            Position = 0,
            Mandatory,
            ValueFromPipeline,
            HelpMessage = "Enter the name of a type like System.IO.FileInfo")]
        [String]$TypeName,
        [Parameter(
            Mandatory,
            HelpMessage = "The member type"
        )]
        [ValidateSet("AliasProperty", "NoteProperty", "ScriptProperty", "ScriptMethod")]
        [alias("Type")]
        [String]$MemberType,
        [Parameter(
            Mandatory,
            HelpMessage = "The name of your type extension"
        )]
        [ValidateNotNullOrEmpty()]
        [alias("Name")]
        [String]$MemberName,
        [Parameter(
            Mandatory,
            HelpMessage = "The value for your type extension. Remember to enclose scriptblocks in {} and use `$this"
        )]
        [ValidateNotNullOrEmpty()]
        [Object]$Value,
        [Parameter(HelpMessage = "Create the extension in the deserialized version of the specified type including the original type.")]
        [Switch]$IncludeDeserialized
    )
    Begin {
        Write-Verbose "[$((Get-Date).TimeOfDay) BEGIN  ] Starting $($MyInvocation.MyCommand)"

    } #begin

    Process {
        #force overwrite of existing extensions
        $PSBoundParameters.Add("Force", $True)
        if ($PSBoundParameters.ContainsKey("IncludeDeserialized")) {
            [void]$PSBoundParameters.Remove("IncludeDeserialized")
            $PSBoundParameters.TypeName = "deserialized.$TypeName"
            Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Adding $MemberType $MemberName to $($PSBoundParameters.TypeName)"
            Update-TypeData @PSBoundParameters
            $PSBoundParameters.TypeName = $TypeName
        }
        Write-Verbose "[$((Get-Date).TimeOfDay) PROCESS] Adding $MemberType $MemberName to $($PSBoundParameters.TypeName)"
        Update-TypeData @PSBoundParameters
    } #process

    End {
        Write-Verbose "[$((Get-Date).TimeOfDay) END    ] Ending $($MyInvocation.MyCommand)"

    } #end

} #close Add-MyTypeExtension
