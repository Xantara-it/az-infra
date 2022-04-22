# Setup steps

## Terraform Remote State

1. Create a remote storage for the terraform state.
   This is done only once. The generated values (_storage account name_ and _storage container name_) are used in the terraform source code.

   See also [README](../src/terraform/tfstate/README.md).

## Environments

1. Create the basic infrastructure.

   See also [README](../src/terraform/infra/README.md).

   If needed, all infrastructure, which is saved in the Terraform state file, is deleted and removed by executing `terraform destroy`.

   Normally, the infrastructure is build once and never deleted. 

1. Create the development environment.

   If needed, the environment can also be destroyed. For example, a testing environment doesn't need to be deployed all te time.

   If needed, the random password `admin_password` can be fetched with `terraform output admin_password`.

   See also [README](../src/terraform/development/README.md).

1. Create the other environments when needed.

