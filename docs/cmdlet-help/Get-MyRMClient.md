---
external help file: MyRemoteManager-help.xml
Module Name: MyRemoteManager
online version:
schema: 2.0.0
---

# Get-MyRMClient

## SYNOPSIS
Gets MyRemoteManager clients.

## SYNTAX

```
Get-MyRMClient [[-Name] <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets available clients from the MyRemoteManager inventory file.
Clients can be filtered by their name.

## EXAMPLES

### EXAMPLE 1
```
Get-MyRMClient
(objects)
```

### EXAMPLE 2
```
Get-MyRMClient -Name "custom_*"
(filtered objects)
```

## PARAMETERS

### -Name
Filters clients by name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to Get-MyRMClient.
## OUTPUTS

### PSCustomObject. Get-MyRMClient returns objects with details of the available clients.
## NOTES

## RELATED LINKS
