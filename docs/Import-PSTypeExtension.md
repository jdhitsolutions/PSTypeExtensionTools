---
external help file: PSTypeExtensionTools-help.xml
Module Name: PSTypeExtensionTools
online version: https://jdhitsolutions.com/yourls/344618
schema: 2.0.0
---

# Import-PSTypeExtension

## SYNOPSIS

Import type extension definitions.

## SYNTAX

```yaml
Import-PSTypeExtension [-Path] <String> [-Preview] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Use this command to import extended type definitions from a JSON or XML file that was created with Export-PSTypeExtension.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Import-PSTypeExtension -Path C:\work\stringtypes.json
```

Import definitions from a JSON file.

### EXAMPLE 2

```powershell
PS C:\> dir c:\scripts\mytypes | Import-PSTypeExtension
```

Import definitions from files in C:\Scripts\MyTypes. Presumably, these are XML or JSON files created with Export-PSTypeExtension.

### EXAMPLE 3

```powershell
PS C:\ Import-PSTypeExtension $PSTypeSamples\stringtypes.json -Preview

   TypeName: System.String

MemberType     MemberName  Value
----------     ----------  -----
AliasProperty  Size        Length
ScriptMethod   IsIPAddress $this -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$"
ScriptMethod   Randomize   ($this.ToCharArray() | get-random -Count $this.length) -join ""
ScriptMethod   Reverse     ($this.ToCharArray())[-1..-$this.length] -join ""
ScriptMethod   Reverse     for ($i=$this.length;$i -ge 0;$i--) {...
ScriptProperty IsEmail     $this -match '^\S+@([\w-]+)\.(com|edu|org|net)$'
```

Preview the type extensions in the projects samples folder. This will not modify the type data.

## PARAMETERS

### -Path

The name of the imported file. The extension must be .xml or .json.

```yaml
Type: String
Parameter Sets: (All)
Aliases: FullName

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### -Confirm

Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf

Shows what would happen if the cmdlet runs. The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Preview

Preview the type extensions without applying them. This will not modify the type data.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

### PSTypeExtensionPreview

## NOTES

This command has an alias of itex.

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Export-PSTypeExtension](Export-PSTypeExtension.md)

[Get-PSTypeExtension](Get-PSTypeExtension.md)

[Import-PSTypeExtension](Import-PSTypeExtension.md)

[Update-TypeData]()
