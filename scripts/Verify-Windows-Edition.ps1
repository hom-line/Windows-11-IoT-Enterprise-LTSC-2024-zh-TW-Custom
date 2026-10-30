#Requires -Version 5.1
<#
.SYNOPSIS
  Read-only verification of Windows 11 IoT Enterprise LTSC-based custom images.
.DESCRIPTION
  Accepts build families 26100 (24H2), 26200 (25H2), and 26300 (26H2).
  25H2 and 26H2 are experimental LTSC-based builds, not official LTSC releases.
  Does not modify the operating system or activate Windows.
.PARAMETER ExpectedVersion
  Auto, 24H2, 25H2 or 26H2.
.PARAMETER StrictLanguage
  Require evidence of zh-TW as the OS system locale or an installed language.
.PARAMETER JsonPath
  Optional JSON evidence output.
#>
[CmdletBinding()]
param(
    [ValidateSet('Auto','24H2','25H2','26H2')]
    [string]$ExpectedVersion='Auto',
    [switch]$StrictLanguage,
    [string]$JsonPath
)
Set-StrictMode -Version Latest
$ErrorActionPreference='Stop'
try {
    $reg=Get-ItemProperty -LiteralPath 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -ErrorAction Stop
    $buildText=if($reg.PSObject.Properties['CurrentBuildNumber']){[string]$reg.CurrentBuildNumber}else{[string]$reg.CurrentBuild}
    $build=[int]::Parse($buildText)
    $ubr=if($reg.PSObject.Properties['UBR']){[int]$reg.UBR}else{0}
    $edition=[string]$reg.EditionID
    $version=[string]$reg.DisplayVersion
    $map=@{'26100'='24H2';'26200'='25H2';'26300'='26H2'}
    $detected=if($map.ContainsKey($buildText)){$map[$buildText]}else{'UNRECOGNIZED'}
    $target=if($ExpectedVersion -eq 'Auto'){$detected}else{$ExpectedVersion}
    $expectedBuild=@{'24H2'=26100;'25H2'=26200;'26H2'=26300}
    $buildOK=$expectedBuild.ContainsKey($target) -and $build -eq $expectedBuild[$target]
    $versionOK=$version -eq $target -and $target -ne 'UNRECOGNIZED'
    $editionOK=$edition -eq 'IoTEnterpriseS'
    $archOK=[Environment]::Is64BitOperatingSystem
    $locale=''
    try{$locale=(Get-WinSystemLocale -ErrorAction Stop).Name}catch{}
    $installed=@()
    if(Get-Command 'Get-InstalledLanguage' -ErrorAction SilentlyContinue){
        try{$installed=@(Get-InstalledLanguage -ErrorAction Stop | ForEach-Object {$_.LanguageId})}catch{}
    }
    $langOK=$locale -eq 'zh-TW' -or $installed -contains 'zh-TW'
    $langStatus=if($langOK){'PASS'}elseif($StrictLanguage){'FAIL'}else{'WARN'}
    $checks=@(
        [pscustomobject]@{Check='EditionID';Expected='IoTEnterpriseS';Actual=$edition;Status=$(if($editionOK){'PASS'}else{'FAIL'})}
        [pscustomobject]@{Check='Build';Expected=[string]$expectedBuild[$target];Actual=$buildText;Status=$(if($buildOK){'PASS'}else{'FAIL'})}
        [pscustomobject]@{Check='DisplayVersion';Expected=$target;Actual=$version;Status=$(if($versionOK){'PASS'}else{'FAIL'})}
        [pscustomobject]@{Check='Architecture';Expected='x64';Actual=$(if($archOK){'x64'}else{'other'});Status=$(if($archOK){'PASS'}else{'FAIL'})}
        [pscustomobject]@{Check='OS language';Expected='zh-TW';Actual=("SystemLocale={0}; Installed={1}" -f $locale,($installed -join ','));Status=$langStatus}
    )
    $result=[ordered]@{
        Timestamp=(Get-Date).ToString('o')
        DetectedVersion=$detected
        SelectedVersion=$target
        Build=$build
        UBR=$ubr
        EditionID=$edition
        Experimental=($detected -in @('25H2','26H2'))
        Checks=$checks
        Notice='25H2 and 26H2 are not official Microsoft LTSC 2024 releases. EditionID does not prove activation.'
    }
    Write-Host ("Windows 11 verification: {0} / {1}.{2}" -f $detected,$build,$ubr) -ForegroundColor Cyan
    $checks | Format-Table -AutoSize | Out-Host
    if($JsonPath){
        $parent=Split-Path -Parent $JsonPath
        if($parent -and -not (Test-Path -LiteralPath $parent)){throw "Output directory missing: $parent"}
        $json=ConvertTo-Json -InputObject $result -Depth 6
        [IO.File]::WriteAllText([IO.Path]::GetFullPath($JsonPath),$json,(New-Object System.Text.UTF8Encoding($false)))
    }
    if(@($checks | Where-Object {$_.Status -eq 'FAIL'}).Count -gt 0){
        Write-Host 'FAIL: Windows edition/version/build/language validation.' -ForegroundColor Red
        exit 1
    }
    if($langStatus -eq 'WARN'){Write-Warning 'OS language evidence not found; add -StrictLanguage for strict mode.'}
    Write-Host 'PASS: required operating system checks.' -ForegroundColor Green
    exit 0
}catch{
    Write-Host ("ERROR: " + $_.Exception.Message) -ForegroundColor Red
    exit 2
}
