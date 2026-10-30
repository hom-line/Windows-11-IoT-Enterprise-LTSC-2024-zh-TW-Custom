#Requires -Version 5.1
#Requires -RunAsAdministrator
<#
.SYNOPSIS
  Read-only audit of 17 Microsoft Inbox Apps, required frameworks and FOD.
.DESCRIPTION
  Distinguishes system-wide provisioning for new users from installed AppX.
  Invents no fixed framework versions; lists detected NET.Native, UI.Xaml,
  VCLibs and WindowsAppRuntime variants. A deployment manifest is required
  to PASS dependency-specific framework verification. No changes are made.
.PARAMETER ManifestPath
  Optional provisioning schema-1 JSON manifest from Provision-InboxApps.ps1.
  Without it, framework verification is NOT_CHECKED and exit code is 3.
.PARAMETER SkipFeatures
  Skip NetFx3, Print.Fax.Scan, and XPS.Viewer checks.
.PARAMETER CsvPath
  Optional UTF-8 detail CSV output.
.PARAMETER JsonPath
  Optional UTF-8 JSON status output.
#>
[CmdletBinding()]
param([switch]$SkipFeatures,[string]$CsvPath,[string]$JsonPath,[string]$ManifestPath)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
$mainApps=@(
  'Microsoft.StorePurchaseApp','Microsoft.WindowsStore','Microsoft.DesktopAppInstaller',
  'Microsoft.WindowsCalculator','Microsoft.Paint','Microsoft.WindowsNotepad',
  'Microsoft.ScreenSketch','Microsoft.WindowsCamera','Microsoft.Windows.Photos',
  'Microsoft.ZuneMusic','Microsoft.AV1VideoExtension','Microsoft.AVCEncoderVideoExtension',
  'Microsoft.VP9VideoExtensions','Microsoft.HEIFImageExtension',
  'Microsoft.WebpImageExtension','Microsoft.WebMediaExtensions','Microsoft.MPEG2VideoExtension'
)
function Save-Utf8([string]$file,[string]$value) {
    $parent=Split-Path -Parent $file
    if($parent -and -not (Test-Path -LiteralPath $parent)){throw "Output directory does not exist: $parent"}
    [IO.File]::WriteAllText([IO.Path]::GetFullPath($file),$value,(New-Object Text.UTF8Encoding($false)))
}
function Add-Row([string]$kind,[string]$name,[string]$status,[string]$details) {
    $script:rows.Add([pscustomobject]@{Kind=$kind;Name=$name;Status=$status;Details=$details})
}
try {
    $provisioned=@(Get-AppxProvisionedPackage -Online -ErrorAction Stop)
    $installed=@()
    try {$installed=@(Get-AppxPackage -AllUsers -ErrorAction Stop)}
    catch {Write-Warning ("Installed Appx inventory unavailable: " + $_.Exception.Message)}
    $rows=New-Object 'System.Collections.Generic.List[object]'
    foreach($name in $mainApps){
        $pm=@($provisioned | Where-Object {$_.DisplayName -ieq $name})
        $user=@($installed | Where-Object {$_.Name -ieq $name})
        if($pm.Count -eq 0){
            Add-Row 'App' $name 'MISSING' ("Provisioned=0; InstalledVariants={0}" -f $user.Count)
        }else{
            $versions=($pm | ForEach-Object {$_.Version} | Sort-Object -Unique) -join ','
            Add-Row 'App' $name 'PASS' ("Provisioned={0}; Versions={1}; InstalledVariants={2}" -f $pm.Count,$versions,$user.Count)
        }
    }
    $rx='^(Microsoft\.NET\.Native\.(Framework|Runtime)\.|Microsoft\.UI\.Xaml\.|Microsoft\.VCLibs\.|Microsoft\.WindowsAppRuntime\.)'
    $fwi=@($installed | Where-Object {$_.Name -match $rx})
    $fwp=@($provisioned | Where-Object {$_.DisplayName -match $rx})
    $allNames=@()
    $allNames+=@($fwi | ForEach-Object {$_.Name})
    $allNames+=@($fwp | ForEach-Object {$_.DisplayName})
    $frameworkNames=@($allNames | Where-Object {$_} | Sort-Object -Unique)
    foreach($name in $frameworkNames){
        $ic=@($fwi | Where-Object {$_.Name -eq $name}).Count
        $pc=@($fwp | Where-Object {$_.DisplayName -eq $name}).Count
        Add-Row 'Framework' $name 'INFO' ("Installed variants={0}; Provisioned variants={1}" -f $ic,$pc)
    }
    if($frameworkNames.Count -eq 0){
        Add-Row 'Framework' 'Microsoft framework inventory' 'WARN' 'No NET.Native/UI.Xaml/VCLibs entries found; dependency requirements differ by package.'
    }
    # A plain installed/provisioned inventory does NOT establish which framework
    # packages each app actually needs. Derive mandatory checks from the same
    # user-supplied deployment manifest used for provisioning.
    $frameworkValidation='NOT_CHECKED'
    if(-not [string]::IsNullOrWhiteSpace($ManifestPath)){
        if(-not (Test-Path -LiteralPath $ManifestPath -PathType Leaf)){
            throw "Manifest not found: $ManifestPath"
        }
        $manifest=Get-Content -LiteralPath $ManifestPath -Raw -Encoding UTF8 | ConvertFrom-Json -ErrorAction Stop
        if(-not $manifest.PSObject.Properties['schema'] -or [int]$manifest.schema -ne 1){
            throw 'Manifest schema must be 1.'
        }
        if(-not $manifest.PSObject.Properties['packages']){
            throw 'Manifest packages array is missing.'
        }
        $entries=@($manifest.packages)
        if($entries.Count -eq 0){throw 'Manifest packages array is empty.'}
        $required=New-Object 'System.Collections.Generic.HashSet[string]' ([StringComparer]::OrdinalIgnoreCase)
        $frameworkByPath=@{}
        foreach($entry in $entries){
            if([string]$entry.kind -ne 'Framework'){continue}
            $fn=[string]$entry.name
            if([string]::IsNullOrWhiteSpace($fn) -or $fn -notmatch $rx){
                throw "Invalid declared framework: $fn"
            }
            $null=$required.Add($fn)
            $relative=[string]$entry.package
            if($relative){
                $key=($relative -replace '\\','/').ToLowerInvariant()
                $frameworkByPath[$key]=$fn
            }
        }
        foreach($entry in $entries){
            if([string]$entry.kind -ne 'App'){continue}
            $deps=@()
            if($entry.PSObject.Properties['dependencies']){$deps=@($entry.dependencies)}
            foreach($dep in $deps){
                if($null -eq $dep){continue}
                $dn=''
                if($dep.PSObject.Properties['name']){$dn=[string]$dep.name}
                $relative=''
                if($dep.PSObject.Properties['package']){$relative=[string]$dep.package}
                $key=($relative -replace '\\','/').ToLowerInvariant()
                if(-not $dn -and $frameworkByPath.ContainsKey($key)){
                    $dn=$frameworkByPath[$key]
                }
                if(-not $dn -or $dn -notmatch $rx){
                    Add-Row 'RequiredFramework' ([string]$entry.name) 'UNKNOWN' "Unresolved dependency: $relative (provide dependency.name or matching Framework entry)"
                    continue
                }
                $null=$required.Add($dn)
            }
        }
        if($required.Count -eq 0){
            Add-Row 'RequiredFramework' 'Deployment manifest' 'UNKNOWN' 'No framework requirements declared; dependency verification cannot be certified.'
        }else{
            foreach($fn in @($required | Sort-Object)){
                $pm=@($provisioned | Where-Object {$_.DisplayName -ieq $fn})
                $um=@($installed | Where-Object {$_.Name -ieq $fn})
                $status=if($pm.Count -gt 0){'PASS'}else{'MISSING'}
                Add-Row 'RequiredFramework' $fn $status ("Provisioned={0}; InstalledVariants={1}" -f $pm.Count,$um.Count)
            }
        }
        $frameworkValidation='MANIFEST_CHECKED'
    }else{
        Add-Row 'RequiredFramework' 'Dependency manifest' 'NOT_CHECKED' 'Provide -ManifestPath to check required Microsoft framework packages.'
    }
    $hevc=@($provisioned | Where-Object {$_.DisplayName -match 'HEVCVideoExtension'})
    Add-Row 'Policy' 'HEVC (not a required app)' 'INFO' ("Provisioned={0}" -f $hevc.Count)
    if(-not $SkipFeatures){
        try{
            $netfx=Get-WindowsOptionalFeature -Online -FeatureName NetFx3 -ErrorAction Stop
            $status=if($netfx.State -eq 'Enabled'){'PASS'}else{'MISSING'}
            Add-Row 'Feature' 'NetFx3' $status ([string]$netfx.State)
        }catch{Add-Row 'Feature' 'NetFx3' 'ERROR' $_.Exception.Message}
        try{
            $caps=@(Get-WindowsCapability -Online -ErrorAction Stop)
            foreach($prefix in @('Print.Fax.Scan','XPS.Viewer')){
                $matching=@($caps | Where-Object {$_.Name.StartsWith($prefix+'~~~~',[StringComparison]::OrdinalIgnoreCase)})
                if($matching.Count -eq 0){
                    Add-Row 'Feature' $prefix 'MISSING' 'Capability not found'
                }else{
                    $ok=@($matching | Where-Object {$_.State -eq 'Installed'}).Count -gt 0
                    $details=($matching | ForEach-Object {"$($_.Name):$($_.State)"}) -join '; '
                    Add-Row 'Feature' $prefix $(if($ok){'PASS'}else{'MISSING'}) $details
                }
            }
        }catch{Add-Row 'Feature' 'Windows capabilities inventory' 'ERROR' $_.Exception.Message}
    }
    $list=@($rows.ToArray())
    $list | Format-Table Kind,Name,Status,Details -AutoSize | Out-Host
    $fail=@($list | Where-Object {$_.Status -in @('MISSING','ERROR','UNKNOWN')}).Count
    $appPass=@($list | Where-Object {$_.Kind -eq 'App' -and $_.Status -eq 'PASS'}).Count
    $result=[ordered]@{
        Timestamp=(Get-Date).ToString('o')
        ExpectedApps=17
        ProvisionedApps=$appPass
        FrameworkNamesDetected=$frameworkNames.Count
        FrameworkValidation=$frameworkValidation
        RequiredFailures=$fail
        Rows=$list
        Warning='App presence does not prove launch, all dependencies, new-user enrollment or AC-3 playback.'
    }
    if($CsvPath){
        $lines=@($list | ConvertTo-Csv -NoTypeInformation)
        Save-Utf8 $CsvPath ($lines -join ([Environment]::NewLine))
    }
    if($JsonPath){
        Save-Utf8 $JsonPath (ConvertTo-Json -InputObject $result -Depth 7)
    }
    if($fail -gt 0){
        Write-Host ("FAIL: main apps {0}/17; required failures={1}" -f $appPass,$fail) -ForegroundColor Red
        exit 1
    }
    if($frameworkValidation -eq 'NOT_CHECKED'){
        Write-Warning 'PARTIAL: all 17 App provisioning checks passed; required framework validation NOT CHECKED. Re-run with -ManifestPath.'
        exit 3
    }
    Write-Host 'PASS: 17/17 provisioned apps and all manifest-declared required frameworks.' -ForegroundColor Green
    Write-Warning 'Still verify package dependencies on a NEW USER, GUI launch, Sysprep and Windows Update separately.'
    exit 0
}catch{
    Write-Host ("ERROR: " + $_.Exception.Message) -ForegroundColor Red
    exit 2
}
