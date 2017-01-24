@{
    Cred = @{
        Name = 'myUserName'
        Type = "key" #Options None, key, cert, windows auth. Need to add logic for windows/cert/none.
        Key = "(3,4,2,3,56,34,254,222,1,1,2,23,42,54,33,233,1,34,2,7,6,5,35,43)"
        Path = "D:\PSScripts\SCCMAppApproval\Resources\azsql.txt"
    }

    PasswordEncryption = "key" 
    AzureSQL = @{
        Server = "myAzureSQLServer.database.windows.net"
        DB = "Orchestrator"
    }
    SCCM = @{
        Server = 'mySCCMServer.domain.local'
        Database = 'CM_DEV'
    }
    LogicApp = @{
        Uri = "https://prod-04.westus.logic.azure.com:443/workflows/abcd/triggers/manual/run?api-version=2016-06-01&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=blah"
    }
}
