param location string = 'centralindia'
var applicationGatewayID = resourceId('Microsoft.Network/applicationGateway', 'appGateWay')


resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: 'publicIPAddressAppGtw'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: 'publicipforcloud'
    }
  }
}

resource pubSubNet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' existing = {
  name: 'VNET-Devops/PublicSubnet'
}

resource applicationGateway 'Microsoft.Network/applicationGateways@2023-09-01' = {
  name: 'appGateWay'
  location: location
  properties: {
    sku: {
      capacity: 1      
      name: 'Standard_v2'
      tier: 'Standard_v2'
    }
  gatewayIPConfigurations: [
    {
      name: 'appGatewayIpConfig'
      properties: {
        subnet: {
          id: pubSubNet.id
        }
      }
    }
  ]

  frontendIPConfigurations: [
    {
      name: 'appGwPublicFrontendIpIPv4'
      properties: {
        publicIPAddress: {
          id: publicIPAddress.id
        }
      }
    }
  ]
  
  frontendPorts: [
    {
      name: 'port_80'
      properties:{
        port: 80
      }
    }
  ]
  
  backendAddressPools: [
    {
      name: 'VMPools'
      properties: {
        backendAddresses: [
                  
        ]
      }
    }
  ]

  backendHttpSettingsCollection: [
    {
      name: 'HTTP80BackendSettings'
      properties: {
        port: 80
        protocol: 'Http'
        cookieBasedAffinity: 'Disabled'
        requestTimeout: 20
      }
    }
  ]

  httpListeners: [
    {
      name: 'Port80Listener'
      properties: {
        frontendIPConfiguration: {
          id: applicationGatewayID
        }
        frontendPort: {
          id: resourceId('Microsoft.Network/applicationGateway/frontendPorts', 'appGateWay', 'port_80')
        }
        protocol: 'Http'
        sslCertificate: null
        customErrorConfigurations: []
      }
    
    }
  ]

  }
}

output frontendPort string = resourceId('Microsoft.Network/applicationGateway/frontendPorts', 'appGateWay', 'port_80')
