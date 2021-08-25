[cmdletbinding()]
param(
    [parameter()]
    [string]$SubscriptionId,
    [parameter()]
    [string]$Location
)

#Set the subscription context
Set-AzContext -Subscription $SubscriptionId

#Create the target resource group if it does not exist
$resourceGroupName = 'rg-networking-dev01'
Get-AzResourceGroup -Name $resourceGroupName -ErrorVariable notPresent -ErrorAction SilentlyContinue
if ($notPresent)
{
    # ResourceGroup doesn't exist
    New-AzResourceGroup -Name "$resourceGroupName" -Location $Location
}
else
{
    # ResourceGroup exist
    Write-Host "Resource Group exists, exiting" 
}


