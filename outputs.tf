output "nat_gateway" {
  value       = azurerm_nat_gateway.nat_gateway
  description = <<DESCRIPTION
  * `id` - The IDs of the subnet NAT gateway associations.
  * `name` - Specifies the name of the NAT gateway.
  * `resource_group_name` - The name of the Resource Group where this NAT gateway should exist
  * `location` - Specifies the supported Azure location where the NAT gateway should exist.
  * `idle_timeout_in_minutes` -Specifies the timeout for the TCP idle connection.
  * `sku_name` - The SKU which should be used.
  * `zones` - Specifies a list of Availability Zones in which this NAT Gateway should be located.
  * `tags` - A mapping of tags assigned to the NAT gateway.

Example output:
```
output "name" {
  value = module.module_name.nat_gateway.name
}
```
DESCRIPTION
}
