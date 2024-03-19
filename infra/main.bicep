targetScope = 'subscription'

@minLength(4)
@description('Azure Resource Group Name')
param resourceGroupName string

@minLength(1)
@description('Primary location for all resources')
param location string

@description('The email of the APIM admin')
@secure()
param publisherEmail string

@description('The name of the Publisher (Company) for APIM')
param publisherName string

var suffix = uniqueString(subscription().id)

resource rgDev 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-apim-dev'
  location: location
}

resource rgProd 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: 'rg-apim-prod'
  location: location
}

module apimDev 'modules/apim/apim.bicep' = {
  scope: resourceGroup(rgDev.name)  
  name: 'apim-dev'
  params: {
    environment: 'dev'
    location: location
    publisherEmail: publisherEmail
    publisherName: publisherName
    suffix: suffix
  }
}

module apimProd 'modules/apim/apim.bicep' = {
  scope: resourceGroup(rgProd.name)  
  name: 'apim-prod'
  params: {
    environment: 'prod'
    location: location
    publisherEmail: publisherEmail
    publisherName: publisherName
    suffix: suffix
  }
}


module webappDev 'modules/webapp/web.bicep' = {
  scope: resourceGroup(rgDev.name)
  name: 'web-dev'
  params: {
    environment: 'dev'
    location: location
    suffix: suffix
  }
}


module webappProd 'modules/webapp/web.bicep' = {
  scope: resourceGroup(rgProd.name)
  name: 'web-prod'
  params: {
    environment: 'prod'
    location: location
    suffix: suffix
  }
}
