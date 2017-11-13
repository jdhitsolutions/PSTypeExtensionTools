---
external help file: PSTypeExtensionTools-help.xml
Module Name: PSTypeExtensionTools
online version: 
schema: 2.0.0
---

# Get-PSTypeExtension

## SYNOPSIS
Get selected type extensions.

## SYNTAX

### All (Default)
```
Get-PSTypeExtension [-TypeName] <String> [<CommonParameters>]
```

### members
```
Get-PSTypeExtension [-TypeName] <String> -Members <String[]> [<CommonParameters>]
```

### all
```
Get-PSTypeExtension [-TypeName] <String> [-All] [<CommonParameters>]
```

## DESCRIPTION
Use this command to list defined type extensions. You can either select individual ones or all of them. This command is very similar to Get-TypeData except that it makes it easier to see the extension value.

## EXAMPLES

### Example 1
```
PS C:\> Get-PSTypeExtension system.string

MemberType    MemberName  Value                                               TypeName
----------    ----------  -----                                               --------
AliasProperty Size        Length                                              System.String
ScriptMethod  IsIPAddress $this -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$" System.String
```

Get all type extensions for System.String.

### Example 2
```
PS C:\> Get-PSTypeExtension system.string -members size

MemberType    MemberName  Value                                               TypeName
----------    ----------  -----                                               --------
AliasProperty Size        Length                                              System.String
```

Get the Size type extension for System.String.

## PARAMETERS

### -All
Get all defined type extensions

```yaml
Type: SwitchParameter
Parameter Sets: all
Aliases: 

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Members
Enter a comma separated list of member names

```yaml
Type: String[]
Parameter Sets: members
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TypeName
Enter the name of type like System.IO.FileInfo

```yaml
Type: String
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByPropertyName, ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### System.Object

## NOTES
Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-TypeData]()
