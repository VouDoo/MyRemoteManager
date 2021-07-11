---
external help file: MyRemoteManager-help.xml
Module Name: MyRemoteManager
online version:
schema: 2.0.0
---

# Test-MyRMConnection

## SYNOPSIS
Tests MyRemoteManager connection.

## SYNTAX

```
Test-MyRMConnection [-Name] <String> [<CommonParameters>]
```

## DESCRIPTION
Tests MyRemoteManager connection which is defined in the inventory.

## EXAMPLES

### EXAMPLE 1
```
Test-MyRMConnection myconn
(status)
```

### EXAMPLE 2
```
Test-MyRMConnection -Name myconn
(status)
```

## PARAMETERS

### -Name
Name of the connection.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to Test-MyRMConnection.
## OUTPUTS

### System.String. Test-MyRMConnection returns a string with the status of the remote host.
## NOTES

## RELATED LINKS
