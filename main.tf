provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "haseeb_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "haseeb_vnet" {
  name                = "haseeb-vnet"
  address_space       = ["10.100.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.haseeb_rg.name
}

resource "azurerm_subnet" "haseeb_subnet" {
  name                 = "haseeb-subnet"
  resource_group_name  = azurerm_resource_group.haseeb_rg.name
  virtual_network_name = azurerm_virtual_network.haseeb_vnet.name
  address_prefixes     = ["10.100.1.0/24"]
}

resource "azurerm_public_ip" "haseeb_public_ip" {
  name                = "haseeb-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.haseeb_rg.name
  allocation_method   = "Dynamic"
}

resource "azurerm_network_interface" "haseeb_nic" {
  name                = "haseeb-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.haseeb_rg.name

  ip_configuration {
    name                          = "haseeb-ipconfig"
    subnet_id                     = azurerm_subnet.haseeb_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.haseeb_public_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "haseeb_vm" {
  name                  = "haseeb-vm"
  resource_group_name   = azurerm_resource_group.haseeb_rg.name
  location              = var.location
  size                  = "Standard_B1s"
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.haseeb_nic.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  disable_password_authentication = true
}

output "public_ip_address" {
  value = azurerm_public_ip.haseeb_public_ip.ip_address
}
