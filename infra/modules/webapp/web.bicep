param suffix string
param environment string
param location string


resource asp 'Microsoft.Web/serverfarms@2023-01-01' = {
  name: 'asp-${environment}-${suffix}'
  location: location
  sku: {
    name: 'B1'
    tier: 'Basic'
  }
  properties: {
  }
}

resource web 'Microsoft.Web/sites@2023-01-01' = {
  name: 'web-${environment}-${suffix}'
  location: location
  properties: {
    serverFarmId: asp.id
    httpsOnly: true
    siteConfig: {
      appSettings: [
      ]
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: 'dotnet'
        }
      ]
      netFrameworkVersion: 'v8.0'
      alwaysOn: true
    }
  }  
}

resource srcControls 'Microsoft.Web/sites/sourcecontrols@2021-01-01' = {
  parent: web
  name: 'web'
  properties: {
    repoUrl: 'https://github.com/hugogirard/calculatorApi'
    branch: 'main'
    isManualIntegration: true
  }
}
