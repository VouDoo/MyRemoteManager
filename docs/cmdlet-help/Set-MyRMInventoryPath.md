---
external help file: MyRemoteManager-help.xml
Module Name: MyRemoteManager
online version:
schema: 2.0.0
---

# Set-MyRMInventoryPath

## SYNOPSIS
Sets MyRemoteManager inventory path.

## SYNTAX

```
Set-MyRMInventoryPath [-Path] <String> [-Target <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Sets the specific environment variable to overwrite default path to the MyRemoteManager inventory file.

## EXAMPLES

### EXAMPLE 1
```
Set-MyRMInventoryPath C:\MyCustomInventory.json
```

### EXAMPLE 2
```
Set-MyRMInventoryPath -Path C:\MyCustomInventory.json
```

## PARAMETERS

### -Path
Path to the inventory file.

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

### -Target
Target scope where the environment variable will be saved.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: User
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

### None. You cannot pipe objects to Set-MyRMInventoryPath.
## OUTPUTS

### System.Void. None.
## NOTES

## RELATED LINKS
