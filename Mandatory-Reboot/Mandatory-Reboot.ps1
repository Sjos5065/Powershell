# Funtion to show the baloonTip Notification
function ShowBalloonTipInfo 
{
 
[CmdletBinding()]
param
(
[Parameter()]
$Text,
 
[Parameter()]
$Title,
 
#It must be 'None','Info','Warning','Error'
$Icon = 'Warning'
)
 
Add-Type -AssemblyName System.Windows.Forms
 
#check whether there is already an icon that we can reuse.
if ($script:balloonToolTip -eq $null)
{
#we will need to add the System.Windows.Forms assembly into our PowerShell session.
$script:balloonToolTip = New-Object System.Windows.Forms.NotifyIcon 
}
 
$path = Get-Process -id $pid | Select-Object -ExpandProperty Path
$balloonToolTip.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon($path)
$balloonToolTip.BalloonTipIcon = $Icon
$balloonToolTip.BalloonTipText = $Text
$balloonToolTip.BalloonTipTitle = $Title
$balloonToolTip.Visible = $true
 
#Display the tool tip for 15 seconds,used 15000 milliseconds when I call ShowBalloonTip.
$balloonToolTip.ShowBalloonTip(15000)
}
 


$lastboottime =(Get-WmiObject -ClassName Win32_OperatingSystem).LastBootUpTime

$uptime = (Get-Date) - [System.Management.ManagementDateTimeconverter]::ToDateTime($lastboottime)

$notificationwaittime = 3600
$hourstorestart = 4

if([int]($uptime.Days) -ige 2)
{
    for (($hourstorestart = 4); $hourstorestart -gt 0; $hourstorestart--)
    {
        $baloontext = "Your Machine has not been rebooted in the past 48 hours.","Please reboot ASAP.", "Automatic reboot in {0} hours" -f $hourstorestart
        
        $baloonTitle = "Mandatory Reboot Required"
        ShowBalloonTipInfo ($baloontext)
        if($hourstorestart -eq 1)
        {
            .\timeout.exe /T 2700
            $baloonTitle = "Final Reminder: Mandatory Reboot Required"
            $baloontext = "Your Machine has not been rebooted in the past 48 hours.","Please reboot ASAP.", "Automatic reboot in 15 Minutes"
            ShowBalloonTipInfo $baloontext $baloonTitle
        }
        else
        {
            # wait time of 1 hour before showing the notification again            
            .\timeout.exe /T $notificationwaittime
        }
    }

}
else
{
    exit
}
