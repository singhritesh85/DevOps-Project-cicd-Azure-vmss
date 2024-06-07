###################################### Azure Application Gateway for SonarQube ###############################################

resource "azurerm_public_ip" "public_ip_gateway_sonarqube" {
  name                = "vmss-public-ip-sonarqube"
  resource_group_name = azurerm_resource_group.azure_resource_group.name
  location            = azurerm_resource_group.azure_resource_group.location
  sku                 = "Standard"   ### You can select between Basic and Standard.
  allocation_method   = "Static"     ### You can select between Static and Dynamic.
}

resource "azurerm_application_gateway" "application_gateway_sonarqube" {
  name                = "${var.prefix}-application-gateway-sonarqube"
  resource_group_name = azurerm_resource_group.azure_resource_group.name
  location            = azurerm_resource_group.azure_resource_group.location

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
#   capacity = 2
  }

  autoscale_configuration {
    min_capacity = 1
    max_capacity = 3
  }

  gateway_ip_configuration {
    name      = "sonarqube-gateway-ip-configuration"
    subnet_id = azurerm_subnet.appgtw_subnet.id
  }

  frontend_port {
    name = "${var.prefix}-gateway-subnet-feport-sonarqube"
    port = 80
  }

  frontend_port {
    name = "${var.prefix}-gateway-subnet-feporthttps-sonarqube"
    port = 443
  }

  frontend_ip_configuration {
    name                 = "${var.prefix}-gateway-subnet-feip-sonarqube"
    public_ip_address_id = azurerm_public_ip.public_ip_gateway_sonarqube.id
  }

  backend_address_pool {
    name = "${var.prefix}-gateway-subnet-beap-sonarqube"
    ip_addresses = [azurerm_network_interface.vnet_interface[1].private_ip_address]
  }

  backend_http_settings {
    name                  = "${var.prefix}-gateway-subnet-be-htst-sonarqube"
    cookie_based_affinity = "Disabled"
    path                  = "/"
    port                  = 9000
    protocol              = "Http"
    request_timeout       = 60
    probe_name            = "${var.prefix}-gateway-subnet-be-probe-app1-sonarqube"
  }

  probe {
    name                = "${var.prefix}-gateway-subnet-be-probe-app1-sonarqube"
    host                = "sonarqube.singhritesh85.com"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    protocol            = "Http"
    port                = 9000
    path                = "/"
  }

  http_listener {
    name                           = "${var.prefix}-gateway-subnet-httplstn-sonarqube"
    frontend_ip_configuration_name = "${var.prefix}-gateway-subnet-feip-sonarqube"
    frontend_port_name             = "${var.prefix}-gateway-subnet-feport-sonarqube"
    protocol                       = "Http"
  }

  # HTTP Routing Rule - HTTP to HTTPS Redirect
  request_routing_rule {
    name                       = "${var.prefix}-gateway-subnet-rqrt-sonarqube"
    priority                   = 101
    rule_type                  = "Basic"
    http_listener_name         = "${var.prefix}-gateway-subnet-httplstn-sonarqube"
#    backend_address_pool_name  = "${var.prefix}-gateway-subnet-beap-sonarqube"  ###  It should not be used when redirection of HTTP to HTTPS is configured.
#    backend_http_settings_name = "${var.prefix}-gateway-subnet-be-htst-sonarqube" ###  It should not be used when redirection of HTTP to HTTPS is configured.
    redirect_configuration_name = "${var.prefix}-gateway-subnet-rdrcfg-sonarqube"
  }

  # Redirect Config for HTTP to HTTPS Redirect
  redirect_configuration {
    name = "${var.prefix}-gateway-subnet-rdrcfg-sonarqube"
    redirect_type = "Permanent"
    target_listener_name = "${var.prefix}-lstn-https-sonarqube"    ### "${var.prefix}-gateway-subnet-httplstn"
    include_path = true
    include_query_string = true
  }

  # SSL Certificate Block
  ssl_certificate {
    name = "${var.prefix}-certificate"
    password = "Dexter@123"
    data = filebase64("mykey.pfx")
  }

  # HTTPS Listener - Port 443
  http_listener {
    name                           = "${var.prefix}-lstn-https-sonarqube"
    frontend_ip_configuration_name = "${var.prefix}-gateway-subnet-feip-sonarqube"
    frontend_port_name             = "${var.prefix}-gateway-subnet-feporthttps-sonarqube"
    protocol                       = "Https"
    ssl_certificate_name           = "${var.prefix}-certificate"
  }

  # HTTPS Routing Rule - Port 443
  request_routing_rule {
    name                       = "${var.prefix}-rqrt-https-sonarqube"
    priority                   = 100
    rule_type                  = "Basic"
    http_listener_name         = "${var.prefix}-lstn-https-sonarqube"
    backend_address_pool_name  = "${var.prefix}-gateway-subnet-beap-sonarqube"
    backend_http_settings_name = "${var.prefix}-gateway-subnet-be-htst-sonarqube"
  }

}

############################################## Creation for NSG #######################################################

resource "azurerm_network_security_group" "azure_nsg" {
  count               = var.vm_count
  name                = "${var.prefix}-nsg-${count.index + 1}"
  location            = azurerm_resource_group.azure_resource_group.location
  resource_group_name = azurerm_resource_group.azure_resource_group.name

  security_rule {
    name                       = "azure_nsg1"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "azure_nsg"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9000"
    source_address_prefix      = azurerm_public_ip.public_ip_gateway_sonarqube.ip_address
    destination_address_prefix = "*"
  }

  tags = {
    environment = var.env
  }
}

########################################## Create Public IP and Network Interface #############################################

resource "azurerm_public_ip" "public_ip" {
  count               = var.vm_count
  name                = "${var.prefix}-ip-${count.index + 1}"
  resource_group_name = azurerm_resource_group.azure_resource_group.name
  location            = azurerm_resource_group.azure_resource_group.location
  allocation_method   = var.static_dynamic[0]

  sku = "Standard"   ### Basic, For Availability Zone to be Enabled the SKU of Public IP must be Standard  
  zones = var.availability_zone

  tags = {
    environment = var.env
  }
}

resource "azurerm_network_interface" "vnet_interface" {
  count               = var.vm_count
  name                = "${var.prefix}-nic-${count.index + 1}"
  location            = azurerm_resource_group.azure_resource_group.location
  resource_group_name = azurerm_resource_group.azure_resource_group.name

  ip_configuration {
    name                          = "${var.prefix}-ip-configuration-${count.index + 1}"
    subnet_id                     = azurerm_subnet.vmss_subnet.id
    private_ip_address_allocation = var.static_dynamic[1]
    public_ip_address_id = azurerm_public_ip.public_ip[count.index].id
  }
  
  tags = {
    environment = var.env
  }
}

############################################ Attach NSG to Network Interface #####################################################

resource "azurerm_network_interface_security_group_association" "nsg_nic" {
  count                     = var.vm_count
  network_interface_id      = azurerm_network_interface.vnet_interface[count.index].id
  network_security_group_id = azurerm_network_security_group.azure_nsg[count.index].id

}

######################################################## Create Azure VM ##########################################################

resource "azurerm_linux_virtual_machine" "azure_vm" {
  count                 = var.vm_count
  name                  = "${var.prefix}-vm-${count.index + 1}"
  location              = azurerm_resource_group.azure_resource_group.location
  resource_group_name   = azurerm_resource_group.azure_resource_group.name
  network_interface_ids = [azurerm_network_interface.vnet_interface[count.index].id]
  size                  = var.vm_size
  zone                 = var.availability_zone[0]
  computer_name  = "${var.computer_name}-${count.index + 1}"
  admin_username = var.admin_username
  admin_password = var.admin_password
  custom_data    = filebase64("custom_data.sh")
  disable_password_authentication = false

  #### Boot Diagnostics is Enable with managed storage account ########
  boot_diagnostics {
    storage_account_uri  = ""
  }

  source_image_reference {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "7_9-gen2"
    version   = "latest"
  }
  os_disk {
    name              = "${var.prefix}-osdisk-${count.index + 1}"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb      = var.disk_size_gb
  }

  tags = {
    environment = var.env
  }
}

resource "azurerm_managed_disk" "disk" {
  count                = var.vm_count
  name                 = "${var.prefix}-datadisk-${count.index + 1}"
  location             = azurerm_resource_group.azure_resource_group.location
  resource_group_name  = azurerm_resource_group.azure_resource_group.name
  zone                 = var.availability_zone[0]
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.extra_disk_size_gb
}


resource "azurerm_virtual_machine_data_disk_attachment" "example" {
  count              = var.vm_count
  managed_disk_id    = azurerm_managed_disk.disk[count.index].id
  virtual_machine_id = azurerm_linux_virtual_machine.azure_vm[count.index].id
  lun                ="0"
  caching            = "ReadWrite"
}  
