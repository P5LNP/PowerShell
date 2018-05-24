Write-Host "TDX Account Lockout Check"

$username = read-host "Enter Username"

get-aduser -filter {samaccountname -like $sam} -properties * | select-object DisplayName,SamAccountName,PasswordExpired,PasswordLastSet,@{Name="ExpiryDate";Expression={[datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed")}},Enabled,LockedOut | Format-List