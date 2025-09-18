


resource "azurerm_network_security_group" "bootc_sg" {
  name                = "bootc-sg"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}

# HTTP
resource "azurerm_network_security_rule" "http" {
  name                        = "http"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.bootc_sg.name
}

# SSH
resource "azurerm_network_security_rule" "ssh" {
  name                        = "ssh"
  priority                    = 1002
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.bootc_sg.name
}




# NSG association
resource "azurerm_subnet_network_security_group_association" "bootc_assoc" {
  subnet_id                 = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.bootc_sg.id
}
