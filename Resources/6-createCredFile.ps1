
#creating encrypted cred file
#
#Use any 24 numbers, separated by comma
[Byte[]] $key = (3,4,2,3,56,34,254,222,1,1,2,23,42,54,33,233,1,34,2,7,6,5,35,43)

#file name, or full path to file if not in the current directory
# C:\myfolder\azsql.txt   OR azsql.txt if already in the C:\myfolder directory
$File = "azsql.txt"
$Password = 'PASSWORD-GOES-HERE' | ConvertTo-SecureString -AsPlainText -Force
$Password | ConvertFrom-SecureString -key $key | Out-File $File


#############   Using an encrypted cred file   ###########
#THESE LINES GO IN YOUR SCRIPT WHICH UTILIZES THE PASSWORD
##########################################################

$Key = (3,4,2,3,56,34,254,222,1,1,2,23,42,54,33,233,1,34,2,7,6,5,35,43)
$passwdFile = "AZSQL.txt"
$acct = "domain\user" # OR "user"
$passwdFile = Get-Content $passwdFile | ConvertTo-SecureString -Key $Key
$cred =  New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $acct,$passwdFile

#>
