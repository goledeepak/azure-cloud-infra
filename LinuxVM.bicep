param virtualMachines_VM_1_Linux_name string = 'VM-1-Linux'
param disks_VM_1_Linux_OsDisk_1_8db44f7d3dcc4885a265f2b8ad97d9d4_externalid string = '/subscriptions/73e331b8-28c4-4be6-b9ab-a4eb4b1ee42e/resourceGroups/central-india-RG/providers/Microsoft.Compute/disks/VM-1-Linux_OsDisk_1_8db44f7d3dcc4885a265f2b8ad97d9d4'
param networkInterfaces_vm_1_linux110_z1_externalid string = '/subscriptions/73e331b8-28c4-4be6-b9ab-a4eb4b1ee42e/resourceGroups/central-india-RG/providers/Microsoft.Network/networkInterfaces/vm-1-linux110_z1'

resource virtualMachines_VM_1_Linux_name_resource 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: virtualMachines_VM_1_Linux_name
  location: 'centralindia'
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
        name: '${virtualMachines_VM_1_Linux_name}_OsDisk_1_8db44f7d3dcc85858585858d4'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
          id: disks_VM_1_Linux_OsDisk_1_8db44f7d3dcc4885a265f2b8ad97d9d4_externalid
        }
        deleteOption: 'Delete'
        diskSizeGB: 30
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_VM_1_Linux_name
      adminUsername: 'deepakgole'
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
      requireGuestProvisionSignal: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_vm_1_linux110_z1_externalid
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
