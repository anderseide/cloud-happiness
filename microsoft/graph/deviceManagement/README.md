# Creating a new policy from template

If you want deploy policies using PowerShell, have a peak at this project https://github.com/microsoftgraph/powershell-intune-samples

If you want to just play around with it, combined by learning to use Graph, I favor using the Microsoft Graph Explorer directly. Just remember to activat the needed [permissions](https://developer.microsoft.com/en-us/graph/docs/concepts/permissions_reference).

## windows10NetworkBoundaryConfiguration.json
Remember to replace `<tenantName>` with your own actual tenant name

Replace
```json
"enterpriseCloudResources": [
    {
        "ipAddressOrFQDN": "<tenantName>.sharepoint.com",
        "proxy": null
    },
    {
        "ipAddressOrFQDN": "<tenantName>-my.sharepoint.com",
        "proxy": null
    },
    {
        "ipAddressOrFQDN": "<tenantName>-files.sharepoint.com",
        "proxy": null
    },
    {
        "ipAddressOrFQDN": "<tenantName>-myfiles.sharepoint.com",
        "proxy": null
    }
]
```
with for example
```json
"enterpriseCloudResources": [
    {
        "ipAddressOrFQDN": "mycompany.sharepoint.com",
        "proxy": null
    },
    {
        "ipAddressOrFQDN": "mycompany-my.sharepoint.com",
        "proxy": null
    },
    {
        "ipAddressOrFQDN": "mycompany-files.sharepoint.com",
        "proxy": null
    },
    {
        "ipAddressOrFQDN": "mycompany-myfiles.sharepoint.com",
        "proxy": null
    }
]
```
