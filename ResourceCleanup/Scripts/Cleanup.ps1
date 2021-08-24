[cmdletbinding()]
param(
    [parameter()]
    [string]$SubscriptionId
)

#Set the subscription context
Set-AzContext -Subscription $SubscriptionId

#This script removes all components of the virtual wan Setup

#Remove all resources by deploying and emtpy template using Complete mode
$resourceGroupName = 'rg-networking-dev01'
 New-AzResourceGroupDeployment -Name "cleanup-$resourceGroupName" -ResourceGroupName $resourceGroupName `
 -TemplateFile .\ResourceCleanup\Template\Cleanup.json -Mode Complete -Force -AsJob

#Remove all resource groups
 Remove-AzResourceGroup -Name $resourceGroupName  -Force
