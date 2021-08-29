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
All the azure virtual networks and the branches are **associated** and **propagate** to the default route table. This helps in each entity learning about every other connection in the setup (azure networks and branches)

## Target State Architecture

![SingleRegionWan-BaseSetup](https://user-images.githubusercontent.com/13979783/131256466-8e460ad7-6944-4976-82e6-aacf84d98fb3.png)

