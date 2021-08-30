#Get info of the s2s vpn interface
$azS2SVpnInterface = Get-VpnS2SInterface -Name AzureVHubS2SConnection

# Update the S2S VPN Interface (VPN GW's public IP and the CIDR would have changed)
# Feed the updated private ip address spaces in the CIDR:Metric-Weight format
$ipv4SubnetAddresses = @('10.100.0.0/20:10')
Set-VpnS2SInterface -Name AzureVPNS2SConnection -Destination 40.119.238.198 -IPv4Subnet $ipv4SubnetAddresses

#Set-VpnS2SInterface -Name AzureVPNS2SConnection -Destination 52.230.36.36 -IPv4Subnet 10.0.0.0/16:10

#Enable BGP Router on this RRAS Server
Add-BgpRouter -BgpIdentifier 192.168.29.52 -LocalASN 65050

# Add BGP Pering between this instance of RRAS and the Azure VPN Gateway
# Use the GW's public Ip address & the BGP Peer IP address from the downloaded VPN config file
Add-BgpPeer -Name AzureVPN -LocalIPAddress 192.168.29.52 -PeerIPAddress 10.100.0.13 -LocalASN 65050 -PeerASN 65515

# Advertise the routes that the hub needs to learn
Add-BgpCustomRoute -Network 192.168.29.0/24 -PassThru

# Get the information of the BGP peer (VPN Gateway) and the connection status
Get-BgpPeer

# Get the route information learnt from the hub by this instance of VPN Server
Get-BgpRouteInformation

# Command to remove the BGP Peer. Use this everytime you do a fresh deploy of the hub and hence the VPN connection.
# Remove-BgpPeer -Name AzureVPN
