resource "azurerm_resource_group" "example" {
  name     = "rg-nat-gateway-example"
  location = "germanywestcentral"
}

module "nat_gateway" {
  source = "../../"

  name                = "nat-gateway-example"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}
