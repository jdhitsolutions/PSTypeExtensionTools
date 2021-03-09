Function _convertTypeName {
    [CmdletBinding()]
    Param([string]$Typename)

    Try {
        ($Typename -as [type]).fullname
    }
    Catch {
        $Typename
    }

}