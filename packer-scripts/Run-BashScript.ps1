param([string]$bashscript = "")

Set-StrictMode -Version 1.0

$nowTime = Get-Date -Format o `
           | foreach {$_ -replace ":", "."} `
           | foreach {$_ -replace "\+", "_"}
$tmpBasename = "script.${nowTime}.bash"
$tmpDest = "c:/windows/temp/${tmpBasename}"
$bashDest = "/c/windows/temp/${tmpBasename}"
$env:PATH = "${env:PATH};c:/program files/git/usr/bin"

echo "copying script bashscript=${bashscript} tmpDest=${tmpDest}"
cp "${bashscript}" "${tmpDest}"

echo "running bash ${bashDest}"
bash $bashDest
exit $LastExitCode
