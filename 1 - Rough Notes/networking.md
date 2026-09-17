part 2

basic network configuration

to add a new machine to a local network we will need

Adding a new machine to a local network goes like this:
1. Assign a unique IP address and hostname.
2. Configure network interfaces and IP addresses.
3. Set up a default route and perhaps fancier routing.
4. Point to a DNS name server to allow access to the rest of the Internet.

The /etc/hosts file is the oldest and simplest way to map names to IP addresses. what is the difference between /etc/hosts and /etc/resolv.conf ?

Because /etc/hosts contains only local mappings and must be maintained on each
client system, it’s best reserved for mappings that are needed at boot time (e.g., the
host itself, the default gateway, and name servers). Use DNS or LDAP to find map-
pings for the rest of the local network and the rest of the world. You can also use
/etc/hosts to specify mappings that you do not want the rest of the world to know
about and therefore do not publish in DNS.1


** I really need to understand netstat command, and the replacing ss command for newer versions. 


I less care about how to set up a local network files. 

next subject is network troubleshooting which we will have its own note. 
