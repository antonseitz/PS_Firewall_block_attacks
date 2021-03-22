param(
[switch]$block,
[switch]$help ,
[switch]$show,
[int]$hours=1
)


$after_h=(get-date).addhours($hours * (-1))


$ips=@()

$log_h=Get-EventLog -LogName Security -after $after_h -InstanceId 4625 |
select TimeGenerated, Eventid,
@{Name="AnmeldeTyp"; Expression={$_.Replacementstrings[10]}},
@{Name="Kontoname"; Expression={$_.Replacementstrings[5]}},
@{Name="Arbeitsstationsname"; Expression={$_.Replacementstrings[13]}},
@{Name="QuellIP"; Expression={$_.Replacementstrings[19]}}


if ($show){
foreach ($log in $log_h  ){
$log

}}

if ($block) {


foreach ($entry in $log_h){
$ips+=$entry.QuellIP 
}



foreach ($ip in ($ips | group | sort -Property count -Descending)) {



if($ip.count -gt 20){
$name="PS_BLOCK_ATTK_" + $ip.Name


if ( -not (Get-NetFirewallRule -displayname $name ) ){

New-NetFirewallRule -DisplayName $name -Profile Any -Enabled True -Direction Inbound -LocalPort 2323 -Protocol TCP -Remoteaddress $ip.Name -Action block
"Rule" + $name +" created!"
}
else {
$name + " is already present!" 
}
}
}

}


if( ( !  $show -and ! $block ) -or $help ){
"Usage: -show | -block | -hours=1 }"
"-show : shown only logon failures of last x hours"
"-block  : block ips with more than 20 logon failures of last x hours"
"-hours=x  : parse eventlog from x hours ago to now "
}