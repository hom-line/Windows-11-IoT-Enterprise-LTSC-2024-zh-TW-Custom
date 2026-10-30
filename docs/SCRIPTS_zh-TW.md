# Windows 11 專案 PowerShell 工具使用說明

適用 Windows 11 IoT Enterprise LTSC 2024 基底的 24H2（26100）、25H2（26200）、26H2（26300）自訂測試 VM。**25H2、26H2 非 Microsoft 官方 LTSC 2024 功能更新版本。**

> [!IMPORTANT]
> 以下工具尚未在使用者的三套 Windows 11 VM 進行實機執行驗收；已發布的是第一版腳本與文件，不能宣稱它們已經在 Windows GUI／PowerShell 全部 PASS。先建立 VM Snapshot、使用合法來源套件。

## 工具一覽

| 檔案 | 功能 | 預設狀態 |
|---|---|---|
| [Verify-Windows-Edition.ps1](../scripts/Verify-Windows-Edition.ps1) | Edition、24H2/25H2/26H2、Build、x64、zh-TW | 唯讀 |
| [Verify-InboxApps.ps1](../scripts/Verify-InboxApps.ps1) | 17 項 Inbox Apps、Framework 清單、NetFx3、Fax and Scan、XPS Viewer | 唯讀 |
| [Provision-InboxApps.ps1](../scripts/Provision-InboxApps.ps1) | SHA-256／授權／套件相依性預檢、合法來源 AppX/MSIX 佈建 | 預設唯讀，明確指定 -Apply 才會修改 |

使用 **Windows PowerShell 5.1（以系統管理員身分執行）**。指令中的 `.\scripts\` 是 GitHub 專案目錄下的相對路徑；無需 Git CLI，亦可從 GitHub 網頁下載原始腳本。

## 1. 檢查 Windows 版本

分別在各版本的 VM 執行相對應的一行（非在單一 VM 連續執行三行）。事先建立 `C:\Temp`。

```powershell
New-Item -ItemType Directory C:\Temp -Force | Out-Null
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\scripts\Verify-Windows-Edition.ps1" -ExpectedVersion 24H2 -StrictLanguage -JsonPath "C:\Temp\Win11_24H2.json"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\scripts\Verify-Windows-Edition.ps1" -ExpectedVersion 25H2 -StrictLanguage -JsonPath "C:\Temp\Win11_25H2.json"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\scripts\Verify-Windows-Edition.ps1" -ExpectedVersion 26H2 -StrictLanguage -JsonPath "C:\Temp\Win11_26H2.json"
```

驗證 `EditionID = IoTEnterpriseS`，主 Build 分別為 `26100`／`26200`／`26300`、DisplayVersion、x64 與 OS zh-TW 語言證據；未啟用 `-StrictLanguage` 時語言不足只警告。不替 Windows 啟用，也不修改版號。Exit code：0 PASS、1 不符合、2 執行錯誤。

## 2. 檢查 17 項 Inbox Apps 與 FOD

```powershell
New-Item -ItemType Directory C:\Temp -Force | Out-Null
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\scripts\Verify-InboxApps.ps1" -CsvPath "C:\Temp\Win11_Apps.csv" -JsonPath "C:\Temp\Win11_Apps.json"
```

17 項套件名稱：Microsoft.StorePurchaseApp、Microsoft.WindowsStore、Microsoft.DesktopAppInstaller、Microsoft.WindowsCalculator、Microsoft.Paint、Microsoft.WindowsNotepad、Microsoft.ScreenSketch、Microsoft.WindowsCamera、Microsoft.Windows.Photos、Microsoft.ZuneMusic、Microsoft.AV1VideoExtension、Microsoft.AVCEncoderVideoExtension、Microsoft.VP9VideoExtensions、Microsoft.HEIFImageExtension、Microsoft.WebpImageExtension、Microsoft.WebMediaExtensions、Microsoft.MPEG2VideoExtension。

- Apps 的 **Provisioned（新使用者佈建）** 是必要檢查；已安裝狀態與 Framework 偵測是另外列示的資料。
- Framework 不硬編 Windows 10 舊專案的 18 組固定版本，而依實際 `Microsoft.NET.Native`、`Microsoft.UI.Xaml`、`Microsoft.VCLibs` 辨識，標為 INFO，**不代表完成每個 App 的相依性解析**。
- FOD 包含 `NetFx3`、`Print.Fax.Scan~~~~0.0.1.0`、`XPS.Viewer~~~~0.0.1.0`。
- 未將 HEVC 列入 17 項。WordPad 和 Dolby AC-3／E-AC-3 的真實啟動、播放仍需獨立測試。

## 3. Provision-InboxApps：預檢優先

**本工具沒有內附或下載 Microsoft／Dolby AppX、MSIX 和離線授權 XML。** 使用者必須自行取得合法來源檔案、對應授權 XML 及正確 SHA-256。

### 3.1 SourceRoot／Manifest

例如於 VM 建立 `D:\Win11AppSource`、`D:\Win11AppConfig`：

```text
D:\Win11AppSource\
  apps\
    Microsoft.WindowsStore_EXAMPLE.msixbundle
  frameworks\
    Microsoft.VCLibs.140.00_EXAMPLE.appx
  licenses\
    Microsoft.WindowsStore_EXAMPLE.xml
D:\Win11AppConfig\
  InboxApps.manifest.json
```

下列為**Manifest 物件結構範例，不是真實 Microsoft 套件，也不可直接執行**；占位的 SHA-256 必須替換成真實 64 位十六進位雜湊，每個資料夾與檔案也必須替換。

```json
{
  "schema": 1,
  "packages": [
    {
      "name": "Microsoft.VCLibs.140.00",
      "kind": "Framework",
      "package": "frameworks/Microsoft.VCLibs.140.00_EXAMPLE.appx",
      "sha256": "REPLACE_WITH_ACTUAL_64_HEX_SHA256",
      "license": "licenses/Microsoft.VCLibs.140.00_EXAMPLE.xml",
      "licenseSha256": "REPLACE_WITH_ACTUAL_64_HEX_SHA256"
    },
    {
      "name": "Microsoft.WindowsStore",
      "kind": "App",
      "package": "apps/Microsoft.WindowsStore_EXAMPLE.msixbundle",
      "sha256": "REPLACE_WITH_ACTUAL_64_HEX_SHA256",
      "license": "licenses/Microsoft.WindowsStore_EXAMPLE.xml",
      "licenseSha256": "REPLACE_WITH_ACTUAL_64_HEX_SHA256",
      "dependencies": [
        {
          "package": "frameworks/Microsoft.VCLibs.140.00_EXAMPLE.appx",
          "sha256": "REPLACE_WITH_ACTUAL_64_HEX_SHA256"
        }
      ]
    }
  ]
}
```

以上只展示格式。**完整佈建應列出全部 17 個主 App**，並依實際 App 套件要求加入 Framework 和相依性。未列齊 17 項會中止，除非明確指定 `-AllowPartial`（供刻意的部分測試）。框架版本與架構不得直接沿用 Windows 10 的固定清單。

實際 SHA-256 例：

```powershell
Get-FileHash -LiteralPath "D:\Win11AppSource\apps\Microsoft.WindowsStore_EXAMPLE.msixbundle" -Algorithm SHA256
```

### 3.2 安全預檢（不安裝）

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\scripts\Provision-InboxApps.ps1" -SourceRoot "D:\Win11AppSource" -ManifestPath "D:\Win11AppConfig\InboxApps.manifest.json"
```

檢查 Build／Edition／x64、套件允許清單、路徑不越界、真實檔案、主套件／相依套件／授權 XML 的 SHA-256、XML 格式與 17 項清單；任何錯誤均在修改 Windows 前中止。

### 3.3 明確安裝（僅限已備份的參考測試 VM）

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File ".\scripts\Provision-InboxApps.ps1" -SourceRoot "D:\Win11AppSource" -ManifestPath "D:\Win11AppConfig\InboxApps.manifest.json" -Apply -AcknowledgeReferenceImage
```

依 Framework → Apps 順序執行；已佈建套件會略過，不移除或降版；PowerShell 會以 ShouldProcess 請求確認。合法免 License XML 的套件才可在 Manifest 宣告 `licenseNotRequired: true`，且額外提供 `-AllowLicenseFree`。**不能將此當作規避授權的手段**。

安裝後仍須執行兩支 Verify、以新的 Windows 使用者開啟 Apps，並檢查 Sysprep／OOBE／Windows Update 回歸。WordPad、Dolby 不屬於此佈建腳本範圍。

## 4. 版本與測試狀態

- GitHub 第一版原始碼、README、授權聲明：**已提交**。
- PowerShell Parser／Windows 11 VM 真實執行：**待驗收**。
- 17 項合法來源 AppX/MSIX／授權 XML：**由使用者依授權自行準備**。
- 本專案僅是原創腳本與技術分享；[使用風險與法律授權範圍](LEGAL_NOTICE_zh-TW.md)。

參考：[Microsoft Add-AppxProvisionedPackage](https://learn.microsoft.com/en-us/powershell/module/dism/add-appxprovisionedpackage) · [Get-AppxProvisionedPackage](https://learn.microsoft.com/en-us/powershell/module/dism/get-appxprovisionedpackage)
