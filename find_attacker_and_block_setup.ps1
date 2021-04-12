param(
[string]$full_diff ,
[switch]$debug 
#[switch]$dryrun
)
# DEBUG ?
Set-PSDebug -off

if($debug) {Set-PSDebug -Trace 1}
else {Set-PSDebug -Off}



# ARE YOU ADMIN ?

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if ( -not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) ){
write "YOU HAVE NO ADMIN RIGHTS: EXITING!"
exit 1
}

# USAGE

#if (! $full_diff -or (($full_diff -ne "full") -and ($full_diff -ne "diff"))){ 
#write-host("Usage: "  +  $MyInvocation.MyCommand.Name + " -full_diff full|diff ") #[-debug] [-dryrun] ")
#write "-debug = a lot of output"


#exit
#
#}



# DELETE OLD, IF PRESENT

$taskname= "PS_Block_Attacker" 
if( get-scheduledtask -taskname $taskname  )
{
write "Delete OLD ScheduledTask: $taskname"

UnRegister-ScheduledTask  $taskname
}

$user=read-host "Username"
$pass=read-host "Password" -AsSecureString # do not show password 

# convert Securestring to "normal" string
$pass=[Runtime.InteropServices.Marshal]::PtrToStringAuto(    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))



#$arg= '-noninteractive -noLogo -noprofile -command "& {c:\ms_backup\ms_backup.ps1 ' + $full_diff  + '; return $LASTEXITCODE  }"  2>&1 >> c:\ms_backup\logs\ms_backup.' + $full_diff + '.log'

$arg  = " -file c:\GitHub\PS_Firewall_block_whole_countries\find_attacker_and_block.ps1 -block "




$T = New-ScheduledTaskTrigger -Daily -At 7am  

$A = New-ScheduledTaskAction -Execute "powershell.exe" -Argument $arg



$S = New-ScheduledTaskSettingsSet -Compatibility Win8

$D = New-ScheduledTask -Action $A  -Trigger $T -Settings $S

Register-ScheduledTask $taskname -InputObject $D -taskpath "\" -user $user -pass $pass


$taskname + " is scheduled once a day "
"Don't forget to  specify repeat interval!"
"Recommended interval: 10 minutes"