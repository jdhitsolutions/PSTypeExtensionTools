Function _convertTypeName {
    [CmdletBinding()]
    Param([String]$TypeName)

    Try {
        #this code should never really throw an exception
        $ErrorActionPreference = "Stop"
        $tn = $TypeName -as [type]
        if ($tn) {
            $tn.FullName
        }
        else {
            $TypeName
        }
    }
    Catch {
       $TypeName
    }
}
