
param location string = 'centralindia'


resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'VNET-Devops'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'PublicSubnet'
        properties: {
          addressPrefix: '10.0.0.0/26'
          networkSecurityGroup: {
            id: securityGrpPublic.id  
          }
        }
      } 
      {
        name: 'PrivateSubnet'
        properties: {
          addressPrefix: '10.0.0.64/26' 
          networkSecurityGroup: {
            id: securityGrpPrivate.id
          }         
        }
      }
      {
        name: 'SecureSubnet'
        properties: {
          addressPrefix: '10.0.0.128/26' 
          networkSecurityGroup: {
            id: securityGrpSecure.id
          }         
        }
      }
    ]
  }
}


resource gatewaySubnetOps 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  parent: virtualNetwork
  name: 'GatewaySubnet'
  properties: {
    addressPrefix: '10.0.0.192/26'
  }  
}


resource securityGrpPublic 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'securityGrpPublic'
  location: location
  properties:{
    securityRules:[
      {
        name: 'Allow-WEB-HTTP'
        properties: {
          priority: 200
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '80'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }    
      }      
      {
        name: 'Allow-WEB-HTTPS'
        properties: {
          priority: 300
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '443'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }    
      }
      {
        name: 'Allow-Ports'
        properties: {
          priority: 310
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '0-65535'
          protocol: '*'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }    
      }
    ]
  }
}


resource securityGrpPrivate 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'securityGrpPrivate'
  location: location
  properties:{
    securityRules:[
      {
        name: 'Allow-WEB-HTTP'
        properties: {
          priority: 200
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '80'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }    
      }      
      {
        name: 'Allow-WEB-HTTPS'
        properties: {
          priority: 300
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '443'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }    
      }
    ]
  }
}

resource securityGrpSecure 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'securityGrpSecure'
  location: location
  properties:{
    securityRules:[
     
    ]
  }
}
