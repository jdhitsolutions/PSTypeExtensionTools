---
external help file: PSTypeExtensionTools-help.xml
Module Name: PSTypeExtensionTools
online version:
schema: 2.0.0
---

# New-PSPropertySet

## SYNOPSIS

Create a new property set ps1xml file.

## SYNTAX

### new (Default)

```yaml
New-PSPropertySet [-Typename] <String> -Name <String> -Properties <String[]> -FilePath <String> [-NoClobber] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### append

```yaml
New-PSPropertySet [-Typename] <String> -Name <String> -Properties <String[]> -FilePath <String> [-Append] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION

PowerShell has a concept of property sets. A property set allows you to reference a collection of properties with a single name. Property set definitions have to be stored in a .ps1xml file. This command will create the file for you. You also have the option to append to an existing file.

Use Update-TypeData to append the file. If you import your file more than once in the same session, you might see a warning about existing property names. Existing entries won't be overwritten.

Property set updates are not persistant. You will need to import your ps1xml, ideally in your PowerShell profile script.

## EXAMPLES

### Example 1

```powershell
PS C:\> New-PSPropertySet -typename System.IO.FileInfo -name info -properties Fullname,IsReadOnly,CreationTime,LastWriteTime -filepath c:\work\myfileinfo.type.ps1xml
PS C:\> Update-TypeData C:\work\myfileinfo.type.ps1xml
PS C:\> dir c:\work -file | select info

FullName                     IsReadOnly CreationTime           LastWriteTime
--------                     ---------- ------------           -------------
C:\work\a.csv                False 12/1/2020 11:30:55 AM  12/1/2020 11:30:55 AM
C:\work\a.dat                False 2/12/2021 5:36:55 PM   2/12/2021 5:36:55 PM
C:\work\a.md                 False 11/6/2020 9:50:19 AM   12/1/2020 12:40:03 PM
C:\work\a.txt                False 12/31/2020 9:10:15 AM  12/31/2020 9:10:15 AM
C:\work\a.xml                False 12/31/2020 12:15:44 PM 12/31/2020 12:15:44 PM
C:\work\aa.ps1               False 12/31/2020 9:13:16 AM  12/31/2020 9:13:16 AM
C:\work\aa.txt               False 12/31/2020 9:11:18 AM  12/31/2020 9:11:18 AM
...
```

The first command creates the property set definition file. The second command loads it into PowerShell. The last command uses the custom property set.

## PARAMETERS

### -Append

Append to an existing file.

```yaml
Type: SwitchParameter
Parameter Sets: append
Aliases:

Required: False
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

### -FilePath

Enter the name of the .ps1xml file to create.

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

### -Name

Enter the new property set name. It should be alphanumeric.

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

### -NoClobber

Don't overwrite an existing file.

```yaml
Type: SwitchParameter
Parameter Sets: new
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Properties

Enter the existing property names or aliases to belong to this property set.

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

### -Typename

Enter the object typename. This is the value you would see in Get-Member.

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

### -WhatIf

Shows what would happen if the cmdlet runs.
The cmdlet is not run.

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

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None

## OUTPUTS

### System.IO.FileInfo

## NOTES

Learn more about PowerShell:
http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Update-TypeData]()
