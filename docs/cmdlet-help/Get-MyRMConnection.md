---
external help file: MyRemoteManager-help.xml
Module Name: MyRemoteManager
online version:
schema: 2.0.0
---

# Get-MyRMConnection

## SYNOPSIS
Gets MyRemoteManager connections.

## SYNTAX

```
Get-MyRMConnection [[-Name] <String>] [[-Hostname] <String>] [[-Client] <String>] [<CommonParameters>]
```

## DESCRIPTION
Gets available connections from the MyRemoteManager inventory file.
connections can be filtered by their name and/or client name.

## EXAMPLES

### EXAMPLE 1
```
Get-MyRMConnection
(objects)
```

### EXAMPLE 2
```
Get-MyRMConnection -Name "myproject_*" -Hostname "*.mydomain" -Client "*_myproject"
(filtered objects)
```

## PARAMETERS

### -Name
Filters connections by name.

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

### -Hostname
Filter by hostname.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -Client
Filter by client name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to Get-MyRMConnection.
## OUTPUTS

### PSCustomObject. Get-MyRMConnection returns objects with details of the available connections.
## NOTES

## RELATED LINKS
