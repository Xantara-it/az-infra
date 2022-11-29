#
# Create a public IP for the VPN Gateway
#
resource "azurerm_public_ip" "ip" {
  name                = "${var.name_prefix}-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

#
# Create VPN Gateway
#
resource "azurerm_virtual_network_gateway" "gw" {
  name                = "${var.name_prefix}-gw"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"
  generation    = "Generation1"

  ip_configuration {
    name                          = "vnetGatewayConfig"
    public_ip_address_id          = azurerm_public_ip.ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.gateway.id
  }

  vpn_client_configuration {
    address_space = azurerm_subnet.client-sn.address_prefixes

    root_certificate {
      name             = "Xantara-it-VPN-CA"
      public_cert_data = <<EOF
MIIC/DCCAeSgAwIBAgIIM4kg3ihgiCAwDQYJKoZIhvcNAQELBQAwHDEaMBgGA1UEA
xMRWGFudGFyYSBJVCBWUE4gQ0EwHhcNMjIwODExMDgzMjAzWhcNMjUwODEwMDgzMj
AzWjAcMRowGAYDVQQDExFYYW50YXJhIElUIFZQTiBDQTCCASIwDQYJKoZIhvcNAQE
BBQADggEPADCCAQoCggEBAM6/WHcPW6H8dA6x3sxTW5lfq3PqqfFaVBoDG73AZ2H5
RghYqdmjXfrVee1Rm7L5JcwIULB1u496khHSg0hxdnYJgwI4VP+1EZefcvsyrbeDw
YF+qMjSKMD0PsT4bLFBMB+37/0nDZAUUDHAQR9pb1uTdft/QWefBb5KNHDQYtAx/K
KboyRUOWAXSXr1zEV/ou+mDUTxIFXk7JGTPd2vQ9QqC9jForsXBBp1U0iWgYRnuXJ
zdGeSekgheBLT/Wwz2l5ToRcNOn1vnhFJVH0ArqrkR2Bb5QzEc4omCf5nOe340cLu
UbHkr4o9NWpXUIsMvrQ4cpVfITfD0R7thgRwQikCAwEAAaNCMEAwDwYDVR0TAQH/B
AUwAwEB/zAOBgNVHQ8BAf8EBAMCAQYwHQYDVR0OBBYEFLrzP6NGMYb73RVCYruJJ7
FKJJswMA0GCSqGSIb3DQEBCwUAA4IBAQDA4QFrHH4it+U6+DwbIgTHBM83q0QbA0o
5LVboOeTU2xrlS7kf8BfqZOdC7klKNrl61nq7eQ790gzDGY3Vk0PGauBn5NozXNAh
xlH5KN3lDljtcon45EksLHkYvyJnVeE0ZMC+iq9SYiA6lUMcbxboIhrOO9IjdGst1
RJGMwZzc9Gc/XfSr4BkryrJshrP9FMu6vSOjKY5UpSaP7FkIbyziumgIDX2LnMcGT
ocSABau5UuWZ9PSJUqv58vDB15ZLUfhC+7duVcsUzcxOKKbadlQmwimZMB9CP4IzC
ie3ycHEYKEdhFS3IzXD4YkLNorhB1hCP+HmnbdKjFhKjW5MB6
EOF
    }
  }

  tags = var.tags
}
