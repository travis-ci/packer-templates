
Write-Host "---------------------------------------------------------------------------------------------"
Write-Host $MyInvocation.MyCommand.Name
Write-Host "---------------------------------------------------------------------------------------------"

dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
#cleanmgr /sagerun:1

$doExtraCompact = $null
if(Test-Path env:doExtraCompact)
{
  $doExtraCompact = Get-Item env:doExtraCompact

  if($doExtraCompact.Value -eq 'true')
  {
    Write-Host "Performing extra compacting with Udefrag and Sdelete"

    choco install -y ultradefrag
    choco install -y sdelete

    udefrag --optimize --repeat C:
    sdelete.exe -q -z C:
  }
}

