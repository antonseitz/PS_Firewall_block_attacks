param(
[string]$path ,
[string]$port 
)
$ips=@()
$skipped=0
$ipchecklast="1.1.1.1"



# USAGE
if (! $port ){ 
	write-host("Usage: "  +  $MyInvocation.MyCommand.Name + "  -port  port_of_attacked [ -path path_to_netstat_output ] ")
	write "-port = this port is been attacked "
	write "-path = path to output of netstat -n"
    write " if no path given, netstat will be done by this script"
	exit
}

# ask from API KEY
if (! $env:api_key ){ 
	$env:api_key = read-host("Enter API KEY from geo ipfy.org")
}

# read output of netstat -n
if ($path){
	$netstatfile=get-content -path $path
}

# generate output of netstat -n
else {
	$netstatfile= & netstat -n
}

# search for given port in netstat output
foreach ($line in $netstatfile) {
	$suche="*:" + $port + " *"
	if ($line -like $suche ){
		# in spalten umwandeln
		$conn=$line.split()
		# spalte mit remote ip auswählen. IP ist teil for dem ":" 
		$ips+= $conn[13].split(":")[0]
	}
}

# sort and exclude double ips 
$ips=$ips| sort-object | get-unique



$api_url = "https://geo.ipify.org/api/v1?"


# loop all IPs 
foreach ($ip in $ips) {

	$ipcheck= $ip.split("{.}")
	if( -not (($ipcheck[0]  -eq $ipchecklast[0])  -and  ($ipcheck[1]  -eq $ipchecklast[1]) -and ($ipcheck[2]  -eq $ipchecklast[2])  )){
		if ($skipped -gt 1 ){
			$skipped.ToString() + " IPs skipped, because first 3 Oktets were identical"
		}
		$uri = "$api_url" + "apiKey=$Env:api_key" + "&ipAddress=$ip"

		$j = Invoke-WebRequest -Uri $uri
	
		$location= $j | convertfrom-json
		
		"#####"
		$ip 
		$location.location.country
		$location.location.city
		$skipped=0
	} else {
	$skipped+=1
	}
	$ipchecklast= $ipcheck
}