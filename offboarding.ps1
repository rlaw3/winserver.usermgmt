param([Parameter(Mandatory)] $user_input)

$ad_name = get-aduser $user_input
#change the folder path
$csv_path = 'c:\<path to folder>\'+$ad_name+'.csv'
$move_ou = "<location for the OU>"

#stores AD groups in a csv
(Get-ADuser -Identity $ad_name -Properties memberof).memberof | Get-ADGroup | Select-Object name | Sort-Object name | export-csv -path $csv_path
#disables ad account
Disable-adaccount -Identity $ad_name
#removes AD groups
Get-ADUser -Identity $ad_name -Properties MemberOf | ForEach-Object {
  $_.MemberOf | Remove-ADGroupMember -Members $_.DistinguishedName -Confirm:$false
}
#moves user to former users
Move-ADObject -Identity $ad_name -TargetPath $move_ou
