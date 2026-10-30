#Requires -Version 5.1
#Requires -RunAsAdministrator
<#
.SYNOPSIS
  Preflight-first Windows 11 Microsoft AppX/MSIX provisioning.
.DESCRIPTION
  Requires user-supplied, legally sourced packages, SHA-256 values and
  valid offline license XML (or an explicit no-license-required declaration).
  By default this script performs READ-ONLY preflight. Use -Apply and
  -AcknowledgeReferenceImage together for actual online provisioning.
  All packages are checked BEFORE the first write. Frameworks run before apps.
  Existing packages are never removed, overwritten or downgraded.
  No Microsoft binaries, license files, WordPad or Dolby files are included.
.PARAMETER ManifestPath
  UTF-8 JSON manifest; see docs/SCRIPTS_zh-TW.md.
.PARAMETER SourceRoot
  Root of locally licensed AppX/MSIX files referenced by manifest.
.PARAMETER Apply
  Explicitly allow provisioning after all preflight checks succeed.
.PARAMETER AcknowledgeReferenceImage
  Affirm the current Windows installation is the intended test/reference VM.
.PARAMETER AllowPartial
  Permit a manifest listing fewer than all 17 expected main apps.
.PARAMETER AllowLicenseFree
  Permit SkipLicense only for a manifest entry explicitly marked
  licenseNotRequired=true and only when legally permitted.
#>
[CmdletBinding(SupportsShouldProcess=$true,ConfirmImpact='High')]
param(
    [Parameter(Mandatory=$true)][string]$SourceRoot,
    [Parameter(Mandatory=$true)][string]$ManifestPath,
    [switch]$Apply,
    [switch]$AcknowledgeReferenceImage,
    [switch]$AllowPartial,
    [switch]$AllowLicenseFree,
    [string]$LogPath
)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$expected=@(
 'Microsoft.StorePurchaseApp','Microsoft.WindowsStore','Microsoft.DesktopAppInstaller',
 'Microsoft.WindowsCalculator','Microsoft.Paint','Microsoft.WindowsNotepad',
 'Microsoft.ScreenSketch','Microsoft.WindowsCamera','Microsoft.Windows.Photos',
 'Microsoft.ZuneMusic','Microsoft.AV1VideoExtension','Microsoft.AVCEncoderVideoExtension',
 'Microsoft.VP9VideoExtensions','Microsoft.HEIFImageExtension',
 'Microsoft.WebpImageExtension','Microsoft.WebMediaExtensions','Microsoft.MPEG2VideoExtension'
)
function Resolve-WithinRoot([string]$relative) {
    if([string]::IsNullOrWhiteSpace($relative)){throw 'Empty package path.'}
    if([IO.Path]::IsPathRooted($relative)){throw "Only relative paths inside SourceRoot are permitted: $relative"}
    $full=[IO.Path]::GetFullPath((Join-Path $script:root $relative))
    $prefix=$script:root.TrimEnd('\')+'\'
    if(-not $full.StartsWith($prefix,[StringComparison]::OrdinalIgnoreCase)){
        throw "Unsafe path outside SourceRoot: $relative"
    }
    if(-not (Test-Path -LiteralPath $full -PathType Leaf)){
        throw "Missing source file: $full"
    }
    return $full
}
function Check-Hash([string]$path,[string]$hash) {
    if($hash -notmatch '^[a-fA-F0-9]{64}$'){throw "Invalid SHA-256 in manifest for $path"}
    $actual=(Get-FileHash -LiteralPath $path -Algorithm SHA256 -ErrorAction Stop).Hash
    if($actual -ine $hash){throw "SHA-256 mismatch: $path"}
}
function Get-Prop($obj,[string]$name) {
    if($obj.PSObject.Properties[$name]){return $obj.$name}
    return $null
}
$transcript=$false
try {
    if($Apply -and -not $AcknowledgeReferenceImage){
        throw 'Add -AcknowledgeReferenceImage only when running in the intended reference VM.'
    }
    $reg=Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
    $build=[int]$reg.CurrentBuildNumber
    if($build -notin @(26100,26200,26300)){throw "Unsupported build family $build; expected 26100/26200/26300."}
    if([string]$reg.EditionID -ne 'IoTEnterpriseS'){throw "Unsupported edition $($reg.EditionID); expected IoTEnterpriseS."}
    if(-not [Environment]::Is64BitOperatingSystem){throw 'This project targets x64 Windows only.'}
    $script:root=[IO.Path]::GetFullPath((Resolve-Path -LiteralPath $SourceRoot).Path)
    if(-not (Test-Path -LiteralPath $ManifestPath -PathType Leaf)){throw "Manifest not found: $ManifestPath"}
    $manifest=Get-Content -LiteralPath $ManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction Stop
    if([int](Get-Prop $manifest 'schema') -ne 1){throw 'Manifest schema must be 1.'}
    $records=@($manifest.packages)
    if($records.Count -eq 0){throw 'Manifest contains no packages.'}
    $names=New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
    $prepared=New-Object 'System.Collections.Generic.List[object]'
    foreach($entry in $records) {
        $name=[string](Get-Prop $entry 'name')
        $kind=[string](Get-Prop $entry 'kind')
        if([string]::IsNullOrWhiteSpace($name)){throw 'Package name is required.'}
        if(-not $names.Add($name)){throw "Duplicate manifest package: $name"}
        if($kind -notin @('App','Framework')){throw "Invalid kind for $name (use App or Framework)."}
        if($kind -eq 'App' -and $name -notin $expected){throw "App is not in project's 17-item allowlist: $name"}
        if($kind -eq 'Framework' -and $name -notmatch '^Microsoft\.(NET\.Native\.(Framework|Runtime)\.|UI\.Xaml\.|VCLibs\.|WindowsAppRuntime\.)'){
            throw "Framework name not allowed: $name"
        }
        $pkgPath=Resolve-WithinRoot ([string](Get-Prop $entry 'package'))
        if([IO.Path]::GetExtension($pkgPath).ToLowerInvariant() -notin @('.appx','.appxbundle','.msix','.msixbundle')){
            throw "Unsupported package file type: $pkgPath"
        }
        if(-not [IO.Path]::GetFileName($pkgPath).StartsWith($name,[StringComparison]::OrdinalIgnoreCase)){
            throw "Package filename does not match declared name $name : $pkgPath"
        }
        Check-Hash $pkgPath ([string](Get-Prop $entry 'sha256'))
        $dependencyPaths=@()
        $deps=Get-Prop $entry 'dependencies'
        if($null -ne $deps){
            foreach($dep in @($deps)){
                $dp=Resolve-WithinRoot ([string](Get-Prop $dep 'package'))
                if([IO.Path]::GetExtension($dp).ToLowerInvariant() -notin @('.appx','.appxbundle','.msix','.msixbundle')){
                    throw "Dependency file type not allowed: $dp"
                }
                Check-Hash $dp ([string](Get-Prop $dep 'sha256'))
                $depName=[string](Get-Prop $dep 'name')
                if($depName){
                    if($depName -notmatch '^Microsoft\.(NET\.Native\.(Framework|Runtime)\.|UI\.Xaml\.|VCLibs\.|WindowsAppRuntime\.)'){
                        throw "Dependency name is not an allowed Microsoft framework: $depName"
                    }
                    if(-not [IO.Path]::GetFileName($dp).StartsWith($depName,[StringComparison]::OrdinalIgnoreCase)){
                        throw "Dependency filename and declared name do not match: $depName"
                    }
                }
                if([IO.Path]::GetFileName($dp) -match '(?i)(HEVC|Dolby|AC[-_]?3)'){
                    throw "Excluded codec/third-party component in dependency: $dp"
                }
                $dependencyPaths+= $dp
            }
        }
        $licensePath=$null
        $licenseText=[string](Get-Prop $entry 'license')
        $licenseFree=(Get-Prop $entry 'licenseNotRequired') -eq $true
        if($licenseText){
            if($licenseFree){throw "Both license and licenseNotRequired specified: $name"}
            $licensePath=Resolve-WithinRoot $licenseText
            if([IO.Path]::GetExtension($licensePath).ToLowerInvariant() -ne '.xml'){throw "License must be XML: $licensePath"}
            $licenseHash=[string](Get-Prop $entry 'licenseSha256')
            Check-Hash $licensePath $licenseHash
            $null=[xml](Get-Content -LiteralPath $licensePath -Raw -Encoding UTF8)
        } elseif(-not ($licenseFree -and $AllowLicenseFree)){
            throw "Legitimate offline license missing for $name. Never bypass licensing by default."
        }
        $prepared.Add([pscustomobject]@{
            Name=$name;Kind=$kind;PackagePath=$pkgPath
            Dependencies=$dependencyPaths;LicensePath=$licensePath
            SkipLicense=($null -eq $licensePath)
        })
    }
    if(-not $AllowPartial){
        $apps=@($prepared | Where-Object {$_.Kind -eq 'App'} | ForEach-Object {$_.Name})
        $missing=@($expected | Where-Object {$_ -notin $apps})
        if($missing.Count -gt 0){throw ("Manifest missing {0} expected apps: {1}. Use -AllowPartial only for deliberate partial tests." -f $missing.Count,($missing -join ', '))}
    }
    $existing=@(Get-AppxProvisionedPackage -Online -ErrorAction Stop)
    $order=@($prepared | Sort-Object @{Expression={if($_.Kind -eq 'Framework'){0}else{1}}},Name)
    foreach($item in $order){
        $already=@($existing | Where-Object {$_.DisplayName -ieq $item.Name})
        Write-Host ("PREFLIGHT {0}: {1} ({2})" -f $(if($already.Count){'SKIP-EXISTING'}else{'READY'}),$item.Name,$item.Kind)
    }
    Write-Host ("PREFLIGHT PASS: {0} package definitions; OS build {1}; source SHA-256 OK." -f $prepared.Count,$build) -ForegroundColor Green
    if(-not $Apply){Write-Host 'READ-ONLY MODE: no packages installed. Add -Apply -AcknowledgeReferenceImage to provision.';exit 0}
    if($LogPath){
        $parent=Split-Path -Parent $LogPath
        if($parent -and -not (Test-Path -LiteralPath $parent)){throw "Log directory missing: $parent"}
        Start-Transcript -LiteralPath $LogPath -ErrorAction Stop | Out-Null
        $transcript=$true
    }
    foreach($item in $order){
        $existing=@(Get-AppxProvisionedPackage -Online -ErrorAction Stop)
        if(@($existing | Where-Object {$_.DisplayName -ieq $item.Name}).Count -gt 0){
            Write-Host ("SKIP: already provisioned; no overwrite/downgrade: {0}" -f $item.Name)
            continue
        }
        if($PSCmdlet.ShouldProcess($item.Name,'Add-AppxProvisionedPackage -Online')){
            $params=@{Online=$true;PackagePath=$item.PackagePath;ErrorAction='Stop'}
            if($item.Dependencies.Count -gt 0){$params.DependencyPackagePath=$item.Dependencies}
            if($item.SkipLicense){$params.SkipLicense=$true}else{$params.LicensePath=@($item.LicensePath)}
            Add-AppxProvisionedPackage @params | Out-Null
            $post=@(Get-AppxProvisionedPackage -Online -ErrorAction Stop | Where-Object {$_.DisplayName -ieq $item.Name})
            if($post.Count -eq 0){throw "Provisioning command returned but no provisioned entry: $($item.Name)"}
            Write-Host ("PASS: provisioned {0}" -f $item.Name) -ForegroundColor Green
        }
    }
    Write-Host 'Provisioning complete. Run Verify-InboxApps.ps1 and test a NEW USER; Sysprep and update regressions remain separate.' -ForegroundColor Green
}catch{
    Write-Host ("FAIL: " + $_.Exception.Message) -ForegroundColor Red
    throw
}finally{
    if($transcript){try{Stop-Transcript | Out-Null}catch{}}
}
