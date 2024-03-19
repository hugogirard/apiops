param location string
param environment string
param suffix string

param publisherEmail string
param publisherName string

resource apim 'Microsoft.ApiManagement/service@2021-04-01-preview' = {
  name: 'apim-${environment}-${suffix}'
  location: location
  sku: {
    capacity: 0
    name: 'Consumption'
  }
  properties: {
    publisherEmail: publisherEmail
    publisherName: publisherName
  }
}
