# Initialising variables
param (
    [string]$firstName,
    [string]$lastName,
    [string]$desc,
    [string]$primaryGroup
) 

# Create the initial
$initial = ($firstName[0].ToString().ToLower() + $lastName.ToLower())

# Creating a new AD user
New-ADUser -Name "$firstName $lastName" `
            -GivenName $firstName `
            -Surname $lastName `
            -DisplayName "$firstName $lastName" `
            -SamAccountName $initial `
            -UserPrincipalName "$initial@cmcmarkets.com" `
            -Path "OU=AU1,OU=User Accounts,OU=CMC Accounts,DC=CMC,DC=DMZ" `
            -AccountPassword (ConvertTo-SecureString "12345=qwert" -AsPlainText -Force) `
            -Description $desc `
            -Enabled $true

# Add a user to a group
Add-ADGroupMember -Identity $primaryGroup -Members $initial

# Setting primary user to group
$group = get-adgroup "$primaryGroup" -properties @("primaryGroupToken")
get-aduser $initial | set-aduser -replace @{primaryGroupID=$group.primaryGroupToken}

# Set the loginShell attribute for a user
Set-ADUser -Identity $initial -Add @{loginShell="/bin/ksh"}

Write-Host $intial "AD account has been created in DMZ"
