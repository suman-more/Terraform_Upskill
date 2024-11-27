variable "region" {
  description = "Region details"
  type        = string
}
variable "context" {
  description = "Context details"
  type        = string
}
variable "system" {
  description = "System details"
  type        = string
}
variable "env" {
  description = "Environment details"
  type        = string
}

variable "location" {
  description = "Location details"
  type        = string
}
variable "component" {
  description = "Component details"
  type        = string
}

variable "tags" {
  description = "Tags for the resource"
  type        = map(string)
}
variable "resource_group_name" {
  description = "resource group details"
  type        = string
}
variable "publisher_email" {
  default     = "test@contoso.com"
  description = "The email address of the owner of the service"
  type        = string
  validation {
    condition     = length(var.publisher_email) > 0
    error_message = "The publisher_email must contain at least one character."
  }
}

variable "publisher_name" {
  default     = "publisher"
  description = "The name of the owner of the service"
  type        = string
  validation {
    condition     = length(var.publisher_name) > 0
    error_message = "The publisher_name must contain at least one character."
  }
}

variable "sku" {
  description = "The pricing tier of this API Management service"
  type        = string
  validation {
    condition     = contains(["Consumption", "Developer", "Basic", "Standard", "Premium"], var.sku)
    error_message = "The sku must be one of the following: Developer, Standard, Premium."
  }
}

variable "sku_count" {
  description = "The instance size of this API Management service."
  type        = number
  validation {
    condition     = contains([1, 2], var.sku_count)
    error_message = "The sku_count must be one of the following: 1, 2."
  }
}

variable "keyvault_roles" {
  description = "Roles requierd for keyvault"
  type        = list(string)
}

variable "keyvault_prefix" {
  description = "keyvault_prefix"
  type        = string
  default     = "-dk"
}

variable "genai_dev_user_ids" {
  description = "The user id for the APIM contributor"
  type        = list(string)
}

