foreach($package in Get-Content c:/windows/temp/packages.txt) {
  If (-Not $package -eq "") { choco install $package }
}

echo "setting up travis user"
New-LocalUser -Name "travis" -Description "travis user from packer" -NoPassword
Add-LocalGroupMember -Group "Administrators" -Member "travis"
