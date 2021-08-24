[cmdletbinding()]
param(
    [parameter()]
    [string]$SubscriptionId,
    [parameter()]
    [string]$Location
)

#Set the subscription context
Set-AzContext -Subscription $SubscriptionId

#Create the target resource group
$resourceGroupName = 'rg-networking-dev01'
 New-AzResourceGroup -Name "$resourceGroupName" -Location $Location

