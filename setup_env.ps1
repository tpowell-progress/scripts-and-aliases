if (-Not (Get-Command choco -ErrorAction SilentlyContinue))
{
    # install Chrome
    $LocalTempDir = $env:TEMP; $ChromeInstaller = "ChromeInstaller.exe"; (new-object System.Net.WebClient).DownloadFile('http://dl.google.com/chrome/install/375.126/chrome_installer.exe', "$LocalTempDir\$ChromeInstaller"); & "$LocalTempDir\$ChromeInstaller" /silent /install; $Process2Monitor =  "ChromeInstaller"; Do { $ProcessesFound = Get-Process | ?{$Process2Monitor -contains $_.Name} | Select-Object -ExpandProperty Name; If ($ProcessesFound) { "Still running: $($ProcessesFound -join ', ')" | Write-Host; Start-Sleep -Seconds 2 } else { rm "$LocalTempDir\$ChromeInstaller" -ErrorAction SilentlyContinue -Verbose } } Until (!$ProcessesFound)


    # Install Chocolately
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    # Refresh PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

}

if (-Not (Get-Command git -ErrorAction SilentlyContinue))
{
    # Install git
    choco install -y git

    # Refresh PATH
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
}

if (-Not (Test-Path "C:\Projects"))
{
    mkdir c:\projects
}
cd \projects

switch -regex ($env:BITNESS) {
    "64" { $platform="x64" }
    "32" { $platform="x86" }
}
switch -regex ($env:RUBY_VERSION) {
    "2.7.7" { $ruby_version="2.7.7-1"; $ruby_path="C:\Ruby27" }
    "3.1.3" { $ruby_version="3.1.3-1"; $ruby_path="C:\Ruby31-$platform" }
}
echo "Ruby version: $ruby_version"

if (-Not (Test-Path $ruby_path))
{
    Invoke-WebRequest -Uri "https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-$ruby_version/rubyinstaller-devkit-$ruby_version-$platform.exe" -OutFile "rubyinstaller-devkit-$ruby_version-$platform.exe"
    &".\rubyinstaller-devkit-$ruby_version-x64.exe"
}