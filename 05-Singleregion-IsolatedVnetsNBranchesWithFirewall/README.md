# Scenario-5 (Single Region vWan with Secure VirtualHub- Isolation between vnets and branches)
This scenario deploys the virtual-wan with 1 virtual hub in a single region. The configuration is similar to the one in the previous scenario except for the propagations and the inclusion of static routes in the route tables 
1. DEFAULT_ROUTE_TABLE and 2 custom route tables namely HUB_RT_VNET1 & HUB_RT_VNET2
2. 3 branch locations (ER Connection, S2S VPN Connection and P2S VPN Connection) that are associated to and propagate to the default route table
   - S2S VPN Connection belongs to Category-1 and the Express Route and P2S Connections belong to Category-2
4. 2 Virtual Networks in Category1 
   - Associated to and Propagate to HUB_RT_VNET1
5. 2 Virtual Networks in Category2
   - Associated to and Propagate to HUB_RT_VNET2
6. Azure Firewall rules that allow traffic between selected set of vnets and branches

Implementation Reference: [Isolating Vnets](https://docs.microsoft.com/en-us/azure/virtual-wan/scenario-isolate-virtual-networks-branches)  
**Note**: This section of the repo helps in testing the aforementioned scenario but with a single-region vWan. The single region deployment is adopted so as to 
1. Save cost from not having to deploy all 3 branch gateways in both the regions and
2. Ease of deployment- This is expected to complete sooner than a multi-region deployment  

## Connectivity Matrix
| From                | To: | Category-1 VNets | Category-2 VNets | Category-2 Branches | Category-1 Branches |
|---------------------|-----|------------------|------------------|---------------------|---------------------|
| Category-1 VNets    | →   | Direct           |                  |                     | AzFW                |
| Category-2 VNets    | →   |                  | Direct           | AzFW                |                     |
| Category-2 Branches | →   |                  | AzFW             | Direct              | Direct              |
| Category-1 Branches | →   | AzFW             |                  | Direct              | Direct              |

## Routing (as per the documentation)
1. Category-1 virtual networks:
   - Associated route table: HUB_RT_VNET1
   - Propagating to route tables: HUB_RT_VNET1
2. Category-2 virtual networks:
   - Associated route table: HUB_RT_VNET2
   - Propagating to route tables: HUB_RT_VNET2
3. Branches:
   - Associated route table: Default
   - Propagating to route tables: Default
4. Static Routes:
Default Route Table: Virtual Network Address Spaces consolidated to 10.0.0.0/8 with the next hop as Azure Firewall
RT_Category-1: 0.0.0.0/0 with the next hop as Azure Firewall  
RT_Category-2: 0.0.0.0/0 with the next hop as Azure Firewall  

### Firewall Network Rules:  
ALLOW RULE **Source Prefix**: Category-1 Branch Address Prefixes **Destination Prefix**: Category-1 VNet Prefixes  
ALLOW RULE **Source Prefix**: Category-2 Branch Address Prefixes **Destination Prefix**: Category-2 VNet Prefixes  
ALLOW RULE **Source Prefix**: Category-1 Vnet Address Prefixes **Destination Prefix**: Category-1 Branch Address Prefixes
ALLOW RULE **Source Prefix**: Category-2 Vnet Address Prefixes **Destination Prefix**: Category-2 Branch Address Prefixes

### Associations and Propagations
1. The two-way blue-colored arrows from the category-1 vnets to the HUB_RT_VNET1 RT indicate that the VNETS are associated to and also propagate to only this RT
2. The two-way green-colored arrows from the category-2 vnets to the HUB_RT_VNET2 RT indicate that the VNETS are associated to and also propagate to only this RT
3. The two-way orange-colored arrows from the Default route table (**HUB_RT_VNET**) to the branches indicate the association to and propagation from the branches to only this RT  

### Packet Routing
1. The blue colored curved arrows denote the path of a packet from the Category-1 Site(S2S Connection) to the Category-1 Vnets. Firewall in the hub being the next hop, examines the packets for the source and destination IP addresses using the network rules before being allowed or dropped.
   -  **Note**: We also need to have a corresponding allow rule in the Firewall for the traffic in the reverse direction, i.e. from the Cat-1 Vnets to the Site. 
2. The green colored curved arrows denote the path of a packet from the Category-2 branches(P2S & ER Connections) to the Category-2 Vnets. Firewall in the hub being the next hop, examines the packets for the source and destination IP addresses using the network rules before being allowed or dropped.
   -  **Note**: We also need to have a corresponding allow rule in the Firewall for the traffic in the reverse direction, i.e. from the Cat-2 Vnets to the Cat-2 branches.  
   -  
## Target State Architecture

![AzureNetworkingConcepts - VirtualWan-IsolatedVnets Branches](https://user-images.githubusercontent.com/13979783/134149586-7425f535-b62f-44fa-97bc-1652f87c8ac3.png)


