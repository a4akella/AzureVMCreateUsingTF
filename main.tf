# Define Azure Provider source and version to be used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
   features {}
   subscription_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
   client_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
   client_secret = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
   tenant_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}

# Create a resource group
resource "azurerm_resource_group" "rg1" {
  name     = var.rgname
  location = var.rglocation
}

resource "azurerm_network_security_group" "nsg1" {
  name                = var.nsg_name
  location            = "${azurerm_resource_group.rg1.location}"
  resource_group_name = "${azurerm_resource_group.rg1.name}"
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "SSH"
  priority                    = 1001
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.rg1.name}"
  network_security_group_name = "${azurerm_network_security_group.nsg1.name}"
}
resource "azurerm_virtual_network" "vnet1" {
  name                = var.vnet_name
  location            = "${azurerm_resource_group.rg1.location}"
  resource_group_name = "${azurerm_resource_group.rg1.name}"
  address_space = [var.vnet_cidr_prefix]
 }

resource "azurerm_subnet" "subnet1" {
  name                 = var.subnet_name
  resource_group_name  = "${azurerm_resource_group.rg1.name}"
  virtual_network_name = "${azurerm_virtual_network.vnet1.name}"
  address_prefixes     = [var.subnet_cidr_prefix]
  #network_security_group_id = "${azurerm_network_security_group.nsg1.id}"
  depends_on = [azurerm_virtual_network.vnet1]
}

resource "azurerm_network_interface" "nic1" {
  name                = var.nic_name
  location            = "${azurerm_resource_group.rg1.location}"
  resource_group_name = "${azurerm_resource_group.rg1.name}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_subnet.subnet1.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.pubIp1.id}"
  }
 }

 resource "azurerm_public_ip" "pubIp1" {
  name                = var.pub_ip
  resource_group_name = "${azurerm_resource_group.rg1.name}"
  location            = "${azurerm_resource_group.rg1.location}"
  allocation_method   = "Static"
  sku = "Standard"
}

resource "azurerm_network_interface_security_group_association" "nic_nsg_assoc" {
  network_interface_id      = azurerm_network_interface.nic1.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}

resource "azurerm_linux_virtual_machine" "vm1" {
  name                = var.vm_name
  computer_name       = var.computer_name
  resource_group_name = "${azurerm_resource_group.rg1.name}"
  location            = "${azurerm_resource_group.rg1.location}"
  size                = var.vm_size
  admin_username      = var.user_name
  network_interface_ids = [
    "${azurerm_network_interface.nic1.id}",
  ]

  admin_ssh_key {
    username   = var.user_name
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    sku       = "18.04-lts"
    offer     = "UbuntuServer"
    version   = "latest"
  }
}
