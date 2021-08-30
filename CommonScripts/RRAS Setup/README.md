## Setting up the S2S VPN Connection for BGP Peering with Azure VirtualWAN
For the RRAS to work as a BGP enabled VPN device, the following steps have to be completed. These are added to the Powershell script added to the CommonScripts folder at the root level.  
1. Get the interface object that was used for the S2S connection with the Azure VPN gateway over a demand dial interface
2. Update the IP4 subnet address spaces(the address space of the virtual hub) & the destination IP address of the VPN Gateway
```
#Get info of the s2s vpn interface
$azS2SVpnInterface = Get-VpnS2SInterface -Name AzureVHubS2SConnection

# Update the S2S VPN Interface (VPN GW's public IP and the CIDR would have changed)
# Feed the updated private ip address spaces in the CIDR:Metric-Weight format
$ipv4SubnetAddresses = @('10.100.0.0/20:10')
Set-VpnS2SInterface -Name AzureVPNS2SConnection -Destination 40.119.238.198 -IPv4Subnet $ipv4SubnetAddresses
```
3. Add BGP router to the RRAS instance using its private IP address (the interface that is used to establish the S2S VPN connection) and an ASN that is different from the Azure VPN Gateway's ASN. Also make sure that you do not use the reserved ASNs used by Azure
```
#Enable BGP Router on this RRAS Server
Add-BgpRouter -BgpIdentifier 192.168.29.52 -LocalASN 65050
```
4. Add the Azure VPN Gateway instance as a BGP Peer to this VPN server
```
Add-BgpPeer -Name AzureVPN -LocalIPAddress 192.168.29.52 -PeerIPAddress 10.100.0.13 -LocalASN 65050 -PeerASN 65515
```
5. Advertise the routes that the virtual hub needs to learn from this branch connection
```
Add-BgpCustomRoute -Network 192.168.29.0/24 -PassThru
```
6. Get the information of the BGP Peer and the connection status
![AzureBgpPeerInformation](https://user-images.githubusercontent.com/13979783/131363690-0e4664b9-9c59-4bea-a03d-58790636a802.png)
7. Get the information of the routes learnt from the Virtual Hub
![AzureBgpPeerRoutingInformation](https://user-images.githubusercontent.com/13979783/131363721-71351a37-26d4-4dda-962b-8e252b46f0b1.png)  
Note: You will be having more routes than those shown in the image depending on your setup
