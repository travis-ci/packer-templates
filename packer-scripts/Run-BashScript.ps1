Set-StrictMode -Version 1.0

param([string]$bashscript = "")

$nowTime = Get-Date -Format o `
           | foreach {$_ -replace ":", "."} `
           | foreach {$_ -replace "\+", "_"}
$tmpBasename = "script.${nowTime}.bash"
$tmpDest = "c:/windows/temp/${tmpBasename}"
$bashDest = "/c/windows/temp/${tmpBasename}"
$bash = "c:/program files/git/usr/bin/bash.exe"

echo "copying script bashscript=${bashscript} tmpDest=${tmpDest}"
cp "${bashscript}" "${tmpDest}"

echo "starting process FilePath=${bash} ArgumentList=${bashDest}"
Start-Process -FilePath $bash -ArgumentList $bashDest -Wait
