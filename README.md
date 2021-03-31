# PS_Firewall_attacker_block

- [ ] TODO: create setup.ps1 which creates a regulary task in scheduler

# find_attacker_and_block.ps1

searches eventlog for attacker IPs in last x hours 
and put this IPs to an blocking firewall rule .




## get-ip-location.ps1



Script to analyse IPs of current hacking attempts

It gives you the location and coutries of source IPs of connections

YOU NEED AN ACCOUNT FROM ipfy.org to use this!

```get-location.ps1 -port 3389```


## firewall.block.ips.by.country.ps1



```firewall.block.ips.by.country.ps1 -zone ru```

gets actuall list of ips ranges from Russia and creates Windows Firewall blocking rules, to deny all traffic from IPs in Russia


OR

```firewall.block.ips.by.country.ps1 -inputfile file.txt```

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
