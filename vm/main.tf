# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.64.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "f936a180-7b93-4203-8faa-f376529bd4f8"
  client_id       = "a2d89136-b086-4755-9f98-af856c2d8c30"
  
  tenant_id       = "13085c86-4bcb-460a-a6f0-b373421c6323"
}

# # Validate the location
# resource "null_resource" "validate_location" {
#   count = (var.location != "East US") ? 1 : 0  # Check if location is not "East US"

#   provisioner "local-exec" {
#     command = <<EOT
#       echo "Error: The region (${var.location}) does not match the allowed region (East US)!"
#       echo "Allowed Region: East US"
#       exit 1  # Exit with an error code to stop the apply
#     EOT
#   }
# }

# # Validate the VM size
# resource "null_resource" "validate_vm_size" {
#   count = (var.vm_size != "Standard_B1s") ? 1 : 0  # Check if vm_size is not "Standard_B1s"

#   provisioner "local-exec" {
#     command = <<EOT
#       echo "Error: The VM size (${var.vm_size}) does not match the allowed VM size (Standard_B1s)!"
#       echo "Allowed VM Size: Standard_B1s"
#       exit 1  # Exit with an error code to stop the apply
#     EOT
#   }
# }

# Define the resource group
resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
  # count    = (null_resource.validate_location.count == 0 && null_resource.validate_vm_size.count == 0) ? 1 : 0  # Proceed only if location and vm_size are valid
}
# Define the network security group
resource "azurerm_network_security_group" "example" {
  name                = "example-nsg"
  location            = var.location

  resource_group_name = azurerm_resource_group.example.name
  
  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  depends_on = [azurerm_resource_group.example]  # Ensure the resource group is created first
}

# Define the virtual network
resource "azurerm_virtual_network" "example" {
  name                = var.virtual_network_name
  location            = var.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = var.address_space

  depends_on = [azurerm_resource_group.example]  # Ensure the resource group is created first
}

# Define the subnet
resource "azurerm_subnet" "example" {
  name                 = var.subnet_name
  address_prefixes     = [var.subnet_address_prefix]
  virtual_network_name = azurerm_virtual_network.example.name
  resource_group_name  = var.resource_group_name
}

# Define the network interface
resource "azurerm_network_interface" "example" {
  name                = "example-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Define the virtual machine
resource "azurerm_virtual_machine" "example" {
  count               = (var.vm_name != "" && var.vm_size != "" && var.vm_size == "Standard_B1s" && var.location == "East US") ? 1 : 0
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = var.vm_size

  storage_os_disk {
    name          = "${var.vm_name}-osdisk"
    caching       = "ReadWrite"
    create_option = "FromImage"
    os_type       = "Linux"  # Change to "Windows" for a Windows VM
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username
    admin_password = var.admin_password  # Store this securely
  }

  os_profile_linux_config {
    disable_password_authentication = false  # Set to true if using SSH keys
  }
}
