$data = Import-LocalizedData -BaseDirectory D:\PSScripts\SCCMAppApproval\Resources\ -FileName 9-configdata.psd1 -Verbose



function GetManager {

    Param(
        [string]$ManagerCN
    )
    
    if($ManagerCN){
    
        Get-ADObject $ManagerCN | Get-ADUser -Properties mail | select name,mail

    } else {
        $manager = New-Object PSObject -Property @{
            Name = "App Request Fallback Address"
            Mail = "apprequestfallback@domain.com"
        }
        $manager
    }

}

################################
#########Azure SQL Auth#########
################################

$Key = $data.Cred.Key
$passwdFile = $data.Cred.Path
$acct = $data.Cred.Name
$passwdFile = Get-Content $passwdFile | ConvertTo-SecureString -Key $Key
$cred =  New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $acct,$passwdFile



$sccmquery = @"
SELECT [DisplayName],
    [Unique_User_Name0],
    [NetBios_Name0],
    [Comments],
    [RequestGuid],
	[CurrentState]
FROM v_UserAppRequests

Where CurrentState = 1

"@

########################
##Reference table only##
########################
$SCCMrequestStates = [PSCustomObject]@{
    1 = "Requested"
    2 = "Canceled"
    3 = "Denied"
    4 = "Approved"
}

####################################
#Create New Request Records in Azure
####################################
$openRequests = Invoke-Sqlcmd -ServerInstance "$($data.SCCM.Server)" -Database "$($data.SCCM.Database)" -Query $sccmquery
foreach ($req in $openRequests){
    $spAZSQLFindRecord = @"
EXEC [dbo].[FindRecordByReqGuid] '$($req.RequestGuid)'
"@
   
    $exists = Invoke-Sqlcmd -ServerInstance "$($data.AzureSQL.Server)" -Database "$($data.AzureSQL.DB)" -Username "$($data.Cred.Name)" -Password $cred.GetNetworkCredential().password -Query $spAZSQLFindRecord
    
    if($exists -eq $null){

        $user = ($req.Unique_User_Name0).split('\')[1]
        $user = Get-ADUser $user -Properties manager,mail | select name,mail,samaccountname,manager
        $req | Add-Member -MemberType NoteProperty -Name Approver -Value (GetManager -ManagerCN $user.manager | select -expand mail) -Force
        $req | Add-Member -MemberType NoteProperty -Name RequesterMail -Value $user.mail -Force
        $req | Add-Member -MemberType NoteProperty -Name RequesterName -Value $user.name -Force

        #$req.Approver = GetManager -ManagerCN $user.manager | select -expand mail   

        #$req
        Write-Host "Creating: $($req.RequestGuid)" -ForegroundColor Yellow
        $spAZSQLInsertRecord = @"
EXEC [dbo].[CreateRecord] '$($req.RequestGuid)' , '$($req.Unique_User_Name0)' , '$($req.RequesterMail)' , '$($req.RequesterName)' , '$($req.CurrentState)' , '$($req.Comments)' , '$($req.DisplayName)' , '$($req.Approver)' , 'SendEmail'
"@
        $newRecord = Invoke-Sqlcmd -ServerInstance "$($data.AzureSQL.Server)" -Database "$($data.AzureSQL.DB)" -Username "$($data.Cred.Name)" -Password $cred.GetNetworkCredential().password -Query $spAZSQLInsertRecord
    } else {

        Write-host "Skipping: $($req.RequestGuid)" -ForegroundColor Green
    }
 
}
############################ End Section ###############################
########################################################################


####################################
#######Send Appoval Emails##########
####################################

#Define SQL Stored Procedure
$spNeedApproval = @"
EXEC [dbo].[FindRecordByNextStep] 'SendEmail'
"@


#Define unique Azure Logic App HTTP Request Endpoint URL
$uri = $data.LogicApp.Uri

#Build results object
$needApproval =  Invoke-Sqlcmd -ServerInstance "$($data.AzureSQL.Server)" -Database "$($data.AzureSQL.DB)" -Username "$($data.Cred.Name)" -Password $cred.GetNetworkCredential().password -Query $spNeedApproval


foreach ($req in $needApproval){
    
    #Create JSON Request body object from each record's properties
    $body = ConvertTo-Json @{
      Approver = $req.Approver
      RequesterMail = $req.RequesterMail
      RequesterName = $req.RequesterName
      DisplayName = $req.DisplayName
      Unique_User_Name0 = $req.Unique_User_Name0
      NetBios_Name0 = $req.NetBios_Name0
      Comments = $req.Comments
      RequestGuid = $req.RequestGuid
      CurrentState = $req.CurrentState
    }

    #Post the JSON request to the Azure Logic App HTTP Request Endpoint URL
    Invoke-RestMethod -uri $uri -Method Post -body $body -ContentType 'application/json' -Verbose

    #Define SQL Stored Procedure
    $spUpdateRecord = @"
EXEC [dbo].[UpdateRecord] '$($req.RequestGuid)' , 'EmailSent'
"@

    #Update Request status in Azure SQL table
    $needApproval =  Invoke-Sqlcmd -ServerInstance "$($data.AzureSQL.Server)" -Database "$($data.AzureSQL.DB)" -Username "$($data.Cred.Name)" -Password $cred.GetNetworkCredential().password -Query $spUpdateRecord

}
############################ End Section ###############################
########################################################################



##########################################
#########Process Approved Requests########
##########################################

#Define SQL Stored Procedure
$spAZSQLFindApprovedRequests = @"
EXEC [dbo].[FindRecordByNextStep] 'Approved'
"@


$approvedReqs = Invoke-Sqlcmd -ServerInstance "$($data.AzureSQL.Server)" -Database "$($data.AzureSQL.DB)" -Username "$($data.Cred.Name)" -Password $cred.GetNetworkCredential().password -Query $spAZSQLFindApprovedRequests

foreach ($approvedReq in $approvedReqs){

    #process on-prem
$approveInSCCM = @"
USE $($data.SCCM.Database);
GO
UPDATE v_UserAppRequests
SET CurrentState = '4'
WHERE RequestGuid = '$($approvedReq.RequestGuid)'
GO
"@

    $completedReqsSCCM = Invoke-Sqlcmd -ServerInstance "$($data.SCCM.Server)" -Database "$($data.SCCM.Database)" -Query $approveInSCCM

    #process in azure

    $spUpdateRecord = @"
EXEC [dbo].[UpdateRecord] '$($approvedReq.RequestGuid)' , 'ApprovedComplete'
"@

    $completedReqsAzure = Invoke-Sqlcmd -ServerInstance "$($data.AzureSQL.Server)" -Database "$($data.AzureSQL.DB)" -Username "$($data.Cred.Name)" -Password $cred.GetNetworkCredential().password -Query $spUpdateRecord

}
############################ End Section ###############################
########################################################################



##########################################
##########Process Denied Requests#########
##########################################
$spAZSQLFindDeniedRequests = @"
EXEC [dbo].[FindRecordByNextStep] 'Denied'
"@

$deniedReqs = Invoke-Sqlcmd -ServerInstance "$($data.AzureSQL.Server)" -Database "$($data.AzureSQL.DB)" -Username "$($data.Cred.Name)" -Password $cred.GetNetworkCredential().password -Query $spAZSQLFindDeniedRequests

foreach ($deniedReq in $deniedReqs){

    #process on-prem
$denyInSCCM = @"
USE $($data.sccm.Database);
GO
UPDATE v_UserAppRequests
SET CurrentState = '3'
WHERE RequestGuid = '$($deniedReq.RequestGuid)'
GO
"@

    $completedReqsSCCM = Invoke-Sqlcmd -ServerInstance "$($data.SCCM.Server)" -Database "$($data.SCCM.Database)" -Query $denyInSCCM

    #process in azure

    $spUpdateRecord = @"
EXEC [dbo].[UpdateRecord] '$($deniedReq.RequestGuid)' , 'DeniedComplete'
"@

    $completedReqsAzure = Invoke-Sqlcmd -ServerInstance "$($data.AzureSQL.Server)" -Database "$($data.AzureSQL.DB)" -Username "$($data.Cred.Name)" -Password $cred.GetNetworkCredential().password -Query $spUpdateRecord

}
############################ End Section ###############################
########################################################################
