Get-ChildItem $PSScriptRoot\Functions\*.ps1 |
Foreach-object { . $_.FullName}


#add an argument completer

Register-ArgumentCompleter -CommandName Get-PSTypeExtension -ParameterName TypeName -ScriptBlock {
    param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameter)

    #PowerShell code to populate $wordToComplete
    Get-TypeData | Sort-Object TypeName |
    Where-Object {$_.TypeName -like "*$wordToComplete*"} |
    ForEach-Object {
            # completion text,listItem text,result type,Tooltip
            [System.Management.Automation.CompletionResult]::new($_.TypeName, $_.TypeName, 'ParameterValue', $_)
        }
}

#Export the Samples folder location as a variable
$PSTypeSamples = Join-Path $PSScriptRoot -ChildPath samples

Export-ModuleMember -Variable PSTypeSamples -Alias 'Set-PSTypeExtension','gtex','itex','atex','etex'

