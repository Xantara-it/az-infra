resource "azurerm_virtual_wan" "vpn" {
  location            = var.location
  resource_group_name = var.rg_name
  name                = "virtual-wan"
  tags                = var.tags
}

resource "azurerm_virtual_hub" "vpn" {
  location            = var.location
  resource_group_name = var.rg_name
  name                = "virtual-hub"
  virtual_wan_id      = azurerm_virtual_wan.vpn.id
  address_prefix      = var.vn_address_space
  tags                = var.tags
}

resource "azurerm_vpn_server_configuration" "vpn" {
  location                 = var.location
  resource_group_name      = var.rg_name
  name                     = "vpn-config"
  vpn_authentication_types = ["Certificate"]

  client_root_certificate {
    name             = "Xantara IT VPN CA"
    public_cert_data = <<EOT
MIIC5jCCAc6gAwIBAgIIFQbY4baR5U0wDQYJKoZIhvcNAQELBQAwETEPMA0GA1UEAxMGVlBOIENB
MB4XDTIyMDQyMTA5MTQxOFoXDTI1MDQyMDA5MTQxOFowETEPMA0GA1UEAxMGVlBOIENBMIIBIjAN
BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA6YYLYD4sXZ7KBoE9Kp+QMoBYG8NTjn+b2A6NEFLY
9G+4qJBi3GNa/WJjF7uxfxp7LZfjyKr87m7NnILOxDd6MSUNKS1LCfxraoSwUJRQdrcEJ8TSc8vK
P6whp4dsDxkx4BQLbnoctjoqRv7/4xX9Rss3/ihanyclQdhu2dnIEhhWhGn8wGZDCVQbhvhbE7di
U1OEtHOP1em4b/AWfFrTo3FERo7nvJ0rZAHLAMa0OggbOFVnl9mvFTjzPdESpVXOUGuqWmlgI6Pu
iLnV6fghZ5OfRtSNKNH+3+RZphcUhTiAYTlyOUJA2cEmeu7VW9Y7QcqwTmdLOydjHwfHAgSXbwID
AQABo0IwQDAPBgNVHRMBAf8EBTADAQH/MA4GA1UdDwEB/wQEAwIBBjAdBgNVHQ4EFgQU/ZVvPB14
rtR8oIeAFx/YXHD3+EkwDQYJKoZIhvcNAQELBQADggEBAHDCcM079rJF+qdXvfQ4AOeJcjd1FGM+
Q6ZMyE6QsK/reJkZyqx7kqobqIQelzn2QFYm5XKG/r3wQhYBiYt23MGYYR0a4MZJzr9BuCMxmQy2
6jp5Acle6TVE8oWsI2+wfCumSWiIkaR09YoD54A9X7eUhn+mQsm1Daq98J8rA7gjf17mxFZUfAcv
ezfMo2PI82/9+0Tf9jP4Y+sugXD9B0qyeGqLTQPMx5pgrhhQ/sCVV9w6TgNIfscjlBZBeMhf9BW3
onTqXM9iPfaHqyurBBD4sTg1UlraGQWqA0UqSbE7KRfPXdZs0JCKszU6o4O+S3q5hgeiVfMnTzty
MmbbLW4=
EOT
  }
  tags = var.tags
}

resource "azurerm_point_to_site_vpn_gateway" "vpn" {
  location                    = var.location
  resource_group_name         = var.rg_name
  name                        = "vpn-gateway"
  virtual_hub_id              = azurerm_virtual_hub.vpn.id
  vpn_server_configuration_id = azurerm_vpn_server_configuration.vpn.id
  scale_unit                  = 1
  connection_configuration {
    name = "vpn-gateway-config"

    vpn_client_address_pool {
      address_prefixes = [
        var.sn_vpnclient_address_space
      ]
    }
  }
  tags = var.tags
}
