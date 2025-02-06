# variables.tf

variable "resource_group_name" {
  description = "The name of the Azure resource group"
  type        = string
  default     = "vam-rg-nov"
}

variable "location" {
  type        = string
  description = "The location for the resources"
  validation {
    condition     = var.location == "East US"
    error_message = "The location must be East US."
  }
}

variable "app_service_plan_name" {
  description = "The name of the App Service Plan"
  type        = string
  default     = "java-springboot-plan"
}

variable "web_app_name" {
  description = "The name of the Web App"
  type        = string
  default     = "java-springboot-jpa-docker-azure"
}

variable "sku_size" {
  description = "The size of the App Service Plan (e.g., B1, S1, P1V2)"
  type        = string
  default     = "B1"  # Example SKU size
}

variable "os_type" {
  description = "The OS type of the App Service Plan"
  type        = string
  default     = "Windows"  # Use "Windows" for a Windows app
}
variable "vm_name" {
  description = "The name of the virtual machine."
  type        = string
}

variable "vm_size" {
  description = "The size of the virtual machine."
  type        = string
}

variable "admin_username" {
  description = "The admin username for the virtual machine."
  type        = string
}

variable "admin_password" {
  description = "The admin password for the virtual machine."
  type        = string
  sensitive   = true
}

// variable "public_ip_name" {
//   description = "The name of the public IP for the VM."
//   type        = string
// }

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
}

variable "subnet_address_prefix" {
  description = "The address prefix for the subnet"
  type        = string
}
variable "virtual_network_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "address_space" {
  description = "The address space for the virtual network"
  type        = list(string)
}
variable "subscription_id" {
  type        = string
  default     = "f936a180-7b93-4203-8faa-f376529bd4f8"  # Use "Windows" for a Windows app
}
variable "client_id" {
  type        = string
  default     = "a2d89136-b086-4755-9f98-af856c2d8c30"  # Use "Windows" for a Windows app
}
variable "client_secret" {
  type        = string
 }
variable "tenant_id" {
  type        = string
  default     = "13085c86-4bcb-460a-a6f0-b373421c6323"  # Use "Windows" for a Windows app
}
# Define the Key Vault name (assuming Key Vault is created manually)
variable "key_vault_name" {
  description = "The name of the Azure Key Vault"
  type        = string
  default     = "GitHubKVault"  # Name of your manually created Key Vault
}

# Define the name of the secret to store in Key Vault
variable "secret_name" {
  description = "The name of the secret to store in Key Vault"
  type        = string
  default     = "clientsecret1"
}
