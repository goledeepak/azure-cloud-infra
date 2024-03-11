param location string = 'centralindia'

@description('Virtual Network resource group name')
param vnetResourceGroupName string = 'central-india-RG'

@description('Virtual Network name')
param vnetName string = 'VNET-Devops'

@description('Virtual Network subnet name')
param vnetSubnetName string = 'PrivateSubnet'


param virtualMachines_machine1_name string = 'VM-AZ1'
param virtualMachines_machine2_name string = 'VM-AZ2'



// Import the existing vnet and subnet to get the subnet id for deployment
resource vnet 'Microsoft.Network/virtualNetworks@2022-11-01' existing = {
  name: vnetName
  scope: resourceGroup(vnetResourceGroupName)
}

resource privateSubnet 'Microsoft.Network/virtualNetworks/subnets@2022-11-01' existing = {
  name: vnetSubnetName
  parent: vnet
}

resource networkInterface1 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: 'networkInterfaceVM-AZ1'
  location: location  
  properties: {
    ipConfigurations: [
      {
        name: 'name1981546985'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: privateSubnet.id
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
        name: 'name20152019'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: privateSubnet.id
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
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
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
      computerName: 'machine-strorag'
      adminUsername: 'deepakgole'
      adminPassword: 'deepakgole@1981834'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
          enableHotpatching: false
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
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_machine2_name}_OsDisk_1_4c4ea6a621b743c5bd36e07a1373745e'
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
      computerName: 'machine-strorag'
      adminUsername: 'deepakgole'
      adminPassword: 'deepakgole@1981834'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
          enableHotpatching: false
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
