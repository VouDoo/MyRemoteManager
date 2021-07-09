---
external help file: MyRemoteManager-help.xml
Module Name: MyRemoteManager
online version:
schema: 2.0.0
---

# Add-MyRMClient

## SYNOPSIS
Adds MyRemoteManager client.

## SYNTAX

```
Add-MyRMClient [-Name] <String> [-Executable] <String> [-Arguments] <String> [-DefaultPort] <UInt16>
 [[-DefaultScope] <Scopes>] [[-Description] <String>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Adds client entry to the MyRemoteManager inventory file.

## EXAMPLES

### EXAMPLE 1
```
Add-MyRMClient -Name SSH -Executable "ssh.exe" -Arguments "-l <user> -p <port> <host>" -DefaultPort 22
```

### EXAMPLE 2
```
Add-MyRMClient -Name MyCustomClient -Executable "client.exe" -Arguments "--hostname <host> --port <port>" -DefaultPort 666 -DefaultScope External -Description "My custom client"
```

## PARAMETERS

### -Name
Name of the client.

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

### -Executable
Path to the executable program that the client uses.

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

### -Arguments
String of Arguments to pass to the executable.
The string should contain the required tokens.
Please read the documentation of MyRemoteManager.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultPort
Network port to use if the connection has no defined port.

```yaml
Type: UInt16
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultScope
Default scope in which a connection will be invoked.

```yaml
Type: Scopes
Parameter Sets: (All)
Aliases:
Accepted values: Undefined, Console, External

Required: False
Position: 5
Default value: Console
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
Short description for the client.

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

### None. You cannot pipe objects to Add-MyRMClient.
## OUTPUTS

### System.Void. None.
## NOTES

## RELATED LINKS
