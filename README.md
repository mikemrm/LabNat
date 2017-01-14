# LabNat
LabNat is a small project I worked on, hoping to solve a friends problem. They had recently 
purchased an Intel NUC where they were going to create a VM Lab utilizing ESXi, however they 
wanted to make this lab very portable.

Seeing as the Intel NUC was a very small computer, they wanted to be able to bring it around 
with them, whether that be to a presentation, meeting or friends house. They wanted all VMs 
to talk to each other in a Host Only mode, but also be able to access all VMs from an IP 
address in the hosting persons network.

Through much over thinking, I attempted to solve this with pfSense 1:1 Nat. However pfsense 
didn't allow for the wan interface to be DHCP, due to this we began thinking of other 
solutions.

This led me to build LabNat, a DHCP to Static 1:1 Nat. It will grab the list of internal ips, 
and request dhcp addresses for them from the wan network.

During the development of this, I realized I had completely overthought the issue and we could 
have just added secondary interfaces to each VM that take DHCP. However I actually like this 
solution better, as it allows for a more isolated host network.

# Installation

We will need to install this on a VM to be acting as the gateway. In this guide, we will 
assume you are using a dedicated VM running CentOS 7.

Go ahead and login to the server and run the following commands

```bash
cd /opt
git clone [giturl]
cd labnat
# We need to copy this to the dhclient.d folder
cp dhclient-clear-routes.sh /etc/dhcp/dhclient.d/
# We need to enable ip forwarding
/sbin/sysctl net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward = 1" > /etc/sysctl.d/99-labnat.conf
```

Additionally you need to modify the wan_interface and lan_interface variable in /opt/labnat/labnat to 
point their respective interfaces.

### Usage

Now we can either start it with the list of ips we need static ips for or we can create a 
list to be used every time.

```bash
/opt/labnat/labnat start ip1 ip2 ip3
```
or
```bash
echo ip1 ip2 ip3 > /opt/labnat/lab_ips
/opt/labnat/labnat start
```

Example Output:
```bash
$ cat /opt/labnat/lab_ips
172.31.255.250 172.31.255.251 172.31.255.252
$ /opt/labnat/labnat start
Creating NAT for 172.31.255.250 ...
DHClient is already running, killing first...
Killed!
IP Association 172.31.255.250 > 192.168.1.16
Done
Creating NAT for 172.31.255.251 ...
DHClient is already running, killing first...
Killed!
IP Association 172.31.255.251 > 192.168.1.30
Done
Creating NAT for 172.31.255.252 ...
DHClient is already running, killing first...
Killed!
IP Association 172.31.255.252 > 192.168.1.31
Done
```
