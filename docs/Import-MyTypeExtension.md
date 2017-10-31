---
external help file: PSTypeExtensionTools-help.xml
Module Name: PSTypeExtensionTools
online version: 
schema: 2.0.0
---

# Import-MyTypeExtension

## SYNOPSIS
Import type extension data.

## SYNTAX

```
Import-MyTypeExtension [-Path] <String>
```

## DESCRIPTION
Use this command to import type extension setting data from a json file presumably created with Export-MyTypeExtension. The settings will be created in the current PowerShell session, overwriting any existing entries with the same name.

## EXAMPLES

### Example 1
```
PS C:\> Import-MyTypeExtension c:\scripts\measure-types.json
```

Import type extensions from the json file.

## PARAMETERS

### -Path
The path to a json file with type extension information.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## INPUTS

### None

## OUTPUTS

### None

## NOTES

## RELATED LINKS
[Export-MyTypeExtension]()
