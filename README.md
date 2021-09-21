# Networking-AzVirtualWanScenarios
This Repository contains majority of the Azure virtual Wan architectures and playground scenarios that have been documented in Microsoft's docs. Navigate to the official vwan documentation from the link below and locate the scenarios in **Concepts/Routing scenarios** menu-[Microsoft virtual wan](https://docs.microsoft.com/en-us/azure/virtual-wan/)

## Map of the scenarios in this repository

| Repo Folder                                        | Scenario                                                                                                                                                                                                                                                                                                                   |
|----------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 01-BaseSetup-SingleRegion                          | virtual wan setup in a single region with 3 branches and 4 azure virtual networks. Supports any to any communication                                                                                                                                                                                                       |
| 02-BaseSetup-MultiRegion                           | virtual wan setup in two regions with branches and azure vnets in both the regions. Supports any to any global transit architecture. [Global Transit Network Architecture with az vwan](https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/virtual-wan/virtual-wan-global-transit-network-architecture.md) |
| 03-Singleregion-IsolatedVnets                      | virtual wan setup in a single region with isolated azure virtual networks using a custom route table                                                                                                                                                                                                                       |
| 04-Singleregion-IsolatedVnets-Custom                      | virtual wan setup in a single region with isolated groups of azure virtual networks using multiple custom route tables & labels                                                                                                                                                                                            |
| 05-Singleregion-IsolatedVnetsNBranchesWithFirewall | secure virtual wan setup in a single region with inbuilt azure firewall. The routing setup involves packet examination for traffic between the az-vnets to the branches and vice-versa. Additonal criteria to restrict the traffic from selected vnets to a category of branch locations                                   |

## RRAS to simulate a Site to Site VPN Connection
In a lab setup, Microsoft's RRAS (Routing & Remote Access Server) can be used to establish a site to site VPN connection. If you want to understand how a S2S connection works in general, I have written a blog that has captured the important details-[Working of S2S VPN](https://ramsaztechbytes.in/2021/05/07/azure-s2s-vpn-exploration-with-rras/)  
The blog also has an internal reference to a youtube video that helps you setup the S2S VPN connection using a VM that runs RRAS (probably in your laptop)-[Setting up S2S with RRAS](https://www.youtube.com/watch?v=Ty4O51U_0Ds&t=266s)  

### Setting up the S2S VPN Connection for BGP Peering with Azure VirtualWAN
The steps to create a BGP connection between the RRAS and the Azure VPN Gateway have been provided in the [CommonScripts/RRAS Setup](CommonScripts/RRAS-Setup/README.md)

## Hyrbid Connections
I have modified the base template from Azure's Github repo to also include the hybrid network connection resources. 
### ER Connection
We need to create a resource of type **Microsoft.Network/expressRouteGateways/expressRouteConnections** that connects the Express Route Circuit with the Azure Express Route Gateway. If the express route circuit is in a different subscription, as it would be in any Enterprise scenario, we will need to mention the subscriptionId of the circuit and the authorization key to complete this connection.  
```
  "authorizationKey": "[parameters('expressRouteConnectionAuthKey')]",
                "expressRouteCircuitPeering": {
                    "id": "[concat('/subscriptions/',parameters('expressRouteCircuitSubscriptionId'),'/resourceGroups/',parameters('expressRouteCircuitPeeringRg'),'/providers/Microsoft.Network/expressRouteCircuits/', parameters('expressRouteCircuitName'), '/peerings/AzurePrivatePeering')]"
                },
```
### S2S VPN Connection
A resource of type **Microsoft.Network/vpnSites** needs to be created to establish the S2S VPN Connection. This resource would represent the LocalNetworkGateway in a regular S2S VPN connection using Azure VPN Gateway. Make sure that you configure the VPN site with **BGP enabled** and you choose a BGP ASN that does not collide with the Azure reserved public and private ASNs. In this lab, the BGP peer Ip would be the private Ip Address of the RRAS VM.
The VPN site resource needs to be mapped to the VPN Gateway connections

```
 "connections": [
                    {
                        "name": "[parameters('siteConnectionName')]",
                        "properties": {
                            "connectionBandwidth": 10,
                            "enableBgp": "[parameters('enableBgp')]",
                            "remoteVpnSite": {
                                "id": "[resourceId('Microsoft.Network/vpnSites', parameters('vpnsitename'))]"
                            },
                            "routingConfiguration": {
                                    ...
                            }
                        }
                    }
                ],
```

## Dependencies Map
| Resource                                          | Dependencies                                                                                                                                                                                                                                       |
|---------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Virtual Hubs                                      | Virtual WAN                                                                                                                                                                                                                                        |
| VPN Site                                          | Virtual WAN                                                                                                                                                                                                                                        |
| Virtual Network Connections with the regional Hub | a. Virtual Hub b. Virtual Network that is connecting to the hub and c. S2S VPN Gateway in the same region. Note: The S2S VPN Gateway is a mandatory dependency if the Azure Networks need to use the gateway transit feature to reach the branches |
| S2S VPN Gateway                                   | Regional Virtual hub                                                                                                                                                                                                                               |
| Express Route Gateways                            | Virtual network connections to the regional hub. **Cascading Dependencies** - dependency of the vnet connections on the vnets and the s2s vpn gateway                                                                                              |
| Express Route Connections                         | Express Route Gateway that the circuit is connecting to                                                                                                                                                                                            |
| VPN Server Config (P2S VPN Connection)            | Express Route Gateway in the same region                                                                                                                                                                                                           |
| P2S VPN Gateways                                  | VPN Server Configurations                                                                                                                                                                                                                          |

## GitHub Actions for Deployment
If you do not have a dedicated DevOps setup for the deployment of the ARM templates, you can use the workflow files provided in this repo. The following table provides a mapping of the workflows to the scenarios.  
**Note**: The actions are dependent on the following data and are to be saved as secrets in the repository
1. An Azure Service Principal that has access to the target environment
2. The subscription Id of the target subscription
3. Resource Group to which the resources would be deployed
4. Any other secure information that needs to be read from the secrets

| Scenario                                           | Workflow file                                             |
|----------------------------------------------------|-----------------------------------------------------------|
| 01-BaseSetup-SingleRegion                          | deploySingleregionWanResources.yml                        |
| 02-BaseSetup-MultiRegion                           | deployMultiregionWanResources.yml                         |
| 03-Singleregion-IsolatedVnets                      | deploySingleregion-IsolatedVnets.yml                      |
| 04-Singleregion-IsolatedVnets-Custom               | deploySingleregion-IsolatedVnets-Custom.yml               |
| 05-Singleregion-IsolatedVnetsNBranchesWithFirewall | deploySingleregion-IsolatedVnetsNBranchesWithFirewall.yml |
| Deploy Test VMs in the Azure Spokes                | deploytestresources.yml                                   |

