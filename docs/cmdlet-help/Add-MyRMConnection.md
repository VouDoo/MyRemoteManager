---
external help file: MyRemoteManager-help.xml
Module Name: MyRemoteManager
online version:
schema: 2.0.0
---

# Add-MyRMConnection

## SYNOPSIS
Adds MyRemoteManager connection.

## SYNTAX

```
Add-MyRMConnection [-Name] <String> [-Hostname] <String> [[-Port] <UInt16>] [-DefaultClient] <String>
 [[-DefaultUser] <String>] [[-Description] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Adds connection entry to the MyRemoteManager inventory file.

## EXAMPLES

### EXAMPLE 1
```
Add-MyRMConnection -Name myconn -Hostname myhost -DefaultClient SSH
```

### EXAMPLE 2
```
Add-MyRMConnection -Name myrdpconn -Hostname myhost -DefaultClient RDP -Description "My RDP connection"
```

### EXAMPLE 3
```
Add-MyRMConnection -Name mysshconn -Hostname myhost -Port 2222 -DefaultClient SSH -DefaultUser myuser -Description "My SSH connection"
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

### -Hostname
Name of the remote host.

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

### -Port
Port to connect to on the remote host.
If not set, it will use the default port of the client.

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultClient
Name of the default client.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultUser
Default client to use to connect to the remote host.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Short description for the connection.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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

### None. You cannot pipe objects to Add-MyRMConnection.
## OUTPUTS

### System.Void. None.
## NOTES

## RELATED LINKS
