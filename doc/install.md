# Install

## Azure Resource Manager

There are multiple ways to access the Azure Resource Manager (ARM).

* The Azure [portal](https://portal.azure.com) is a web application

* [PowerShell](https://docs.microsoft.com/en-gb/powershell/) (for Windows, MacOS and Linux) is a CLI

* [azure-cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
 is my preferred method, also a CLI

* Mobile app for iOS and Android

* etc...

In essence ARM is accessable via a Rest API, so there are many extentions in
many programming languages. One such language is [Terraform](https://www.terraform.io/downloads).

## Install `az`

```shell
$ az version --out table
Azure-cli    Azure-cli-core    Azure-cli-telemetry
-----------  ----------------  ---------------------
2.34.1       2.34.1            1.0.6
```

`az` is one way to login to the Azurew CLoud.

```shell
$ az login
A web browser has been opened at https://login.microsoftonline.com/organizations/oauth2/v2.0/authorize. Please continue the login in the web browser. If no web browser is available or if the web browser fails to open, use device code flow with `az login --use-device-code`.
[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "${TENANT_ID}",
    "id": "${SUBSCRIPTION_ID}",
    "isDefault": true,
    "managedByTenants": [],
    "name": "${SUBSCRIPTION_NAME}",
    "state": "Enabled",
    "tenantId": "${TENANT_ID}",
    "user": {
      "name": "${USER_EMAIL}",
      "type": "user"
    }
  }
]
```

To check if the correct subscription is connected in Azure Cloud (the default subscription):

```shell
$ az account show --out table
EnvironmentName  HomeTenantId  IsDefault  Name         State    TenantId
---------------  ------------  ---------  -----------  -------  ---------
AzureCloud       ${SUB_ID}     True       ${SUB_NAME}  Enabled  ${SUB_ID}
```

## Install `terraform`

```shell
$ terraform version
Terraform v1.1.7
on darwin_amd64
```

