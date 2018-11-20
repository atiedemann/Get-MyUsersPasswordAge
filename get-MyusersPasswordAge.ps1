function Get-MyADPasswortAge
{
<#
.SYNOPSIS
This Cmdlet add get the age of ad user in an organizational unit

.DESCRIPTION
This Cmdlet add get the age of ad user in an organizational unit

.PARAMETER OU
Specifies the OU string where the users should be searched
    
.EXAMPLE
Get-MyADPasswortAge -OU "OU=<OU>,OU=<OU>,DC=<DC>,DC=<DC>"

#>
    Param(
        [Parameter(Mandatory)]
        [STRING]$OU
    )

    if (Get-OrganizationalUnit -Identity $OU -ErrorAction SilentlyContinue) {
        $pwdLastSet = @{Name="PasswordLastSet";Expression={$([datetime]::FromFileTime($_.pwdLastSet))}}
        $Days = @{Name="PasswordAge";Expression={$((New-TimeSpan -Start ([datetime]::FromFileTime($_.pwdLastSet)) -End (Get-Date)).Days)}}

        Get-ADUser -Filter * -SearchBase $OU -Properties Lastlogon, pwdLastSet | Sort-Object pwdLastSet | Select-Object Name,pwdLastSet,$pwdLastSet, $Days
    } else {
        Write-Host 'Please type a valid Organizational Unit as paramater!'
    }

}
