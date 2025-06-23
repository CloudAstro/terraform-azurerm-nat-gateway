<!-- BEGINNING OF PRE-COMMIT-OPENTOFU DOCS HOOK -->
# Azure NAT Gateway Terraform Module
[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-blue.svg)](NOTICE) [![Apache V2 License](https://img.shields.io/badge/license-Apache%20V2-orange.svg)](LICENSE) [![OpenTofu Registry](https://img.shields.io/badge/opentofu-registry-yellow.svg)](https://search.opentofu.org/module/cloudastro/nat-gateway/azurerm/)

Azure NAT Gateway is a fully managed and highly resilient Network Address Translation (NAT) service.

This module is designed to create and manage Azure NAT Gateways. Deployments are intentionally made simple with NAT gateways. Attach the NAT gateway to a subnet and public IP address and start connecting outbound to the internet right away
There's zero maintenance and routing configurations required (or \_\_possible\_\_). However, more public IPs or subnets can be added (later) without effect to your existing configuration.

You can use Azure NAT Gateway to let all instances in a private subnet connect outbound to the internet while remaining fully private. Unsolicited inbound connections from the internet aren't permitted through a NAT gateway. Only packets arriving as response packets to an outbound connection can pass through a NAT gateway.

NAT Gateway provides dynamic SNAT port functionality to automatically scale outbound connectivity and reduce the risk of SNAT port exhaustion.

## Features

* Attaches to subnet(s) of Azure Virtual Networks (VNet)
* Attaches to either an Azure public IP address or a public IP address prefix
* Provides a configurable idle timeout range of 4 minutes to 120 minutes for TCP protocols (see [below](#modules))

## Example Usage

This example shows how to create an Azure NAT gateway attached to one public IP address and one subnets.

```hcl
resource "azurerm_resource_group" "example" {
  name     = "rg-nat-gateway-example"
  location = "germanywestcentral"
}

module "vnet" {
  source = "CloudAstro/virtual-network/azurerm"

  name                = "vnet-example"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.20.0.0/24"]
}

module "subnet" {
  source = "CloudAstro/subnet/azurerm"

  name                 = "snet-example"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = module.vnet.virtual_network.name
  address_prefixes     = ["10.20.0.0/25"]
}

module "public_ip" {
  source = "CloudAstro/public-ip/azurerm"

  name                = "pip-example"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
}

module "nat_gateway" {
  source = "../../"

  name                    = "nat-gateway-example"
  resource_group_name     = azurerm_resource_group.example.name
  location                = azurerm_resource_group.example.location
  idle_timeout_in_minutes = 4
  sku_name                = "Standard"
  zones                   = null

  public_ip_association = {
    public_ip_address_id = module.public_ip.publicip.id
  }

  subnet_association = {
    subnet_1 = {
      subnet_id = module.subnet.subnet.id
    }
  }

  tags = {
    environment = "Production"
    owner       = "example-team"
  }
}
```
<!-- markdownlint-disable MD033 -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 4.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_management_lock.nat_gateway_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_nat_gateway.nat_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway) | resource |
| [azurerm_nat_gateway_public_ip_association.nat_gateway_public_ip_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_association) | resource |
| [azurerm_nat_gateway_public_ip_prefix_association.nat_gateway_public_ip_prefix_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/nat_gateway_public_ip_prefix_association) | resource |
| [azurerm_role_assignment.role_assignment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_subnet_nat_gateway_association.subnet_nat_gateway_association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_nat_gateway_association) | resource |

<!-- markdownlint-disable MD013 -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | * `name` - (Required) Specifies the name of the NAT gateway. Changing this forces a new NAT gateway to be created.<br/><br/>  Example Input:<pre>name = "nat-gateway-example"</pre> | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | * `resource_group_name` - (Required) The name of the Resource Group where this NAT gateway should exist. Changing this forces a new NAT gateway to be created<br/><br/>  Example Input:<pre>resource_group_name = "rg-nat-gateway-example"</pre> | `string` | n/a | yes |
| <a name="input_idle_timeout_in_minutes"></a> [idle\_timeout\_in\_minutes](#input\_idle\_timeout\_in\_minutes) | * `idle timeout in minutes` - (Optional) Specifies the timeout for the TCP idle connection. The value can be set between 4 and 120 minutes. A NAT gateway provides a configurable idle timeout range of 4 minutes to 120 minutes for TCP protocols. UDP protocols have a nonconfigurable idle timeout of 4 minutes.<br/><br/>  Example Input:<pre>idle_timeout_in_minutes = 8</pre> | `number` | `4` | no |
| <a name="input_location"></a> [location](#input\_location) | * `location` - (Required) Specifies the supported Azure location where the NAT gateway should exist. Changing this forces a new resource to be created.<br/><br/>  Example Input:<pre>location = "ger-west-central"</pre> | `string` | `null` | no |
| <a name="input_management_lock"></a> [management\_lock](#input\_management\_lock) | * `management_lock` - (Optional) The `management_lock` block resource as defined below.<br/>    * `name` - (Required) Specifies the name of the Management Lock. Changing this forces a new resource to be created.<br/>    * `scope` - (Required) Specifies the scope at which the Management Lock should be created. Changing this forces a new resource to be created.<br/>    * `lock_level` - (Required) Specifies the Level to be used for this Lock. Possible values are `CanNotDelete` and `ReadOnly`. Changing this forces a new resource to be created.<br/><br/>    ~> **Note:** `CanNotDelete` means authorized users are able to read and modify the resources, but not delete. `ReadOnly` means authorized users can only read from a resource, but they can't modify or delete it.<br/>    * `notes` - (Optional) Specifies some notes about the lock. Maximum of 512 characters. Changing this forces a new resource to be created.<br/><br/>  The `timeouts` block allows you to specify [timeouts](https://www.terraform.io/language/resources/syntax#operation-timeouts) for certain actions:<br/>    * `create` - (Defaults to 30 minutes) Used when creating the Management Lock.<br/>    * `read` - (Defaults to 5 minutes) Used when retrieving the Management Lock.<br/>    * `delete` - (Defaults to 30 minutes) Used when deleting the Management Lock.<br/><br/>    Example Input:<pre>management_lock = {<br/>      lock1 = {<br/>        name       = "lock1"<br/>        lock_level = "ReadOnly"<br/>        notes      = "This is a test lock"<br/>      }<br/>    }</pre> | <pre>map(object({<br/>    name       = string<br/>    scope      = optional(string)<br/>    lock_level = string<br/>    notes      = optional(string)<br/>    timeouts = optional(object({<br/>      create = optional(string, "30")<br/>      read   = optional(string, "5")<br/>      delete = optional(string, "30")<br/>    }))<br/>  }))</pre> | `null` | no |
| <a name="input_public_ip_association"></a> [public\_ip\_association](#input\_public\_ip\_association) | * `public_ip_association` - (Optional) Object-variable to chose between associating a public IP address (vs. public IP prefix) with the NAT gateway. Set the attribute `public_ip_address_id` to the respective ID in case of using a (single) public IP address for the NAT gateway.<br/><br/>  Example Input:<pre>public_ip_association = {<br/>    public_ip_address_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-name/providers/Microsoft.Network/publicIPAddresses/public-ip-name"<br/>  }</pre> | <pre>object({<br/>    nat_gateway_id       = optional(string)<br/>    public_ip_address_id = string<br/>  })</pre> | `null` | no |
| <a name="input_public_ip_prefix_association"></a> [public\_ip\_prefix\_association](#input\_public\_ip\_prefix\_association) | * `public_ip_prefix_association` - (Optional) Object-variable  to chose between associating a public IP prefix (vs. a single public IP address) with the NAT gateway. Set the attribute `public_ip_prefix_id` to the respective ID in case of using a public IP prefix for the NAT gateway.<br/><br/>  Example Input:<pre>public_ip_prefix_association = {<br/>    public_ip_prefix_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-name/providers/Microsoft.Network/publicIPPrefixes/public-ip-prefix-name"<br/>  }</pre> | <pre>object({<br/>    nat_gateway_id      = optional(string)<br/>    public_ip_prefix_id = string<br/>  })</pre> | `null` | no |
| <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments) | * `role_assignments` - (Optional) A map of role assignments to create on the NAT gateway. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time. See `var.role_assignments` for more information<br/>  The following arguments are supported:<br/>    * `name` - (Optional) A unique UUID/GUID for this Role Assignment - one will be generated if not specified. Changing this forces a new resource to be created.<br/>    * `scope` - (Required) The scope at which the Role Assignment applies to, such as `/subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333`, `/subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup`, or `/subscriptions/0b1f6471-1bf0-4dda-aec3-111122223333/resourceGroups/myGroup/providers/Microsoft.Compute/virtualMachines/myVM`, or `/providers/Microsoft.Management/managementGroups/myMG`. Changing this forces a new resource to be created.<br/>    * `role_definition_id` - (Optional) The Scoped-ID of the Role Definition. Changing this forces a new resource to be created. Conflicts with `role_definition_name`.<br/>    * `role_definition_name` - (Optional) The name of a built-in Role. Changing this forces a new resource to be created. Conflicts with `role_definition_id`.<br/>    * `principal_id` - (Required) The ID of the Principal (User, Group or Service Principal) to assign the Role Definition to. Changing this forces a new resource to be created.<br/>    ~> **NOTE:** The Principal ID is also known as the Object ID (ie not the "Application ID" for applications).<br/>    * `principal_type` - (Optional) The type of the `principal_id`. Possible values are `User`, `Group` and `ServicePrincipal`. Changing this forces a new resource to be created. It is necessary to explicitly set this attribute when creating role assignments if the principal creating the assignment is constrained by ABAC rules that filters on the PrincipalType attribute.<br/>    ~> **NOTE:** If one of `condition` or `condition_version` is set both fields must be present.<br/>    * `condition` - (Optional) The condition that limits the resources that the role can be assigned to. Changing this forces a new resource to be created.<br/>    * `condition_version` - (Optional) The version of the condition. Possible values are `1.0` or `2.0`. Changing this forces a new resource to be created.<br/>    * `delegated_managed_identity_resource_id` - (Optional) The delegated Azure Resource Id which contains a Managed Identity. Changing this forces a new resource to be created.<br/>    ~> **NOTE:** this field is only used in cross tenant scenario.<br/>    * `description` - (Optional) The description for this Role Assignment. Changing this forces a new resource to be created.<br/>    * `skip_service_principal_aad_check` - (Optional) If the `principal_id` is a newly provisioned `Service Principal` set this value to `true` to skip the `Azure Active Directory` check which may fail due to replication lag. This argument is only valid if the `principal_id` is a `Service Principal` identity. Defaults to `false`.<br/>    ~> **NOTE:** If it is not a `Service Principal` identity it will cause the role assignment to fail.<br/><br/>  Example Input:<pre>role_assignments = {<br/>    "example_assignment" = {<br/>      role_definition_id_or_name = "Contributor"<br/>      principal_id = "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.ManagedIdentity/userAssignedIdentities/<identity-name>"<br/>      description = "Assignment for contributor role"<br/>      skip_service_principal_aad_check = false<br/>    }<br/>  }</pre> | <pre>map(object({<br/>    name                                   = optional(string)<br/>    scope                                  = string<br/>    role_definition_id                     = optional(string)<br/>    role_definition_name                   = optional(string)<br/>    principal_id                           = string<br/>    principal_type                         = optional(string)<br/>    condition                              = optional(string)<br/>    condition_version                      = optional(string)<br/>    delegated_managed_identity_resource_id = optional(string)<br/>    description                            = optional(string)<br/>    skip_service_principal_aad_check       = optional(bool, false)<br/>  }))</pre> | `null` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | * `sku_name` - (Optional) The SKU which should be used. At this time the only supported value is Standard. Defaults to Standard.<br/><br/>  Example input:<pre>sku_name = "Standard"</pre> | `string` | `"Standard"` | no |
| <a name="input_subnet_association"></a> [subnet\_association](#input\_subnet\_association) | * `subnet_association` - (Optional) A map that Specifies the IDs of all the Subnets that this NAT Gateway should be connected to. Changing this forces a new resource to be created.<br/>    * `subnet_id` - (Required) - The Azure Resource ID for the subnet to be associated to this NAT Gateway<br/><br/>  Example Input:<pre>subnet_association = {<br/>    subnet_1 = {<br/>        subnet_id = "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Network/virtualNetworks/<vnet-name>/subnets/<subnet-name>"<br/>    }<br/>  }</pre> | <pre>map(object({<br/>    subnet_id = string<br/>    }<br/>  ))</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | * `tags` - (Optional) A mapping of tags to assign to the resource.<br/><br/>  Example Input:<pre>tags = {<br/>    foo = bar<br/>  }</pre> | `map(any)` | `null` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | * `create` - (Defaults to 60 minutes) Used when creating the NAT Gateway.<br/>  * `read`   - (Defaults to  5 minutes) Used when retrieving the NAT Gateway.<br/>  * `update` - (Defaults to 60 minutes) Used when updating the NAT Gateway.<br/>  * `delete` - (Defaults to 60 minutes) Used when deleting the NAT Gateway.<br/><br/>  Example Input:<pre>timeouts = {<br/>    create = "1h",<br/>    read   = "5m",<br/>    update = "1h",<br/>    delete = "1h"<br/>  }</pre> | <pre>object({<br/>    create = optional(string)<br/>    update = optional(string)<br/>    read   = optional(string)<br/>    delete = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_zones"></a> [zones](#input\_zones) | * `zones` - (Optional) Specifies a list of Availability Zones in which this NAT Gateway should be located. Changing this forces a new NAT Gateway to be created.<br/><br/>  Example input:<pre>zones = ["1", "2", "3"]</pre> | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_nat_gateway"></a> [nat\_gateway](#output\_nat\_gateway) | * `id` - The IDs of the subnet NAT gateway associations.<br/>  * `name` - Specifies the name of the NAT gateway.<br/>  * `resource_group_name` - The name of the Resource Group where this NAT gateway should exist<br/>  * `location` - Specifies the supported Azure location where the NAT gateway should exist.<br/>  * `idle_timeout_in_minutes` -Specifies the timeout for the TCP idle connection.<br/>  * `sku_name` - The SKU which should be used.<br/>  * `zones` - Specifies a list of Availability Zones in which this NAT Gateway should be located.<br/>  * `tags` - A mapping of tags assigned to the NAT gateway.<br/><br/>Example output:<pre>output "name" {<br/>  value = module.module_name.nat_gateway.name<br/>}</pre> |

## Modules

No modules.

## 🌐 Additional Information  

A NAT gateway provides a configurable idle timeout range of 4 minutes to 120 minutes for TCP protocols. UDP protocols have a nonconfigurable idle timeout of 4 minutes.

When a connection goes idle, the NAT gateway holds onto the SNAT port until the connection idle times out. Because long idle timeout timers can unnecessarily increase the likelihood of SNAT port exhaustion, it isn't recommended to increase the TCP idle timeout duration to longer than the default time of 4 minutes. The idle timer doesn't affect a flow that never goes idle.

Further reading about [TCP idle timeout](https://learn.microsoft.com/en-us/azure/nat-gateway/nat-gateway-resource#tcp-idle-timeout).

## 📚 Resources
- [AzureRM Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure NAT Gateway documentation](https://learn.microsoft.com/en-us/azure/nat-gateway/)

## 🧾 License  

This module is released under the **Apache 2.0 License**. See the [LICENSE](./LICENSE) file for full details.
<!-- END OF PRE-COMMIT-OPENTOFU DOCS HOOK -->