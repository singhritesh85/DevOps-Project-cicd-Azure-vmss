provider "azurerm" {
  subscription_id = "5XXXXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXXXd"
  tenant_id = "XXXXXXXXX9-XXXX-XXXX-XXXX-XXXXXXXXXXXX"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = true    ### All the Resources within the Resource Group must be deleted before deleting the Resource Group.
    }
  }
}
