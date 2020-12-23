# PS_Firewall_block_whole_countries


## get-location.ps1

Script to analyse IPs of current hacking attempts

It gives you the location and coutries of source IPs of connections


## firewall.block.ips.by.country.ps1



````firewall.block.ips.by.country.ps1 -zone ru```

gets actuall list of ips ranges from Russia and creates Windows Firewall blocking rules, to deny all traffic from IPs in Russia


OR

firewall.block.ips.by.country.ps1 -inputfile file.txt

file.txt must contain IPs in CIDR format
Available here:
https://www.ip2location.com/free/visitor-blocker
OR 

https://www.ipdeny.com/ipblocks/


## Helpfull APIs

1000 requests free after registration:
https://geo.ipify.org/docs


other: 
https://ipdata.co/?ref=iplocation
