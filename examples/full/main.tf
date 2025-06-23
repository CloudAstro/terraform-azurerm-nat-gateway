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
