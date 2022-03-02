#!/usr/bin/env bash

### Security Warning 
echo "Security Warning!  Please Do NOT Keep Any SSH Keys On This System"

### Updating AMZ Linux2 and packages
### Impact:  Keeping the system upto date to prevent old exploits from being used.
echo "Intalling System Updates..."
sudo yum update -y

### Amazon Security Update
### Impact: Keeping the system upto date with secuirty packages to prevent old exploits from being used.
echo "Intalling Security Packages..."
sudo yum update --security -y

### Disable LDAP
### Impact: If the system does not export NFS shares or act as an NFS client, it is recommended that these services be disabled to reduce remote attack surface. 
echo "Disabling NFS, NFS-Server, and RPCBind..."
sudo systemctl disable nfs
sudo systemctl disable nfs-server
sudo systemctl disable rpcbind

### Disable RSH Client
### Impact: These legacy clients contain numerous security exposures and have been replaced with the more secure SSH package 
echo "Disabling RSH Client..."
sudo yum remove rsh -y

### Enable Auditd service 
### Impact:  Enables local logging of system events
echo "Enabling Local System Logs..."
sudo systemctl enable auditd 

### Limiting SSH Brute Force Attacks.  THis is one of the most common exploits for hackers.
### Impact: THis will create a bottleneck that will slow down an SSH brute force attack so that it doesn't impact your machine and eventually the attack stops
echo "Limiting SSH Brute Force Attacks..."
sudo iptables -I INPUT -p tcp --dport 22 -i eth0 -m state --state NEW -m recent --set
sudo iptables -I INPUT -p tcp --dport 22 -i eth0 -m state --state NEW -m recent --update --seconds 60 --hitcount 4 -j DROP

### Reset IPTables, this is to reset your tables if needed. Uncomment if needed.  
### Iptables -f (or flush) this will remove everything and get you back to start again.

### Disable IP Forwarding
### Impact:  Setting the flags to 0 ensures that a system with multiple interfaces (for example, a hard proxy), will never be able to forward packets, and therefore, never serve as a router. 
### This will probably needed for web servrs. If needed, Uncomment the next 2 lines.
echo "Disabling IP Forwarding..."
sudo sysctl -w net.ipv4.ip_forward=0
### Enable IP forwarding
### Uncomment next 2 lines if you need to turn this back on after it was disabled.  It is ON by DEFAULT.
#echo "Enabling IP Forwarding..."
#sudo sysctl -w net.ipv4.ip_forward=1

###Setting Password Policy to 180 Days, Default is 99999
echo "Setting Password Policy to 180 Days, You Must Change Your Password Every 180 Days..."

### Setting Password Policy Minimum Age to 7 Days
echo "Setting Minimum Password Age Policy to 7 Days..."

### Setting Password Length to 7 characters
echo "Setting Password Length to  Minimum 7 Characters..."

