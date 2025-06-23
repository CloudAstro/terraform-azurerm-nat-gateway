resource "azurerm_nat_gateway" "nat_gateway" {
  name                    = var.name
  location                = var.location
  resource_group_name     = var.resource_group_name
  sku_name                = var.sku_name
  idle_timeout_in_minutes = var.idle_timeout_in_minutes
  zones                   = var.zones
  tags                    = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []

    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
      read   = timeouts.value.read
      update = timeouts.value.update
    }
  }
}

# Association of NAT gateway with a map of subnet(s)
resource "azurerm_subnet_nat_gateway_association" "subnet_nat_gateway_association" {
  for_each = var.subnet_association != null ? var.subnet_association : {}

  subnet_id      = each.value.subnet_id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}

# Association of NAT gateway with Public IP Prefix - either this one xor the one below with public IP
resource "azurerm_nat_gateway_public_ip_prefix_association" "nat_gateway_public_ip_prefix_association" {
  for_each = var.public_ip_prefix_association != null ? { "this" = var.public_ip_prefix_association } : {}

  nat_gateway_id      = azurerm_nat_gateway.nat_gateway.id
  public_ip_prefix_id = each.value.public_ip_prefix_id
}

# Association of NAT gateway with Public IP
resource "azurerm_nat_gateway_public_ip_association" "nat_gateway_public_ip_association" {
  for_each = var.public_ip_association != null ? { "this" = var.public_ip_association } : {}

  nat_gateway_id       = azurerm_nat_gateway.nat_gateway.id
  public_ip_address_id = each.value.public_ip_address_id
}

resource "azurerm_management_lock" "nat_gateway_lock" {
  for_each = var.management_lock != null ? { for key, value in var.management_lock : key => value } : {}

  name       = each.value.name
  scope      = azurerm_nat_gateway.nat_gateway.id
  lock_level = each.value.lock_level
  notes      = each.value.notes

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = timeouts.value.create
      read   = timeouts.value.read
      delete = timeouts.value.delete
    }
  }
}

resource "azurerm_role_assignment" "role_assignment" {
  for_each = var.role_assignments != null ? var.role_assignments : {}

  principal_id                           = each.value.role_assignment.principal_id
  scope                                  = azurerm_nat_gateway.nat_gateway.id
  condition                              = each.value.role_assignment.condition
  condition_version                      = each.value.role_assignment.condition_version
  delegated_managed_identity_resource_id = each.value.role_assignment.delegated_managed_identity_resource_id
  principal_type                         = each.value.role_assignment.principal_type
  role_definition_id                     = each.value.role_assignment.role_definition_id_or_name
  role_definition_name                   = each.value.role_assignment.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.role_assignment.skip_service_principal_aad_check
}
