variable "name" {
  type        = string
  description = <<DESCRIPTION
  * `name` - (Required) Specifies the name of the NAT gateway. Changing this forces a new NAT gateway to be created.

  Example Input:
  ```
  name = "nat-gateway-example"
  ```
  DESCRIPTION
}

variable "resource_group_name" {
  type        = string
  description = <<DESCRIPTION
  * `resource_group_name` - (Required) The name of the Resource Group where this NAT gateway should exist. Changing this forces a new NAT gateway to be created

  Example Input:
  ```
  resource_group_name = "rg-nat-gateway-example"
  ```
  DESCRIPTION
}

variable "location" {
  type        = string
  default     = null
  description = <<DESCRIPTION
  * `location` - (Required) Specifies the supported Azure location where the NAT gateway should exist. Changing this forces a new resource to be created.

  Example Input:
  ```
  location = "ger-west-central"
  ```
  DESCRIPTION
}

variable "idle_timeout_in_minutes" {
  type    = number
  default = 4
  validation {
    condition     = var.idle_timeout_in_minutes >= 4 && var.idle_timeout_in_minutes <= 120
    error_message = "idle_timeout_in_minutes must be between 4 and 120 minutes."
  }
  description = <<DESCRIPTION
  * `idle timeout in minutes` - (Optional) Specifies the timeout for the TCP idle connection. The value can be set between 4 and 120 minutes. A NAT gateway provides a configurable idle timeout range of 4 minutes to 120 minutes for TCP protocols. UDP protocols have a nonconfigurable idle timeout of 4 minutes.

  Example Input:
  ```
  idle_timeout_in_minutes = 8
  ```
  DESCRIPTION
}

variable "sku_name" {
  type        = string
  default     = "Standard"
  description = <<DESCRIPTION
  * `sku_name` - (Optional) The SKU which should be used. At this time the only supported value is Standard. Defaults to Standard.

  Example input:
  ```
  sku_name = "Standard"
  ```
  DESCRIPTION
}

variable "zones" {
  type        = list(string)
  default     = null
  description = <<DESCRIPTION
  * `zones` - (Optional) Specifies a list of Availability Zones in which this NAT Gateway should be located. Changing this forces a new NAT Gateway to be created.

  Example input:
  ```
  zones = ["1", "2", "3"]
  ```
  DESCRIPTION
}

variable "tags" {
  type        = map(any)
  default     = null
  description = <<DESCRIPTION
  * `tags` - (Optional) A mapping of tags to assign to the resource.

  Example Input:
  ```
  tags = {
    foo = bar
  }
  ```
  DESCRIPTION
}

variable "timeouts" {
  type = object({
    create = optional(string)
    update = optional(string)
    read   = optional(string)
    delete = optional(string)
  })
  default     = null
  description = <<DESCRIPTION
  * `create` - (Defaults to 60 minutes) Used when creating the NAT Gateway.
  * `read`   - (Defaults to  5 minutes) Used when retrieving the NAT Gateway.
  * `update` - (Defaults to 60 minutes) Used when updating the NAT Gateway.
  * `delete` - (Defaults to 60 minutes) Used when deleting the NAT Gateway.

  Example Input:
  ```
  timeouts = {
    create = "1h",
    read   = "5m",
    update = "1h",
    delete = "1h"
  }
  ```
  DESCRIPTION
}

variable "subnet_association" {
  type = map(object({
    subnet_id = string
    }
  ))
  default     = null
  description = <<DESCRIPTION
  * `subnet_association` - (Optional) A map that Specifies the IDs of all the Subnets that this NAT Gateway should be connected to. Changing this forces a new resource to be created.
    * `subnet_id` - (Required) - The Azure Resource ID for the subnet to be associated to this NAT Gateway

  Example Input:
  ```
  subnet_association = {
    subnet_1 = {
        subnet_id = "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Network/virtualNetworks/<vnet-name>/subnets/<subnet-name>"
    }
  }
  ```
  DESCRIPTION
}

variable "public_ip_association" {
  type = object({
    nat_gateway_id       = optional(string)
    public_ip_address_id = string
  })
  default     = null
  description = <<DESCRIPTION
  * `public_ip_association` - (Optional) Object-variable to chose between associating a public IP address (vs. public IP prefix) with the NAT gateway. Set the attribute `public_ip_address_id` to the respective ID in case of using a (single) public IP address for the NAT gateway.

  Example Input:
  ```
  public_ip_association = {
    public_ip_address_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-name/providers/Microsoft.Network/publicIPAddresses/public-ip-name"
  }
  ```
  DESCRIPTION
}

variable "public_ip_prefix_association" {
  type = object({
    nat_gateway_id      = optional(string)
    public_ip_prefix_id = string
  })
  default     = null
  description = <<DESCRIPTION
  * `public_ip_prefix_association` - (Optional) Object-variable  to chose between associating a public IP prefix (vs. a single public IP address) with the NAT gateway. Set the attribute `public_ip_prefix_id` to the respective ID in case of using a public IP prefix for the NAT gateway.

  Example Input:
  ```
  public_ip_prefix_association = {
    public_ip_prefix_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-name/providers/Microsoft.Network/publicIPPrefixes/public-ip-prefix-name"
  }
  ```
  DESCRIPTION
}

# management_lock
variable "management_lock" {
  type = map(object({
    name       = string
    scope      = optional(string)
    lock_level = string
    notes      = optional(string)
    timeouts = optional(object({
      create = optional(string, "30")
      read   = optional(string, "5")
      delete = optional(string, "30")
    }))
  }))
  default     = null
  description = <<DESCRIPTION
  * `management_lock` - (Optional) The `management_lock` block resource as defined below.
    * `name` - (Required) Specifies the name of the Management Lock. Changing this forces a new resource to be created.
    * `scope` - (Required) Specifies the scope at which the Management Lock should be created. Changing this forces a new resource to be created.
    * `lock_level` - (Required) Specifies the Level to be used for this Lock. Possible values are `CanNotDelete` and `ReadOnly`. Changing this forces a new resource to be created.

    ~> **Note:** `CanNotDelete` means authorized users are able to read and modify the resources, but not delete. `ReadOnly` means authorized users can only read from a resource, but they can't modify or delete it.
    * `notes` - (Optional) Specifies some notes about the lock. Maximum of 512 characters. Changing this forces a new resource to be created.

  The `timeouts` block allows you to specify [timeouts](https://www.terraform.io/language/resources/syntax#operation-timeouts) for certain actions:
    * `create` - (Defaults to 30 minutes) Used when creating the Management Lock.
    * `read` - (Defaults to 5 minutes) Used when retrieving the Management Lock.
    * `delete` - (Defaults to 30 minutes) Used when deleting the Management Lock.

    Example Input:
    ```
    management_lock = {
      lock1 = {
        name       = "lock1"
        lock_level = "ReadOnly"
        notes      = "This is a test lock"
      }
    }
    ```
DESCRIPTION
}

variable "role_assignments" {
  type = map(object({
    name                                   = optional(string)
    scope                                  = string
    role_definition_id                     = optional(string)
    role_definition_name                   = optional(string)
    principal_id                           = string
    principal_type                         = optional(string)
    condition                              = optional(string)
    condition_version                      = optional(string)
    delegated_managed_identity_resource_id = optional(string)
    description                            = optional(string)
    skip_service_principal_aad_check       = optional(bool, false)
  }))
  default     = null
  description = <<DESCRIPTION
  * `role_assignments` - (Optional) A map of role assignments to create on the NAT gateway. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time. See `var.role_assignments` for more information
  The following arguments are supported:
    * `name` - (Optional) A unique UUID/GUID for this Role Assignment - one will be generated if not specified. Changing this forces a new resource to be created.
    * `scope` - (Required) The scope at which the Role Assignment applies to, such as `/subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333`, `/subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup`, or `/subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup/providers/Microsoft.Compute/virtualMachines/myVM`, or `/providers/Microsoft.Management/managementGroups/myMG`. Changing this forces a new resource to be created.
    * `role_definition_id` - (Optional) The Scoped-ID of the Role Definition. Changing this forces a new resource to be created. Conflicts with `role_definition_name`.
    * `role_definition_name` - (Optional) The name of a built-in Role. Changing this forces a new resource to be created. Conflicts with `role_definition_id`.
    * `principal_id` - (Required) The ID of the Principal (User, Group or Service Principal) to assign the Role Definition to. Changing this forces a new resource to be created.
    ~> **NOTE:** The Principal ID is also known as the Object ID (ie not the "Application ID" for applications).
    * `principal_type` - (Optional) The type of the `principal_id`. Possible values are `User`, `Group` and `ServicePrincipal`. Changing this forces a new resource to be created. It is necessary to explicitly set this attribute when creating role assignments if the principal creating the assignment is constrained by ABAC rules that filters on the PrincipalType attribute.
    ~> **NOTE:** If one of `condition` or `condition_version` is set both fields must be present.
    * `condition` - (Optional) The condition that limits the resources that the role can be assigned to. Changing this forces a new resource to be created.
    * `condition_version` - (Optional) The version of the condition. Possible values are `1.0` or `2.0`. Changing this forces a new resource to be created.
    * `delegated_managed_identity_resource_id` - (Optional) The delegated Azure Resource Id which contains a Managed Identity. Changing this forces a new resource to be created.
    ~> **NOTE:** this field is only used in cross tenant scenario.
    * `description` - (Optional) The description for this Role Assignment. Changing this forces a new resource to be created.
    * `skip_service_principal_aad_check` - (Optional) If the `principal_id` is a newly provisioned `Service Principal` set this value to `true` to skip the `Azure Active Directory` check which may fail due to replication lag. This argument is only valid if the `principal_id` is a `Service Principal` identity. Defaults to `false`.
    ~> **NOTE:** If it is not a `Service Principal` identity it will cause the role assignment to fail.

  Example Input:
  ```
  role_assignments = {
    "example_assignment" = {
      role_definition_id_or_name = "Contributor"
      principal_id = "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<identity-name>"
      description = "Assignment for contributor role"
      skip_service_principal_aad_check = false
    }
  }
  ```
  DESCRIPTION
}
