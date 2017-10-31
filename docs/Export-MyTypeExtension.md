---
external help file: PSTypeExtensionTools-help.xml
Module Name: PSTypeExtensionTools
online version: 
schema: 2.0.0
---

# Export-MyTypeExtension

## SYNOPSIS
Export type information to a JSON file

## SYNTAX

```
Export-MyTypeExtension [-Typename] <String> -Members <String[]> -Path <String>
```

## DESCRIPTION
Use this command to export selected members from a type extension to a JSON file. It is assumed you will be importing the settings using Import-MyTypeExtension. This command doesn't write anything to the pipeline.

## EXAMPLES

### Example 1
```
PS C:\> Export-myTypeExtension -typename Microsoft.PowerShell.Commands.GenericMeasureInfo -Members SumKB,SumMB,SumGB -Path c:\scripts\measure-types.json
```

It is assumed that at some point you added custom type extensions to the GenericMeasureInfo type. These definitions will be exported to a json file.

## PARAMETERS

### -Members
Enter a comma separated list of member names. You will get a warning for any members not found but other members will be exported.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
The path for your json file with exported type extension information.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Typename
Enter a type name like System.String

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

### none

## NOTES

## RELATED LINKS
[Import-PSTypeExtension]()
