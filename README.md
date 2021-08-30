# Networking-AzVirtualWanScenarios
This Repository contains majority of the Azure virtual Wan architectures and playground scenarios that have been documented in Microsoft's docs. Navigate to the official vwan documentation from the link below and locate the scenarios in **Concepts/Routing scenarios** menu  
[Microsoft virtual wan](https://docs.microsoft.com/en-us/azure/virtual-wan/)

## Map of the scenarios in this repository

| Repo Folder                                        | Scenario                                                                                                                                                                                                                                                                                                                   |
|----------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| 01-BaseSetup-SingleRegion                          | virtual wan setup in a single region with 3 branches and 4 azure virtual networks. Supports any to any communication                                                                                                                                                                                                       |
| 02-BaseSetup-MultiRegion                           | virtual wan setup in two regions with branches and azure vnets in both the regions. Supports any to any global transit architecture. [Global Transit Network Architecture with az vwan](https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/virtual-wan/virtual-wan-global-transit-network-architecture.md) |
| 03-Singleregion-IsolatedVnets                      | virtual wan setup in a single region with isolated azure virtual networks using a custom route table                                                                                                                                                                                                                       |
| 04-Singleregion-IsolatedVnets                      | virtual wan setup in a single region with isolated groups of azure virtual networks using multiple custom route tables & labels                                                                                                                                                                                            |
| 05-Singleregion-IsolatedVnetsNBranchesWithFirewall | secure virtual wan setup in a single region with inbuilt azure firewall. The routing setup involves packet examination for traffic between the az-vnets to the branches and vice-versa. Additonal criteria to restrict the traffic from selected vnets to a category of branch locations                                   |
## Overall Architecture (Multi-region vWan)
![AzureNetworkingConcepts - VirtualWan-Multiregion-FlowDiagram](https://user-images.githubusercontent.com/13979783/131320296-f654cdcc-aa45-427c-81c7-3f7e1f4c6e1b.png)  
### Components
1. Virtual WAN 
2. Virtual Hubs in 2 regions (Central India and South East Asia)
3. 2 Azure Virtual Networks per region
4. 1 P2S and 1 S2S connection in region#1 (Central India)
5. 1 P2S and 1 Express Route Connection in region#2 (South East Asia)
6. Virtual Machines in the Azure Spoke Vnets (one per vnet to test the mesh network)
7. Default Route Table

## Routing in an Azure Virtual Wan
Azure virtual wan being a fully managed networking service, manages the connection between the azure spoke networks and the hybrid connections with the branches using a set of gateways and routers. Knowing the components used to establish the routing is very important to better understand vwan under the hoods and for troublsehooting purposes.
The components and their corresponding Ips are captured in this table
| Components                                            | Ips                       |
|-------------------------------------------------------|---------------------------|
| Azure virtual hub router (instances)                  | 10.200.2.4 & 10.200.2.5   |
| Azure S2S VPN Gateway Instances (active-active setup) | 10.200.0.12 & 10.200.0.13 |
| Azure P2S VPN Gateway Instances (active-active setup) | 10.200.0.16 & 10.200.0.17 |
| Azure Express Route Gateway                           | 10.200.0.6                |

The following diagram illustrates the internal components that are used by the Azure Virtual WAN to establish the any-any connectivity with Global Transit Network Architecture
![AzureNetworkingConcepts - VirtualWan-Multiregion-NwArchitecture](https://user-images.githubusercontent.com/13979783/131322409-49aa3a7b-36d9-493a-97e1-ad09ad6768c9.png)

### Next Hop in the Routing Scenarios
The following tables captures the next hop when examining the routing between the components connected to the virtual hub(in the same region and to a paired hub in a different region). This information can be obtained by using a simple **"tracert DestIp"**

| Scenario                                                                  | Next Hop                                                                                                                                                                                                                                                                                |
|---------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Between Virtual Networks connected to the same hub & in the same region   | IP address of the primary  instance of the virtual router (10.200.2.4)                                                                                                                                                                                                                  |
| Betweeen Virtual Networks connected to a paired hub in a different region | IP address of the secondary  instance of the virtual router (10.200.2.5)                                                                                                                                                                                                                |
| Virtual Network to a Branch connected via a S2S connection                | One of the 2 instances of the VPN S2S Gateway (10.200.0.12 or 10.200.0.13)                                                                                                                                                                                                              |
| Virtual Network to a Branch connected via a Express Route Connection      | Express Route Gateway instance (10.200.0.6)                                                                                                                                                                                                                                             |
| Virtual Network to a Branch connected via a P2S VPN Connection            | Connection uses the P2S VPN Gws (10.200.0.16 & 10.200.0.17) to create the tunnel between the user's system & the hub.Routing happens on-link. This is because the address space assigned to the P2S connected entities is from the secondary address space of the hub (172.20.200.0/24) |
| Connection between the branches                                           | Virtual hub uses the gateway of the target connection that the packets are sent to. ER-Gw if the packet is sent from a user to the ER Connected Branch.                                                                                                                                 |


