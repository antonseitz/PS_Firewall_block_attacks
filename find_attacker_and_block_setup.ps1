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




# DELETE OLD, IF PRESENT

$taskname= "PS_Block_Attacker" 
if( get-scheduledtask -taskname $taskname  )
{
write "Delete OLD ScheduledTask: $taskname"

UnRegister-ScheduledTask  $taskname
}

$user=read-host "Username"
$pass=read-host "Password" -AsSecureString # do not show password 
$port=read-host "Port of attacked Service. This port will be protected by FW rule" 

# convert Securestring to "normal" string
$pass=[Runtime.InteropServices.Marshal]::PtrToStringAuto(    [Runtime.InteropServices.Marshal]::SecureStringToBSTR($pass))



#$arg= '-noninteractive -noLogo -noprofile -command "& {c:\ms_backup\ms_backup.ps1 ' + $full_diff  + '; return $LASTEXITCODE  }"  2>&1 >> c:\ms_backup\logs\ms_backup.' + $full_diff + '.log'

$arg  = " -file $PSScriptRoot\find_attacker_and_block.ps1 -block -port $port"


$T = New-ScheduledTaskTrigger -Once -At 7am -RepetitionDuration  (New-TimeSpan -Days 1)  -RepetitionInterval  (New-TimeSpan -Minutes 30)
#New-ScheduledTaskTrigger -Once     -At (Get-Date)     -RepetitionInterval (New-TimeSpan -Minutes 15)     -RepetitionDuration ([System.TimeSpan]::MaxValue)

#$T = New-ScheduledTaskTrigger -Daily -At 7am  

$A = New-ScheduledTaskAction -Execute "powershell.exe" -Argument $arg



$S = New-ScheduledTaskSettingsSet -Compatibility Win8

$D = New-ScheduledTask -Action $A  -Trigger $T -Settings $S

Register-ScheduledTask $taskname -InputObject $D -taskpath "\" -user $user -pass $pass


$taskname + " is scheduled to run every 15 minutes now"

"Recommended interval: 10 minutes"
