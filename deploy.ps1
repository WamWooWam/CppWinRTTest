param(
    [switch]$Register,
    [switch]$RegisterIfNeeded
)
if (-not (Test-Path ".\bin\AppX")) {
    New-Item ".\bin\AppX" -ItemType "directory"
    New-Item ".\bin\AppX\Assets" -ItemType "directory"
}

# Grab package identity info from the AppxManifest
[xml]$xml = Get-Content ".\Package.appxmanifest"
$name = $xml.Package.Identity.Name

Write-Host
Write-Host "Copying to layout..."

Copy-Item ".\bin\*" -Recurse -Exclude "AppX" -Destination ".\bin\AppX"
Copy-Item ".\Assets\*" -Recurse -Destination ".\bin\AppX\Assets"
Copy-Item -Path ".\Package.appxmanifest" -Destination ".\bin\AppX\AppxManifest.xml"

$package = Get-AppxPackage -Name $name

if ($Register -or ($RegisterIfNeeded -and ($package -eq $null))) {
    $licence = $null;

    try {
        $licence = Get-WindowsDeveloperLicense
    }
    catch {
        if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }    
    }

    if (($licence -eq $null) -or (-not $licence.IsValid)) {
        Write-Warning "No valid developer licence was found. Requesting..."
        Show-WindowsDeveloperLicenseRegistration
    }
    
    Write-Host
    Write-Host "Registering package..."
    Write-Host

    if ($package -ne $null) {
        $read = Read-Host "The package has already been installed, do you want to uninstall it and reinstall?"

        if ($read -eq "y") {
            Remove-AppxPackage $package -Verbose
        }
        else {
            exit;
        }
    }

    Add-AppxPackage -Register ".\bin\AppX\AppxManifest.xml" -Verbose
}

Write-Host
Write-Host "Deploy complete!"