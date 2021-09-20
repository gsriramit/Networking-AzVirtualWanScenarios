# Scenario-1 (Single Region vWan with Any-To-Any Communication)
This scenario deploys the virtual-wan with 1 virtual hub in a single region. The configuration is straight forward to allow any-any communication.
The communication between the branches and between the azure virtual networks can be enabled/disabled using the following vwan config values
```
"properties": {
                "allowVnetToVnetTraffic": true,
                "allowBranchToBranchTraffic": true,
                "type": "[variables('vwan_cfg').type]"
            }
```  
## Routing
Only one route table, the **"DefaultRouteTable"** is used to accomplish the any to any routing in this setup.
All the azure virtual networks and the branches are **associated to** and **propagate to** the default route table. This helps in each entity learning about every other connection in the setup (azure networks and branches). The 2-way arrows in the architecture diagram are indicative of this behavior.  
**Note**: 
1. The branches can be associated only to the Default Route table but can propagate to custom route tables in addition to the default
2. If you have multiple branches (ER-Connection, RemoteUser-Connection, Site-Site VPN-Connection) then each of these branches should propagate to the Default route table so as to learn about the rest of the branches, their address ranges (through BGP) and the Virtual-Hub connection resource that would be used to establish the connection 

## Target State Architecture

![SingleRegionWan-BaseSetup](https://user-images.githubusercontent.com/13979783/131256466-8e460ad7-6944-4976-82e6-aacf84d98fb3.png)

