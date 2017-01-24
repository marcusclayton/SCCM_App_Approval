# _________________________________________________________
## HTTP Post to this URL:

![picture alt](https://mcautomationgitresources.blob.core.windows.net/images/logicApp-sccm-01.png "HTTP POST")


### Request Body JSON Schema
```Python
{
  "$schema": "http://json-schema.org/draft-04/schema#",
  "properties": {
    "Approver": {
      "type": "string"
    },
    "Comments": {
      "type": "string"
    },
    "CurrentState": {
      "type": "string"
    },
    "DisplayName": {
      "type": "string"
    },
    "NetBios_Name0": {
      "type": "string"
    },
    "RequestGuid": {
      "type": "string"
    },
    "RequesterMail": {
      "type": "string"
    },
    "RequesterName": {
      "type": "string"
    },
    "Unique_User_Name0": {
      "type": "string"
    }
  },
  "required": [
    "Approver",
    "RequesterMail",
    "RequesterName",
    "DisplayName",
    "Unique_User_Name0",
    "NetBios_Name0",
    "Comments",
    "RequestGuid",
    "CurrentState"
  ],
  "type": "object"
}
```

# _________________________________________________________
## Send Approval E-Mail:

* Complete the wizard to create an API connection which will be used to send the approval emails (to the manager or designated approval mailbox/distribution list)

![picture alt](https://mcautomationgitresources.blob.core.windows.net/images/logicApp-sccm-02.png "send approval email")


# _________________________________________________________
## Evaluate Condition from Approval E-Mail:

![picture alt](https://mcautomationgitresources.blob.core.windows.net/images/logicApp-sccm-03.png "email Condition")

### Approved?


### Approved = "Yes" :+1:

![picture alt](https://mcautomationgitresources.blob.core.windows.net/images/logicApp-sccm-04.png "approved")

### Denied = "No" :thumbsdown:

![picture alt](https://mcautomationgitresources.blob.core.windows.net/images/logicApp-sccm-05.png "denied")