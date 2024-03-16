param location string = 'centralindia'

@description('Virtual Network resource group name')
param vnetResourceGroupName string = 'central-india-RG'

@description('Virtual Network name')
param vnetName string = 'VNET-Devops'

@description('Virtual Network subnet name')
//param vnetSubnetName string = 'PrivateSubnet'
param vnetSubnetName string = 'PublicSubnet'
param virtualMachines_machine1_name string = 'VM-AZ1'
param virtualMachines_machine2_name string = 'VM-AZ2'

var cloudInit = base64(loadTextContent('cloud-init.txt'))
var cloudInit1 = base64(loadTextContent('cloud-init1.txt'))



// Import the existing vnet and subnet to get the subnet id for deployment
resource vnet 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetResourceGroupName)
}

resource publicSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  name: vnetSubnetName
  parent: vnet
}

resource publicIPAddress 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: 'publicIPAddress-${virtualMachines_machine1_name}'
  location: location  
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'//         
  }
}

resource publicIPAddress1 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: 'publicIPAddress-${virtualMachines_machine2_name}'
  location: location  
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
    dnsSettings: {
      domainNameLabel: 'publicipforcloud1'
    }    
  }
}


// resource applicationGateway 'Microsoft.Network/applicationGateways@2023-09-01' existing = {
//   name: 'appGateWay'
// }


// resource loadBalancerVMPools 'Microsoft.Network/loadBalancers/backendAddressPools@2023-09-01' existing = {
//   name: '${applicationGateway.id}/VMPools'
// }


resource networkInterface1 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: 'networkInterfaceVM-AZ1'
  location: location  
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfiguration-${virtualMachines_machine1_name}'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          applicationGatewayBackendAddressPools: [
            {
              id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', 'appGateWay', 'VMPools')
            }
          ]
          // publicIPAddress: {
          //   id: publicIPAddress.id            
          // }
          subnet: {
            id: publicSubnet.id
          }
        }
      }
    ]
  }
}


resource networkInterface2 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: 'networkInterfaceVM-AZ2'
  location: location  
  properties: {
    ipConfigurations: [
      {
        name: 'ipConfiguration-${virtualMachines_machine2_name}'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          applicationGatewayBackendAddressPools: [
            {
              id: resourceId('Microsoft.Network/applicationGateways/backendAddressPools', 'appGateWay', 'VMPools')
            }
          ]
          // publicIPAddress: {
          //   id: publicIPAddress1.id            
          // }
          subnet: {
            id: publicSubnet.id
          }
        }
      }
    ]
  }
}





resource virtualMachines_machine_resource1 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: virtualMachines_machine1_name
  location: location
  zones: ['1']
  properties: {    
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_machine1_name}_OsDisk_1_4c4ea6a621b743c5bd36e07a1373745e'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Standard_LRS'          
        }
        deleteOption: 'Delete'
        diskSizeGB: 127
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: 'machine-linux'
      adminUsername: 'deepakgole'
      adminPassword: 'deepakgole@1981834'
      customData: cloudInit
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'AutomaticByPlatform'
          automaticByPlatformSettings: {
            rebootSetting: 'IfRequired'
            bypassPlatformSafetyChecksOnUserSchedule: false
          }
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: false
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {      
      networkInterfaces: [
        {
          id: networkInterface1.id
          properties: {
            deleteOption: 'Delete' 
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
    
  }
}




resource virtualMachines_machine_resource2 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: virtualMachines_machine2_name
  location: location
  zones: ['2']
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_machine2_name}_OsDisk_2_22222225bd36e07a1373745e'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Standard_LRS'          
        }
        deleteOption: 'Delete'
        diskSizeGB: 127
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: 'machine-linux'
      adminUsername: 'deepakgole'
      adminPassword: 'deepakgole@1981834'
      customData: cloudInit1
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'AutomaticByPlatform'
          automaticByPlatformSettings: {
            rebootSetting: 'IfRequired'
            bypassPlatformSafetyChecksOnUserSchedule: false
          }
          assessmentMode: 'ImageDefault'
        }
        enableVMAgentPlatformUpdates: false
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterface2.id
          properties: {
            deleteOption: 'Delete'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

