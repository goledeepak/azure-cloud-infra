param location string = 'centralindia'
//var applicationGatewayID = resourceId('Microsoft.Network/applicationGateway', 'appGateWay')


resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: 'publicIPAddressAppGtw'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: 'deepakforcloud'
    }
  }
}

// resource pubSubNet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' existing = {
//   name: 'VNET-Devops/PublicSubnet'
// }

resource securityGrpPublic 'Microsoft.Network/networkSecurityGroups@2023-04-01' existing = {
  name: 'securityGrpPublic'
}

resource appGatwaySubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  name: 'VNET-Devops/appGatSubnet'
  properties: {
    addressPrefix: '10.0.1.0/26'    
    networkSecurityGroup: {
      id: securityGrpPublic.id  
    }
  }
}


resource applicationGateway 'Microsoft.Network/applicationGateways@2023-09-01' = {
  name: 'appGateWay'
  location: location
  zones: [
    '1'
    '2'
  ]
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
            id: appGatwaySubnet.id
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
            id: resourceId('Microsoft.Network/applicationGateways/frontendIPConfigurations', 'appGateWay', 'appGwPublicFrontendIpIPv4')
          }
          frontendPort: {
            id: resourceId('Microsoft.Network/applicationGateways/frontendPorts', 'appGateWay', 'port_80')
          }
          protocol: 'Http'
          sslCertificate: null
          customErrorConfigurations: []
        }
      
      }
    ]

    requestRoutingRules: [
      {
        name: 'Port80Rule'
        properties: {
          ruleType: 'Basic'
          httpListener: {
            id: resourceId('Microsoft.Network/applicationGateways/httpListeners', 'appGateWay', 'Port80Listener')
          }
          priority: 1
          backendAddressPool: {
            id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', 'appGateWay', 'VMPools')
          }
          backendHttpSettings: {
            id: resourceId('Microsoft.Network/applicationGateways/backendHttpSettingsCollection', 'appGateWay', 'HTTP80BackendSettings')
          }
        }
      }
    ]

  }
}

output appGateway string = resourceId('Microsoft.Network/applicationGateway', 'appGateWay')

