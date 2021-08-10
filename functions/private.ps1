Function _convertTypeName {
    [CmdletBinding()]
    Param([string]$Typename)

    Try {
        #this code should never really throw an exception
        $ErrorActionPreference = "Stop"
        $tn = $Typename -as [type]
        if ($tn) {
            $tn.Fullname
        }
        else {
            $Typename
        }
    }
    Catch {
       $typename
    }
}