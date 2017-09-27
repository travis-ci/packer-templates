foreach($package in Get-Content c:/windows/temp/packages.txt) {
  If (-Not $line -eq "") { choco install $package }
}
