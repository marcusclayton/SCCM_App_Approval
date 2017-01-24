# _________________________________________________________
## HTTP Post to this URL:
# _________________________________________________________

![picture alt](https://mcautomationgitresources.blob.core.windows.net/images/logicApp-sccm-01.png "HTTP POST")


### Request Body JSON Schema
```Python
Request Body JSON Schema
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

