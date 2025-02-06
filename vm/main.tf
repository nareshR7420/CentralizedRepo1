# terraform/main.tf
# Reference the existing resource group
data "azurerm_resource_group" "example" {
  name = var.resource_group_name
}
provider "azurerm" {
  features {}
  subscription_id = var.subscriptin_id
  client_id       = var.client_id
  clientsecret  = var.client_secret
  tenant_id      = var.tenant_id
}

module "vm" {
  source = "./modules/vm"

  resource_group_name      = data.azurerm_resource_group.example.name
  location                 = data.azurerm_resource_group.example.location
  vm_name                  = var.vm_name
  vm_size                  = var.vm_size
  admin_username           = var.admin_username
  admin_password           = var.admin_password
  #public_ip_name           = var.public_ip_name
  virtual_network_name     = var.virtual_network_name
  #address_space            = var.address_space  # Pass the list directly
  address_space = ["10.0.0.0/16"]
  subnet_name              = var.subnet_name
  subnet_address_prefix    = "10.0.1.0/24"
}
// # Output the web app URL (Make sure the 'webapp' module has an output 'url')
// output "webapp_url" {
//   value = module.webapp.url
// }

// output "vm_url" {
//   value = module.vm.url
// }
