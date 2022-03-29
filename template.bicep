param location string = resourceGroup().location
param namePrefix string = 'testtfbicep'

resource helloWorld 'Microsoft.Storage/storageAccounts@2021-08-01' = {
  location: location
  name: '${namePrefix}st'
  kind: 'Storage'
  sku:{
    name: 'Standard_LRS'
  }
}
