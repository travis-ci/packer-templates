foreach($package in Get-Content c:/windows/temp/packages.txt) {
  If (-Not $package -eq "") 
    { choco install $package } 
  Else { echo "Line $package is empty" }
}
