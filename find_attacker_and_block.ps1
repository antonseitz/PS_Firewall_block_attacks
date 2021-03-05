$after_h=(get-date).addhours(-1)


$ips=@()

$log_h=Get-EventLog -LogName Security -after $after_h -InstanceId 4625 |
select TimeGenerated, Eventid,
#@{Name="AnmeldeTyp"; Expression={$_.Replacementstrings[10]}},
#@{Name="Kontoname"; Expression={$_.Replacementstrings[5]}},
#@{Name="Arbeitsstationsname"; Expression={$_.Replacementstrings[13]}},
@{Name="QuellIP"; Expression={$_.Replacementstrings[19]}}







foreach ($entry in $log_h){
$ips+=$entry.QuellIP 
}



foreach ($id in ($ips | group | sort -Property count -Descending)) {

#$long+=  [string]$id.count + " failed logins from IP: " + $id.Name + "\n"

if($ip.count -gt 20){
$name="PS_BLOCK_ATTK_" + $id.Name
New-NetFirewallRule -DisplayName $name -Profile Any -Enabled True -Direction Inbound -LocalPort 2323 -Protocol TCP -Remoteaddress $id.Name -Action block
}

}



