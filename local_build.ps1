# install 7-Zip and add to path
# `mkdir c:\ruby31-x64\msys64\tmp`
#
#if (-Not (Get-Command heat.exe -ErrorAction SilentlyContinue))
#{
#  choco install -y dotnet3.5
#  Invoke-WebRequest -Uri "https://github.com/wixtoolset/wix3/releases/download/wix3112rtm/wix311.exe" -OutFile "wix311.exe"
#  .\wix311.exe
#  $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
#}

if (-Not (Test-Path "C:\projects\chef"))
{
  # Set up dev work directory
  git clone https://github.com/chef/chef
}
cd chef

git fetch origin
git checkout tp/debug-fips-locally
git pull

# omnibus/omnibus.rb looking for x64 or x86 or defaults to x86
$env:MSYSTEM="UCRT64"
$ENV:MSYS2_INSTALL_DIR="C:/Ruby31-x64/msys64"
$env:OMNIBUS_WINDOWS_ARCH = "x64"
$env:OMNIBUS_FIPS_MODE="true"
$mePath=$env:PATH
$env:PATH="C:\Program Files\7-Zip;C:\Ruby31-x64\msys64\usr\bin;C:\Ruby31-x64\msys64\ucrt64\bin;$env:MSYS2_INSTALL_DIR\usr\bin;C:\Program Files\git\bin;$mePath"

# set / uncomment these to change their respective branches
#$env:OMNIBUS_GITHUB_BRANCH="tp/debug-fips-locally"
#$env:OMNIBUS_SOFTWARE_GITHUB_BRANCH="tp/INFC-289-final"

cd omnibus
bundle config set --local without development
bundle update --conservative omnibus
bundle update --conservative omnibus-software
bundle install
pushd ..
bundle install
popd

if (-Not (Test-Path $env:MSYS2_INSTALL_DIR\tmp))
{
  mkdir $env:MSYS2_INSTALL_DIR\tmp
}
bundle exec omnibus build chef
