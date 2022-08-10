#
# Save access key in an environment variable for Terraform remote state.
#
# $ az storage account list --resource-group xantara-it-rg --output table
#

RESOURCE_GROUP_NAME=xantara-it-rg
STORAGE_ACCOUNT_NAME=xantaraitiw1oy9f6

export ARM_ACCESS_KEY=$(az storage account keys list --resource-group ${RESOURCE_GROUP_NAME} --account-name ${STORAGE_ACCOUNT_NAME} --query '[0].value' -o tsv)
