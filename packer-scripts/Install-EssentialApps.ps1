
Set-ExecutionPolicy Bypass -Scope Process -Force;

# Chocolatey
Write-Host "Chocolatey"
$chocoExePath = 'C:\ProgramData\Chocolatey\bin'

if ($($env:Path).ToLower().Contains($($chocoExePath).ToLower())) {
  Write-Host "Chocolatey found in PATH, skipping install..."
}
else
{
  # Add to system PATH
  $systemPath = [Environment]::GetEnvironmentVariable('Path',[System.EnvironmentVariableTarget]::Machine)
  $systemPath += ';' + $chocoExePath
  [Environment]::SetEnvironmentVariable("PATH", $systemPath, [System.EnvironmentVariableTarget]::Machine)

  # Update local process' path
  $userPath = [Environment]::GetEnvironmentVariable('Path',[System.EnvironmentVariableTarget]::User)
  if($userPath) {
    $env:Path = $systemPath + ";" + $userPath
  } else {
    $env:Path = $systemPath
  }

  # Run the installer
  iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))
}

# Nuget + PSWindowsUpdate
Write-Host "Installing Nuget + PSWindowsUpdate"

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name PSWindowsUpdate -Force