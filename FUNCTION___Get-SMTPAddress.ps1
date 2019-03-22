function Get-SMTPAddress {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory,ValueFromPipeline)][string] $SamAccountName,
        [switch] $PrimaryOnly
    )

    begin {
        # Check if we are in an Exchange Management Console or not (EOL or other Powershell connected to Exchange by import-pssession)
        $EMC = [bool](Get-TypeData -TypeName 'Microsoft.Exchange.Data.ProxyAdressBase')
    }

    process {
        
        if ($EMC) {
            if ($PrimaryOnly) {
                Get-Recipient $SamAccountName `
                | Select-Object -ExpandProperty EmailAddresses `
                | Where-Object {$_.PrefixString -ceq "SMTP"} `
                | Select-Object @{Name = 'Type'; Expression = {'Primary'}},SMTPAddress
            } else {
                Get-Recipient $SamAccountName `
                | Select-Object -ExpandProperty EmailAddresses `
                | Where-Object {$_.PrefixString -eq "SMTP"} `
                | Select-Object @{Name = 'Type'; Expression = {if ($_.PrefixString -ceq 'SMTP') {'Primary'} else {'Alias'}}},SMTPAddress `
                | Sort-Object -Property @{Expression = 'Type'; Descending = $true},@{Expression = 'SMTPAddress'; Descending = $false}
            }            
        } else {
            if ($PrimaryOnly) {
                Get-Recipient $SamAccountName `
                | Select-Object -ExpandProperty EmailAddresses `
                | Where-Object {$_ -clike "SMTP*"} `
                | Select-Object @{Name = 'Type'; Expression = {'Primary'}},@{Name = 'SMTPAddress';Expression = {$_ -replace '^SMTP:',''}}
            } else {
                Get-Recipient $SamAccountName `
                | Select-Object -ExpandProperty EmailAddresses `
                | Where-Object {$_ -like "SMTP*"} `
                | Select-Object @{Name = 'Type'; Expression = {if ($_ -clike 'SMTP*') {'Primary'} else {'Alias'}}},@{Name = 'SMTPAddress';Expression = {$_ -replace '^SMTP:',''}} `
                | Sort-Object -Property @{Expression = 'Type'; Descending = $true},@{Expression = 'SMTPAddress'; Descending = $false}
            }
        }

    }

    end {
    }
}