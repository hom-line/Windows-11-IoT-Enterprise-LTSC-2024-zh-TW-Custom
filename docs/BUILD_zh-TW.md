# Windows 11 IoT Enterprise LTSC 2024 — 建置紀錄（繁體中文）

> 最後整理：2026-10-30。本文整理本專案的實際製作方法及目前可追溯的測試結果，並非 Microsoft 官方製作指引。相關 ISO 均為開發者本機自訂映像。

## 1. 版本與共同配置

| 項目 | 24H2 App | 25H2 App | 26H2 App |
|---|---|---|---|
| 原始平台 | Windows 11 IoT Enterprise LTSC 2024 | 同一 24H2 參考平台 | 同一 24H2 參考平台 |
| 最終功能版本 | 24H2 | 25H2 | 26H2 |
| 主 Build | 26100 | 26200 | 26300 |
| 離線 Enablement Package | 無 | `KB5054156.msu` | `KB5121794.msu` |
| 語言／架構 | zh-TW／x64 | zh-TW／x64 | zh-TW／x64 |
| Edition 測試紀錄 | `IoTEnterpriseS` | `IoTEnterpriseS` | `IoTEnterpriseS` |
| 共同預裝配置 | 17 項 Inbox Apps + FOD + WordPad／AC-3 研究 | 相同 | 相同 |
| 實際安裝測試 | PASS | PASS（作者回報） | PASS（作者回報） |

**重要：** 本專案的 25H2、26H2 並非 Microsoft 官方發布的 LTSC 2024 後續版本。兩者都是由**獨立的已更新 24H2 參考分支**建立；不是依序將 24H2 升成 25H2，再把 25H2 升成 26H2。

## 2. 三分支製作架構

```text
Windows 11 IoT Enterprise LTSC 2024 (24H2)
  └── 參考虛擬機：Windows Update / 共同預裝程式 / Framework
      ├── 分支 A：24H2 → Sysprep → WinPE → WIM → ISO → 安裝測試
      ├── 分支 B：24H2 + KB5054156.msu → 25H2 → Sysprep → WIM → ISO → 安裝測試
      └── 分支 C：24H2 + KB5121794.msu → 26H2 → Sysprep → WIM → ISO → 安裝測試
```

建置時應各自保留 VM Snapshot、更新套件來源、累積更新 KB、完整 Build、WIM 的 Image Name／Description 與測試日期。

### 2.1 Microsoft 官方 Enablement Package 的先決條件

- 25H2：`KB5054156` 官方資料要求 24H2 已安裝 `KB5064081`（26100.5074）或後續累積更新。
- 26H2：`KB5121794` 官方資料要求 24H2／25H2 已安裝 `KB5124010`（26100.9546）或後續累積更新。

這是一般 Windows 11 對應版本的官方文件要求，**不能因此宣稱這種 LTSC 2024 實驗改版獲 Microsoft 支援**。目前尚未取得可直接證明 26H2 參考系統符合全部先決條件的逐項安裝紀錄。

官方文件：[KB5054156](https://support.microsoft.com/zh-tw/servicing/os/windows/docs/2025/02/kb5054156-feature-update-to-windows-11-version-25h2-by-using-an-enablement-package) · [KB5121794](https://support.microsoft.com/zh-tw/servicing/os/windows-11/2026/09/kb5121794-feature-update-to-windows-11-version-26h2)

## 3. 共同預裝項目

### 3.1 17 項主要 Apps

| 類別 | 項目 |
|---|---|
| Store／安裝器 | Microsoft Store、Store Purchase App、Desktop App Installer |
| 工具 | Calculator、Paint、Notepad、Snipping Tool |
| 影音應用 | Camera、Photos、Media Player |
| 影音擴充 | AV1、AVC Encoder、VP9、HEIF、WebP、Web Media、MPEG-2 |

另包含必要的 Framework 依存套件。**HEVC Video Extensions 未納入共同預裝範圍**。

### 3.2 Optional Features／相容性研究

- .NET Framework 3.5（NetFx3）
- Windows Fax and Scan
- XPS Viewer
- WordPad：嘗試以 Windows 10 FOD 跨版本整合到 Windows 11，非官方支援安裝路徑
- AC-3／Dolby：實驗性相容性恢復；OEM AppxBundle 曾因使用者安裝／Provisioning 不一致造成 Sysprep 失敗，後續改以 AnWave RollbackDolby 研究，該路線已有 Sysprep PASS 記錄

**Sysprep PASS 不代表音訊實際解碼、音效品質、更新後相容性或第三方再散布授權均已通過。**

## 4. Sysprep／WIM／ISO 流程

開發者的 VM 測試流程為：快照 → 驗證共同預裝內容 → Sysprep／Generalize／OOBE／Shutdown → 從 WinPE 啟動 → 對離線 Windows 分割區擷取 install.wim → 檢查 WIM 中的 Windows.old、映像名稱、描述與索引 → 替換 ISO 安裝映像 → 使用新的虛擬硬碟進行全新安裝。

PowerShell／命令提示字元的診斷指令（請自行確認所在環境與磁碟代號）：

```powershell
Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' |
  Select-Object EditionID, DisplayVersion, CurrentBuild, UBR

Get-AppxProvisionedPackage -Online |
  Select-Object DisplayName, PackageName

Get-WindowsOptionalFeature -Online -FeatureName NetFx3

Get-WindowsCapability -Online |
  Where-Object Name -match 'Print.Fax.Scan|XPS.Viewer'
```

```cmd
dism /online /Get-CurrentEdition
dism /Get-ImageInfo /ImageFile:install.wim /Index:1
```

### 4.1 24H2 的 Windows Setup `0x800700B7` 修正

早期 WIM 含根目錄 `Windows.old`；Windows Setup 在 Finalize 的 Relocate OS 階段曾失敗，回傳 `0x800700B7`。後續對 WIM **副本**移除 `Windows.old` 並補齊 Image Description，通過 `wimlib verify`／DISM，R3 ISO 也成功完成 VMware 全新安裝與 OOBE。

兩項修正同時套用，**不能僅從 R3 PASS 斷言某一項是唯一根因**。

## 5. ISO 檔名

```text
zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_24H2_App.iso
zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_25H2_App.iso
zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_26H2_App.iso
```

這些是本專案自訂名稱，並非官方 ISO 發行識別碼。

## 6. 版本記錄與驗證文件

- [驗收報告](VALIDATION_zh-TW.md)
- [專案 README](../README.md)
- [24H2 App Release](../releases/RELEASE_24H2_zh-TW.md)
- [25H2 App Release](../releases/RELEASE_25H2_zh-TW.md)
- [26H2 App Release](../releases/RELEASE_26H2_zh-TW.md)

## 7. 授權與用途

公開 Repository 用於記錄技術流程與公開校驗資料。Windows、Microsoft Store、OEM／Dolby 影音套件及其授權檔案的公開再散布必須遵守適用授權。**目前不附 Windows ISO 或第三方二進位安裝檔。**
