
RESOURCE_GROUP_NAME=rg-infra
STORAGE_ACCOUNT_NAME=xantaraitggf4ga07

export ARM_ACCESS_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

echo ${ARM_ACCESS_KEY}
