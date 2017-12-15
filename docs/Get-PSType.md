---
external help file: PSTypeExtensionTools-help.xml
Module Name: PSTypeExtensionTools
online version: 
schema: 2.0.0
---

# Get-PSType

## SYNOPSIS
Get the type name for a given object

## SYNTAX

```
Get-PSType [-Inputobject] <Object> [<CommonParameters>]
```

## DESCRIPTION
This command is designed to easily get the type name of a given object. You can either pipe an object to it or specify it as a parameter value. Use this command to make it easier to define a type extension when you may not know the type name or you don't want to bother typing it.

## EXAMPLES

### EXAMPLE 1
```
PS C:\>123 | Get-PSType
System.Int32
```

Pipe an object and get it's type.

### EXAMPLE 2
```
PS C:\>"apple" | Get-PSType | Get-PSTypeExtension

  TypeName: System.String

Name        Type           Value
----        ----           -----
Size        AliasProperty  Length
IsIPAddress ScriptMethod   $this -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$"
```

Pipe an object to get its type and then pipe that name to Get-PSTypeExtension to see all defined types.

### EXAMPLE 3
```
PS C:\> get-vm win10 | get-pstype | Add-PSTypeExtension -MemberType ScriptProperty -MemberName VMAge -Value {(Get-Date)- $this.Creationtime} 
PS C:\> get-vm | sort VMAge -descending | select Name,Creationtime,VMAge 

Name       CreationTime          VMAge
----       ------------          -----
UbuntuDesk 8/7/2017 1:53:47 PM   94.20:26:57.4237225
CentOS     8/7/2017 3:43:50 PM   94.18:36:54.3394091
DOM1       9/28/2017 9:31:34 AM  43.00:49:10.4396803
SRV1       9/28/2017 9:31:50 AM  43.00:48:54.3284313
SRV2       9/28/2017 9:32:01 AM  43.00:48:43.2135084
SRV3       9/28/2017 9:32:11 AM  43.00:48:33.4681374
WIN10      9/28/2017 9:32:21 AM  43.00:48:23.1610914
Win10Ent   10/16/2017 9:30:46 AM 25.00:49:58.1206825
```

Get the type for a Hyper-V Virtual Machine and add a new script property which can then be used in a PowerShell expression.

## PARAMETERS

### -Inputobject
Any object from PowerShell.

```yaml
Type: Object
Parameter Sets: (All)
Aliases: 

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### System.String

## NOTES
Learn more about PowerShell: http://jdhitsolutions.com/blog/essential-powershell-resources/

## RELATED LINKS

[Get-PSTypeExtension]()

[Add-PSTypeExtension]()

[Get-TypeData]()
