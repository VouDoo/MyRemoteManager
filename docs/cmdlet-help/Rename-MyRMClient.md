---
external help file: MyRemoteManager-help.xml
Module Name: MyRemoteManager
online version:
schema: 2.0.0
---

# Rename-MyRMClient

## SYNOPSIS
Renames MyRemoteManager client.

## SYNTAX

```
Rename-MyRMClient [-Name] <String> [-NewName] <String> [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Renames client entry from the MyRemoteManager inventory file.

## EXAMPLES

### EXAMPLE 1
```
Rename-MyRMClient -Name my_old_client -NewName my_new_client
```

## PARAMETERS

### -Name
Name of the client to rename.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName
New name for the client.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to Rename-MyRMClient.
## OUTPUTS

### System.Void. None.
## NOTES

## RELATED LINKS
