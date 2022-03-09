# tfstate

This must be run once to create a remote storage for the Terraform state file.

## `terraform init`

```shell
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/random...
- Finding hashicorp/azurerm versions matching "2.46.0"...
...
```

## `terraform plan`

```shell
$ terraform plan -out terraform.tfplan
...
Saved the plan to: terraform.tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "terraform.tfplan"
```

## `terraform apply`

```shell
$ terraform apply terraform.tfplan
random_string.resource_code: Creating...
...
azurerm_storage_container.tfstate: Creation complete after 1s [id=https://tfstate7e81aags.blob.core.windows.net/tfstate]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

storage_account_name = "xantaraitggf4ga07"
storage_container_name = "tfstate"
```

These last two values are used in the other Terraform modules to store the terraform state in an Azure Storage Container.

Use the shell script to store the *Azure Resource Manager Access Key* in an environment variable.

```shell
$ source access_key.sh
$ echo $ARM_ACCESS_KEY
/k**********************************************************************************Gw==
```

```shell
$ az storage container show --account-name xantaraitggf4ga07 --name tfstate --output table

There are no credentials provided in your command and environment, we will query for account key for your storage account.
It is recommended to provide --connection-string, --account-key or --sas-token in your command as credentials.

You also can add `--auth-mode login` in your command to use Azure Active Directory (Azure AD) for authorization if your login account is assigned required RBAC roles.
For more information about RBAC roles in storage, visit https://docs.microsoft.com/azure/storage/common/storage-auth-aad-rbac-cli.

In addition, setting the corresponding environment variables can avoid inputting credentials in your command. Please use --help to get more information about environment variable usage.
Name     Lease Status    Last Modified
-------  --------------  -------------------------
tfstate  unlocked        2022-03-09T19:15:25+00:00
```
