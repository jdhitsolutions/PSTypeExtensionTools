---
external help file: PSTypeExtensionTools-help.xml
Module Name: PSTypeExtensionTools
online version: 
schema: 2.0.0
---

# Add-PSTypeExtension

## SYNOPSIS

Add a new type extension

## SYNTAX

```powershell
Add-PSTypeExtension [-TypeName] <String> -MemberType <String> -MemberName <String> -Value <Object> [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Use this command to easily define a new type extension for a given object type. Existing members with the same name will be overwritten so you can also use this as a "Set" command.

## EXAMPLES

### EXAMPLE 1

```powershell
PS C:\> Add-PSTypeExtension -TypeName system.string -MemberType AliasProperty -MemberName Size -Value Length
```

Define an alias property called Size for the Length property of the String type.

### EXAMPLE 2

```powershell
PS C:\> Add-PSTypeExtension -TypeName system.string -MemberType ScriptMethod -MemberName IsIPAddress -value {$this -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$"}
PS C:\> $s = "10.4.7.10"
PS C:\> $s.IsIPAddress()
True
```

Define an script property called IsIPAddress which will return True if the string matches the pattern for an IP address.

## PARAMETERS

### -MemberName

The name of your type extension.

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

### -MemberType

The member type. You cannot use this command to define CodeMethods or CodeProperties.

```yaml
Type: String
Parameter Sets: (All)
Aliases: 
Accepted values: AliasProperty, Noteproperty, ScriptProperty, ScriptMethod

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TypeName

Enter the name of a type like system.io.fileinfo.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Value

The value for your type extension. Remember to enclose scriptblocks in {} and use $this.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: Named
Default value: None
Accept pipeline input: False
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

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### None

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-PSTypeExtension]()
