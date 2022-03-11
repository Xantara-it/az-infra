# Setup

## Terraform Remote State

1. Create a remote storage for the terraform state.
   This is done once. The generated values (_storage account name_ and _storage container name_) are used in the following
   terraform code.
   
   See also [README](../src/terraform/tfstate/README.md).

## Environments

1. Create the basic infrastructure.

   See also [README](../src/terraform/infra/README.md).

1. Create the development environment.

   If needed, the environment can also be destroyed. For example, a testing environment doesn't need to be deployed all te time.

   If needed, the random password `admin_password` can be fetched with `terraform output admin_password`.

   See also [README](../src/terraform/development/README.md).
