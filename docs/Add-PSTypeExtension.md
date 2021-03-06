---
external help file: PSTypeExtensionTools-help.xml
Module Name: PSTypeExtensionTools
online version: http://bit.ly/30FkoJX
schema: 2.0.0
---

# Add-PSTypeExtension

## SYNOPSIS

Add a new type extension.

## SYNTAX

```yaml
Add-PSTypeExtension [-TypeName] <String> -MemberType <String> -MemberName <String> -Value <Object> [-IncludeDeserialized] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

Use this command to easily define a new type extension for a given object type. Existing members with the same name will be overwritten, so you can also use this as a "Set" command.

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

Define a script property called IsIPAddress which will return True if the string matches the pattern for an IP address.

### EXAMPLE 3

```powershell
PS C:\ Add-PSTypeExtension -TypeName system.io.fileinfo -MemberType AliasProperty -MemberName Size -value Length -IncludeDeserialized
```

Create an alias called Size using the Length property on file objects. This expression will also create it for the deserialized version of the type so that you can use it with remoting results.

## PARAMETERS

### -MemberName

The name of your type extension.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Name

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
Aliases: Type
Accepted values: AliasProperty, NoteProperty, ScriptProperty, ScriptMethod

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TypeName

Enter the name of a type like System.IO.FileInfo.

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

### -IncludeDeserialized

Create the extension in the deserialized version of the specified type along with the specified type.

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

## NOTES

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-PSTypeExtension]()
