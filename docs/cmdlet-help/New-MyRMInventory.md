---
external help file: MyRemoteManager-help.xml
Module Name: MyRemoteManager
online version:
schema: 2.0.0
---

# New-MyRMInventory

## SYNOPSIS
Creates MyRemoteManager inventory file.

## SYNTAX

```
New-MyRMInventory [-NoDefaultClients] [-Force] [-PassThru] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Creates a new inventory file where MyRemoteManager saves items.

## EXAMPLES

### EXAMPLE 1
```
New-MyRMInventory
```

### EXAMPLE 2
```
New-MyRMInventory -NoDefaultClients
```

### EXAMPLE 3
```
New-MyRMInventory -Force
```

### EXAMPLE 4
```
New-MyRMInventory -PassThru
C:\Users\MyUsername\MyRemoteManager.json
```

### EXAMPLE 5
```
New-MyRMInventory -NoDefaultClients -Force -PassThru
C:\Users\MyUsername\MyRemoteManager.json
```

## PARAMETERS

### -NoDefaultClients
Does not add defaults clients to the new inventory.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
Overwrites existing inventory file.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PassThru
Indicates that the cmdlet sends items from the interactive window down the pipeline as input to other commands.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

### None. You cannot pipe objects to New-MyRMInventory.
## OUTPUTS

### System.Void. None.
###     or if PassThru is set,
### System.String. New-MyRMInventory returns a string with the path to the created inventory.
## NOTES

## RELATED LINKS
