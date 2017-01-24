The SCCM Application Approval workflow is a solution which delivers rich e-mail based approvals to the SCCM application request process. Traditionally this experience is managed by an SCCM Administrator purely from within the SCCM console. Using this cloud driven solution, after requesting an application which requires approval, the user's manager will receive a secure, rich, yet simple email with corresponding 'Approve' or 'Deny' buttons, allowing them to take action from any device with access to their corporate email (smart phone, internet browser, outlook client, etc.). After implementing this solution, an example of the email driven approval workflow looks like the image below:

![picture alt](https://mcautomationgitresources.blob.core.windows.net/images/logicApp-sccm-00.png "approval email")

## _________________________________________________________
### Overview

The components which make up the solution are outlined below, including any changes to the source files in this repo.
* Azure SQL
* SCCM
* Azure Logic Apps
* General automation pre-Reqs

## _________________________________________________________
### Azure SQL
* Create an Azure SQL Server and database (example files reference a database named Orchestrator)
  * [This doc](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-get-started) can be referenced (up to, but not including the 'Create new database in the Azur ePortal using Adventure Works LT Sample')

* Connect to the Azure SQL server/databse with SQL Server Management Studio (SSMS)
* Create a new table, with the supporting stored procedures using the TSQL scripts in the Resources folder
  * 1-CreateAzureDBTable.sql
  * 2-Create-SP-CreateRecord.sql
  * 3-Create-SP-FindRecordByNextStep.sql
  * 4-Create-SP-FindRecordByReqGuid.sql
  * 5-Create-SP-UpdateRecord.sql
* Create a credential file which will allow the SCCM Application Approval script to authenticate and connect to the Azure SQL instance.
  * Example showing the process to create and use the cred file is located in the Resources folder
  * 6-createCredFile.ps1
  * **This method should only be used in a lab setting. For production scenarios, setting up Windows Authentication with Azure SQL should be leveraged, or encrypting the credential file with a user certificate issued from an [internal] CA instead of a generic byte array**
  * Credential file (and corresponding key) are used in subsequent steps

## _________________________________________________________
### SCCM
* Ensure the account which will run the scheduled task (PowerShell script) has read and write access to the SCCM database

## _________________________________________________________
### Logic App
* Create an Azure Logic App following the [workflow in the LogicApp.md here](https://github.com/marcusclayton/SCCM_App_Approval/blob/master/LogicApp.md). At a high level, the logic app contains the following steps:
  * HTTP Request --> Send Approval Email --> Check Condition Based on E-Mail Response (Approve or Deny) --> Update Azure SQL Request Status --> Send Notification to user

## _________________________________________________________
### Automation/Pre-Reqs
* Create a scheduled task (disabled for now) which will execute the SCCM Application Approval script. Example task XML file (requires editing) is located in the resources folder
  * 7-scheduledTask.xml
* Copy the SCCM Application Approval script to the script directory referenced by the scheduled task
  * 8-sccmappapproval.ps1
  * Note: The script requires the Active Directory PowerShell module be installed
* Update the corresponding configuration data file located in the resouces directory. This file contains all environment specific dependencies, such as server/database names, authentication info, Logic App URL, etc.
  * 9-configdata.psd1
  * **Other than the script itself, this config data file is the second most important component to the workflow.**