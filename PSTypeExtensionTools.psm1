Get-ChildItem $PSScriptRoot\Functions\*.ps1 |
Foreach-object { . $_.FullName}

#Export the Samples folder location as a variable
$PSTypeSamples = Join-Path $PSScriptRoot -ChildPath samples

Export-ModuleMember -Variable PSTypeSamples -Alias 'Set-PSTypeExtension'

