#Requires -Version 5.1
#Requires -RunAsAdministrator
<#
.SYNOPSIS
  Read-only audit of the project's 17 Microsoft Inbox Apps and FOD.
.DESCRIPTION
  Distinguishes system-wide provisioning for new users from installed AppX.
  Invents no fixed framework versions; lists detected NET.Native, UI.Xaml,
  and VCLibs variants. No installation, removals, update or codec playback.
.PARAMETER SkipFeatures
  Skip NetFx3, Print.Fax.Scan, and XPS.Viewer checks.
.PARAMETER CsvPath
  Optional UTF-8 detail CSV output.
.PARAMETER JsonPath
  Optional UTF-8 JSON status output.
#>
[CmdletBinding()]
param([switch]$SkipFeatures,[string]$CsvPath,[string]$JsonPath)
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
    $rx='^(Microsoft\.NET\.Native\.(Framework|Runtime)\.|Microsoft\.UI\.Xaml\.|Microsoft\.VCLibs\.)'
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
    $fail=@($list | Where-Object {$_.Status -in @('MISSING','ERROR')}).Count
    $appPass=@($list | Where-Object {$_.Kind -eq 'App' -and $_.Status -eq 'PASS'}).Count
    $result=[ordered]@{
        Timestamp=(Get-Date).ToString('o')
        ExpectedApps=17
        ProvisionedApps=$appPass
        FrameworkNamesDetected=$frameworkNames.Count
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
    Write-Host ("PASS: 17/17 provisioned apps and requested FOD checks.") -ForegroundColor Green
    Write-Warning 'Framework details are informational; no claim of full dependency/codec function testing.'
    exit 0
}catch{
    Write-Host ("ERROR: " + $_.Exception.Message) -ForegroundColor Red
    exit 2
}
