# Scenario-3 (Single Region vWan with Isolated Vnets)
This scenario deploys the virtual-wan with 1 virtual hub in a single region. The configuration does not allow the Azure Virtual Networks to be communicating with each but with all the associated branches. The Branches on the other hand can communicate with all the Vnets connected to the hub.  
Implementation Reference: [Isolating Vnets](https://docs.microsoft.com/en-us/azure/virtual-wan/scenario-isolate-vnets)  
**Note**: This section of the repo helps in testing the aforementioned scenario but with a single-region vWan. The single region deployment is adopted so as to 
1. Save cost from not having to deploy all 3 branch gateways in both the regions and
2. Ease of deployment- This is expected to complete sooner than a multi-region deployment 

## Routing
1. Virtual networks:
   - Associated route table: RT_VNET
   - Propagating to route tables: Default
2. Branches:
   - Associated route table: Default
   - Propagating to route tables: RT_VNET and Default  

### Associations and Propagations
1. In the target state architecture, the one-way blue-colored arrows from the vnets indicate that the vnets propagate to the default route table. This would add 10.10.0.0/16 and 10.11.0.0./16 address ranges to the RT
2. The two-way blue-colored arrows from the branches to the Default RT indicate that the branches are associated to and also propagate to this RT
3. The one-way orange-colored arrows from the branches to the Custom route table (**HUB_RT_VNET**) indicate that the branches propagate to the custom route table but are not associated to the same
4. The one-way orange-colored arrows from the Custom route table (**HUB_RT_VNET**) to the vnets indicate the association of the RT with the Vnets. This means that the routes that are populated in this custom RT would be the ones that the vnets would have routes to
   - In this case only the branches propagate to the Custom route table. The Vnets do not. This makes the Vnets isolated from each other but have access to all the branches 

## Target State Architecture

![AzureNetworkingConcepts - VirtualWan-IsolatedVnets](https://user-images.githubusercontent.com/13979783/134009716-44a3185c-a84e-4a2a-9f00-f77289ec26ce.png)


