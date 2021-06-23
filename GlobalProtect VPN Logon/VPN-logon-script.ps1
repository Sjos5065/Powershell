# Copy the policy update batch file from network to local machine

$source = "\\fileserver\Scripts\policy_update.bat"

$tempdirexists = Test-Path -Path "c:\Temp"

$destination = "C:\Temp"

if ($tempdirexists){
    Copy-Item -Path $source -Destination $destination
}
else{
    New-Item -ItemType directory -Path $destination
    Copy-Item -Path $source -Destination $destination
}

# Check for post vpn connect regsitry on the machine, if it does not exist, create it.

$pathexist = Test-Path -Path "HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings\post-vpn-connect"

if ($pathexist){
    $regitems = Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings\post-vpn-connect"

    if ("command" -notin ($regitems)){
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings\post-vpn-connect" -Name command -value "C:\Temp\Policy_update.bat > log  2> error"
    }
    else{
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings\post-vpn-connect" -Name command -value "C:\Temp\Policy_update.bat > log  2> error"
    }
}
else{
    New-Item -Path "HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings" -Name post-vpn-connect
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Palo Alto Networks\GlobalProtect\Settings\post-vpn-connect" -Name command -value "C:\Temp\Policy_update.bat > log  2> error"
}
