# Scenario-4 (Single Region vWan with Custom Isolated Vnets)
This scenario deploys the virtual-wan with 1 virtual hub in a single region. The configuration categorizes the virtual networks into 2 groups with each being associated to a custom route table. The Vnets that belong to a group propagate to and are associated to the same custom route table. This makes these vnets accessible from each other.Following would be the split of the components.  
1. DEFAULT_ROUTE_TABLE and 2 custom route tables namely HUB_RT_VNET1 & HUB_RT_VNET2
2. 3 branch locations (ER Connection, S2S VPN Connection and P2S VPN Connection)
3. 2 Virtual Networks in Category1 
   - Associated to and Propagate to HUB_RT_VNET1
4. 2 Virtual Networks in Category2
   - Associated to and Propagate to HUB_RT_VNET2
5. Vnets from both the categories propagate to the default route table. This is needed for the branches to be able to reach the vnets  

Implementation Reference: [Isolating Vnets](https://docs.microsoft.com/en-us/azure/virtual-wan/scenario-isolate-vnets-custom)  
**Note**: This section of the repo helps in testing the aforementioned scenario but with a single-region vWan. The single region deployment is adopted so as to 
1. Save cost from not having to deploy all 3 branch gateways in both the regions and
2. Ease of deployment- This is expected to complete sooner than a multi-region deployment 

## Routing (as per the documentation)
1. Category-1 virtual networks:
   - Associated route table: RT_BLUE
   - Propagating to route tables: RT_BLUE and Default
2. Category-2 virtual networks:
   - Associated route table: RT_RED
   -  Propagating to route tables: RT_RED and Default
3. Branches:
   - Associated route table: Default
   - Propagating to route tables: RT_BLUE, RT_RED and Default 

### Associations and Propagations
1. In the target state architecture, the one-way blue-colored arrows from the category-1 vnets indicate that the vnets propagate to the default route table. This would add 10.10.0.0/16 and 10.11.0.0./16 address ranges to the RT
2. The one-way green-colored arrows from the category-2 vnets indicate that the vnets propagate to the default route table. This would add 10.12.0.0/16 and 10.13.0.0./16 address ranges to the RT
3. The two-way blue-colored arrows from the category-1 vnets to the HUB_RT_VNET1 RT indicate that the VNETS are associated to and also propagate to this RT
4. The two-way green-colored arrows from the category-2 vnets to the HUB_RT_VNET2 RT indicate that the VNETS are associated to and also propagate to this RT
5. The one-way orange-colored arrows from the branches to the Custom route table (**HUB_RT_VNET1**) indicate that the branches propagate to the custom route table but are not associated to the same. The arrows from the branches propagating to the HUB_RT_VNET2 is not shown in the architecture diagram for brevity
6. The two-way orange-colored arrows from the Default route table (**HUB_RT_VNET**) to the branches indicate the association to and propagation from the branches the branches to the RT

## Target State Architecture

![AzureNetworkingConcepts - VirtualWan-CustomIsolatedVnets](https://user-images.githubusercontent.com/13979783/134145243-903a7c31-7d7f-4d53-bb32-4199f3793aac.png)


