
resource "azurerm_linux_virtual_machine" "bootcdemo" {
  name                = "bootc-demo"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  size                = "Standard_D2pls_v6"
  admin_username      = "bootc"
  network_interface_ids = [
    azurerm_network_interface.bootcdemo.id
  ]

  admin_ssh_key {
    username   = "bootc"
    public_key = file("~/.ssh/id_rsa.pub") # adjust if needed
  }
  source_image_id = azurerm_shared_image_version.bootc.id
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 20
  }



  boot_diagnostics {
    storage_account_uri = "https://${var.storage_account}.blob.core.windows.net/"
  }
  depends_on = [
    azurerm_storage_account.bootc_sa,
    azurerm_image.bootc
  ]
}

# Create 3 Control Plane NICs with Public IPs and attach to LB backend pool
resource "azurerm_public_ip" "bootcdemo" {
  name                = "bootcdemo-public-ip"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"
}


resource "azurerm_network_interface" "bootcdemo" {
  name                = "bootcdemo-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bootcdemo.id
   
  }
}


