
#Get info of the s2s vpn interface
$azS2SVpnInterface = Get-VpnS2SInterface -Name AzureVHubS2SConnection

# Update the S2S VPN Interface (VPN GW's public IP and the CIDR would have changed)
# Feed the updated private ip address spaces in the CIDR:Metric-Weight format
$ipv4SubnetAddresses = @('10.100.0.0/20:10')
Set-VpnS2SInterface -Name AzureVPNS2SConnection -Destination 40.119.238.198 -IPv4Subnet $ipv4SubnetAddresses

#Set-VpnS2SInterface -Name AzureVPNS2SConnection -Destination 52.230.36.36 -IPv4Subnet 10.0.0.0/16:10

#Enable BGP Router on this RRAS Server
Add-BgpRouter -BgpIdentifier 192.168.29.52 -LocalASN 65050


#Add-BgpPeer -Name AzureVPN -LocalIPAddress 192.168.29.52 -PeerIPAddress 10.50.5.14 -LocalASN 65050 -PeerASN 65010

Add-BgpPeer -Name AzureVPN -LocalIPAddress 192.168.29.52 -PeerIPAddress 10.100.0.13 -LocalASN 65050 -PeerASN 65515


#route ADD -p 10.50.0.0 MASK 255.255.0.0 192.168.29.52
#route ADD -p 10.50.5.14 MASK 255.255.255.255 192.168.29.52


Get-BgpPeer

Get-BgpRouteInformation

Add-BgpCustomRoute -Network 192.168.29.52/32 -PassThru

Add-BgpCustomRoute -Network 192.168.29.50/32 -PassThru

Remove-BgpPeer -Name AzureVPN