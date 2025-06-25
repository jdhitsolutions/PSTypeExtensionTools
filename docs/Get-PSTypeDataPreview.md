---
external help file: PSTypeExtensionTools-help.xml
Module Name: PSTypeExtensionTools
online version: https://jdhitsolutions.com/yourls/61129b
schema: 2.0.0
---

# Get-PSTypeDataPreview

## SYNOPSIS

Preview the type extension settings in a ps1xml file.

## SYNTAX

```yaml
Get-PSTypeDataPreview [[-Path] <String>] [<CommonParameters>]
```

## DESCRIPTION

You can use Update-TypeData to import type extension settings from a ps1xml file. This command allows you to preview the type extension settings in a ps1xml file before importing them. The output is a custom object that contains the type name, member name, and other details.

CodeProperty members are not displayed.

## EXAMPLES

### Example 1

```powershell
PS C:\>  Get-PStypeDataPreview $PSTypeSamples\process.types.ps1xml

TypeName: System.Diagnostics.Process

    AliasProperty:

      Name         Reference
      ----         ---------
      Computername MachineName
      Started      StartTime

    NoteProperty:

      Name    Value
      ----    -----
      Comment Type extended with PSTypeExtensionTools

    ScriptProperty:

      Name : RunTime
      Get  : (Get-Date) - $this.StartTime

    PropertySet:

       PSRun = ID,Name,WS,StartTime,RunTime
       RunInfo = ID,Name,StartTime,RunTime,Path
```

The output will styled with ANSI color sequences. This example is examining one of the sample ps1xml files included with the module.

## PARAMETERS

### -Path

Specify the path to the ps1xml file containing the type extension setting you will import using Update-TypeData.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters

This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String

## OUTPUTS

### PSTypeUpdatePreview

## NOTES

Learn more about PowerShell: http://jdhitsolutions.com/yourls/newsletter

## RELATED LINKS

[Import-PSTypeExtension](Import-PSTypeExtension.md)

[Get-TypeData]()
