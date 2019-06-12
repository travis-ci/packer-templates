
Write-Host "---------------------------------------------------------------------------------------------"
Write-Host $MyInvocation.MyCommand.Name
Write-Host "---------------------------------------------------------------------------------------------"

$ErrorActionPreference = 'SilentlyContinue'

Write-Host "Disable system protection, set pagefile to a fixed size"
Disable-ComputerRestore -Drive "C:\"

Write-Host "Set pagefile to fixed size so we're not extending the image file unnecessarily"
$computersys = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges;
$computersys.AutomaticManagedPagefile = $False;
$computersys.Put();
$pagefile = Get-WmiObject -Query "Select * From Win32_PageFileSetting Where Name like '%pagefile.sys'";
$pagefile.InitialSize = 512;
$pagefile.MaximumSize = 512;
$pagefile.Put();


Write-Host "Disable Defender"
Set-MpPreference -DisableRealtimeMonitoring $true

# --> stuff below causes access denied problems...
# $DefenderPath = "HKLM:SOFTWARE\Policies\Microsoft\Windows Defender"
# New-Item -Path $DefenderPath -Force
# Set-ItemProperty -Path $DefenderPath -Type DWord -Name "DisableAntiSpyware" -Value 1 -Force

# $DefenderRealTimePath = "HKLM:SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection"
# New-Item -Path $DefenderRealTimePath -Force
# Set-ItemProperty -Path $DefenderRealTimePath -Type DWord -Name "DisableBehaviorMonitoring" -Value 1 -Force
# Set-ItemProperty -Path $DefenderRealTimePath -Type DWord -Name "DisableOnAccessProtection" -Value 1 -Force
# Set-ItemProperty -Path $DefenderRealTimePath -Type DWord -Name "DisableScanOnRealtimeEnable" -Value 1 -Force

Write-Host "Setting scheduling priority for programs"
$Priority =  "HKLM:SYSTEM\CurrentControlSet\Control\PriorityControl"
Set-ItemProperty -Path $Priority -Type DWord -Name Win32PrioritySeparation -Value 38 -Force 

Write-Host "Disable auto updates (hopefully)"
# see https://4sysops.com/archives/disable-windows-10-update-in-the-registry-and-with-powershell
$WindowsUpdatePath = "HKLM:SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\"
$AutoUpdatePath = "HKLM:SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"

New-Item -Path $WindowsUpdatePath -Force
New-Item -Path $AutoUpdatePath -Force

Set-ItemProperty -Path $AutoUpdatePath -Type DWord -Name NoAutoUpdate -Value 0 -Force
Set-ItemProperty -Path $AutoUpdatePath -Type DWord -Name AUOptions -Value 2 -Force


Write-Host "Disable install of apps like CandyCrush, ..."
$CloudContentPath = "HKLM:SOFTWARE\Policies\Microsoft\Windows\CloudContent"
New-Item -Path $CloudContentPath -Force
Set-ItemProperty -Path $CloudContentPath -Type DWord -Name "DisableWindowsConsumerFeatures" -Value 1 -Force

$ContentDeliveryManagerPath = "HKCU:Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
New-Item -Path $ContentDeliveryManagerPath -Force
Set-ItemProperty -Path $ContentDeliveryManagerPath -Type DWord -Name "SilentInstalledAppsEnabled" -Value 0 -Force

Write-Host "Disable Win-Store app updates"
$StorePath = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
New-Item -Path $StorePath -Force
Set-ItemProperty -Type DWord -Path $StorePath -Name "AutoDownload" -Value 2 -Force