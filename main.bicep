param location string = 'centralus'
param appServicePlanName string = 'bhoomika_app_server'
param appName string = 'Bhoomika${uniqueString(resourceGroup().id)}'
param planTier string = 'Free'
param planSku string = 'F1'
 
resource appServicePlan 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: planSku
    tier: planTier
  }
  properties: {
    reserved: true
  }
}
 
resource webApp 'Microsoft.Web/sites@2024-04-01' = {
  name: appName
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'PYTHON|3.11'
      appCommandLine: 'gunicorn -w 4 -k uvicorn.workers.UvicornWorker main:app'
    }
    httpsOnly: true
  }
}
 
resource sourceControl 'Microsoft.Web/sites/sourcecontrols@2022-03-01' = {
  parent:webApp
  name: 'web'
  properties: {
    repoUrl: 'https://placeholder.git' // You will override this manually via CLI
    branch: 'main'
    isManualIntegration: true
  }
}
 