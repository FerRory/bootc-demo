# Upload VHD blob (local file to storage)
#resource "azurerm_storage_blob" "vhd" {
#  name                   = "bootc-azure.vhd"
#  storage_account_name   = azurerm_storage_account.bootc_sa.name
#  storage_container_name = azurerm_storage_container.bootc_container.name
#  type                   = "Page"
#  source                 = "../../azure-image/output/vpc/disk.vhd"   # local file to upload
#}


#resource "time_sleep" "wait_65_seconds" {
#  depends_on = [azurerm_storage_blob.vhd]
#
#  create_duration = "65s"
#}

# Create image from blob
resource "azurerm_image" "bootc" {
  name                = "bootc-demo"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  os_disk {
    os_type  = "Linux"
    os_state = "Generalized"
    blob_uri = "https://terraformbootcimages.blob.core.windows.net/terraformbootcimages/bootc-azure.vhd"
    storage_type = "Standard_LRS"
  }
  hyper_v_generation  = "V2"

#  depends_on = [time_sleep.wait_65_seconds]
}

resource "azurerm_shared_image_gallery" "bootc" {
  name                = "bootc_image_gallery"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  description         = "Shared images and things."

  tags = {
    Hello = "There"
    World = "Example"
  }
}

resource "azurerm_shared_image" "bootc" {
  name                = "bootc-demo-azure"
  gallery_name        = azurerm_shared_image_gallery.bootc.name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location

  identifier {
    publisher = "custom"
    offer     = "custom-offer"
    sku       = "custom-sku"
  }
  os_type             = "Linux"
  architecture        = "Arm64"
  hyper_v_generation  = "V2"
}

resource "azurerm_shared_image_version" "bootc" {
  name                = "0.0.1"
  gallery_name        = resource.azurerm_shared_image.bootc.gallery_name
  image_name          = resource.azurerm_shared_image.bootc.name
  resource_group_name = resource.azurerm_shared_image.bootc.resource_group_name
  location            = resource.azurerm_shared_image.bootc.location
  managed_image_id    = resource.azurerm_image.bootc.id

  target_region {
    name                   = resource.azurerm_shared_image.bootc.location
    regional_replica_count = 2
    storage_account_type   = "Standard_LRS"
  }
}
