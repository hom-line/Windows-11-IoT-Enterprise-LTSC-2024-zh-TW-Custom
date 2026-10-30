# Windows 11 IoT Enterprise LTSC 2024 — Custom 24H2 / 25H2 / 26H2 zh-TW

Custom Windows 11 IoT Enterprise LTSC 2024 reference-image, Windows Inbox Apps provisioning, and deployment research project.

本專案以 **Windows 11 IoT Enterprise LTSC 2024 繁體中文 x64** 為參考系統，整合常用 Microsoft Inbox Apps、Windows Optional Features、傳統工具及影音相容性研究，並分別製作 **24H2、25H2、26H2** 三套自訂映像。

**三套映像採用相同的預裝項目與整合配置，主要差別是 Windows 功能版本與 Build。依專案作者最新回報，24H2、25H2、26H2 均已完成安裝測試並可正常使用；逐項 Apps／AC-3／Windows Update 完整回歸記錄仍需另外彙整。** 本專案是獨立的技術研究，不是 Microsoft 或 Dolby 官方發行版。

- Maintainer：[hom-line](https://github.com/hom-line)
- Language：`zh-TW`
- Architecture：`x64`
- Edition ID：`IoTEnterpriseS`（依既有測試映像紀錄）
- Reference base：`Windows 11 IoT Enterprise LTSC 2024`
- Prepared：`2026-10-30`

---

## 📚 建置與驗收報告

已整理正式的公開紀錄，供開發者與使用者核對版本來源、製作流程及測試範圍：

- [建置紀錄／三版本製作流程（繁體中文）](docs/BUILD_zh-TW.md) — 24H2、25H2、26H2 的獨立分支、Inbox Apps、FOD、Sysprep、WIM／ISO 與 Setup 修正。
- [驗收報告／ISO 完整性校驗（繁體中文）](docs/VALIDATION_zh-TW.md) — 三版安裝 PASS、SHA-256 首次與再次驗證 PASS，以及尚未提供完整證據的功能回歸項目。

> [!NOTE]
> ISO Metadata 與 SHA-256 總表已出現在 [24H2 App Release](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/tag/24H2-App-R3) 的附件中；公開的中繼資料仍應留意隱私與來源欄位。

## 🛠️ PowerShell 工具／原創腳本

本 Repository 現已包含與 Windows 10 舊專案用途相對應的三支 **Windows 11 專用** PowerShell 5.1 工具，適用於 24H2／25H2／26H2 自訂測試環境：

| 檔案 | 功能 | 執行模式 |
|---|---|---|
| [Provision-InboxApps.ps1](scripts/Provision-InboxApps.ps1) | 合法來源 AppX/MSIX＋授權 XML＋SHA-256 預檢，Framework 優先、17 項 Inbox Apps 佈建 | **預設唯讀預檢**，必須明確使用 `-Apply -AcknowledgeReferenceImage` 才修改 Windows |
| [Verify-InboxApps.ps1](scripts/Verify-InboxApps.ps1) | 檢查 17 項 App Provisioning、實際 Framework 清單、NetFx3、Fax and Scan、XPS Viewer | **唯讀** |
| [Verify-Windows-Edition.ps1](scripts/Verify-Windows-Edition.ps1) | 檢查 `IoTEnterpriseS`、24H2／25H2／26H2、主 Build、x64、zh-TW | **唯讀** |

- [完整操作教學、合法套件 Manifest 範例](docs/SCRIPTS_zh-TW.md)
- [MIT LICENSE（僅原創腳本與文件）](LICENSE)
- [技術分享、使用風險與第三方授權聲明](docs/LEGAL_NOTICE_zh-TW.md)

> [!IMPORTANT]
> **這些工具是第一版原創交付，尚未在三個 Windows 11 VM 完成 PowerShell Parser／真實執行驗收。** 使用者須自行評估操作風險、建立快照並遵守授權條款。上述 MIT License **不涵蓋** Windows ISO、Microsoft、Dolby 或第三方二進位檔。所有免責與責任分配僅於適用法律允許範圍內生效。

## ⚠️ Important Notice / 重要聲明

**Microsoft 官方 Windows 11 IoT Enterprise LTSC 2024 為 24H2／Build 26100**，並不是官方的「25H2 LTSC」或「26H2 LTSC」。

| 版本 | Microsoft 官方產品定位 | 本專案定位 |
|---|---|---|
| `24H2 / 26100` | **Windows 11 IoT Enterprise LTSC 2024** | 官方 LTSC 2024 基底的自訂映像 |
| `25H2 / 26200` | Windows 11 IoT Enterprise **非 LTSC** 有此功能版本 | 以 LTSC 2024 為基底的**非官方實驗改版** |
| `26H2 / 26300` | Windows 11 IoT Enterprise **非 LTSC** 有此功能版本 | 以 LTSC 2024 為基底的**非官方實驗改版** |

> [!WARNING]
> - 25H2／26H2 在本專案中的「LTSC」名稱僅說明自訂參考映像**來源**與 Edition 研究結果，**不表示 Microsoft 核准此 LTSC 更新路徑或承諾 LTSC 支援生命週期**。
> - 這些映像不提供 Windows 授權、產品金鑰、啟用繞過或破解功能。
> - 本儲存庫及 Release 已公開，**且已包含 Windows 安裝映像的加密分卷**。如未具有 Microsoft／Dolby／第三方元件的再散布權，應立即暫停公開提供並移除相關附件；**壓縮密碼不是授權**。

官方資料：[Windows 11 IoT Enterprise LTSC 2024](https://learn.microsoft.com/zh-tw/windows/iot/iot-enterprise/whats-new/windows-11-iot-enterprise-ltsc-2024) · [Windows IoT Enterprise 發行歷程](https://learn.microsoft.com/zh-tw/windows/iot/iot-enterprise/whats-new/release-history)

---

# ⬇️ Download / 下載與版本狀態

**三個 GitHub Release 頁面已公開，且專案作者回報三個 ISO 均已測試安裝成功。** 目前已公開 24H2（3 卷）、25H2（6 卷）、26H2（6 卷）的加密 ISO 分卷及各自 SHA-256 清單；另需確認再散布權利與逐項驗收證據。

| 順序 | 公開 Release | Edition | 版本 | 主 Build | 語言 | 預裝內容 | 安裝測試 |
|---|---|---|---|---|---|---|---|
| **1** | [24H2 App](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/tag/24H2-App-R3) | `IoTEnterpriseS` | **24H2** | `26100` | `zh-TW` | 相同配置 | **PASS：新安裝與桌面已驗證** |
| **2** | [25H2 App](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/tag/25H2-App-Experimental) | `IoTEnterpriseS` | **25H2** | `26200` | `zh-TW` | 相同配置 | **PASS：作者回報安裝測試成功** |
| **3** | [26H2 App](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/tag/26H2-App-Experimental) | `IoTEnterpriseS` | **26H2** | `26300` | `zh-TW` | 相同配置 | **PASS：作者回報安裝測試成功** |

> [!NOTE]
> 版本表中 `26100`、`26200`、`26300` 是主 Build；`26100.1742`、`26200.9457`、`26300.9457` 等為個別實驗時點曾觀察到的完整 Build，**不代表最新更新，也不保證三版具有相同的累積更新修訂號**。

### 📦 已發布的 7-Zip 分卷／公開附件索引

| Release | 分卷 | 分卷校驗清單 | ISO SHA-256 | 附件狀態 |
|---|---:|---|---|---|
| [24H2 App](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/tag/24H2-App-R3) | **3** | [SHA256_7Z_Parts_24H2.txt](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/24H2-App-R3/SHA256_7Z_Parts_24H2.txt) | [SHA256_24H2.txt](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/24H2-App-R3/SHA256_24H2.txt) | 已上傳 |
| [25H2 App](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/tag/25H2-App-Experimental) | **6** | [SHA256_7Z_Parts_25H2.txt](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/25H2-App-Experimental/SHA256_7Z_Parts_25H2.txt) | [SHA256_25H2.txt](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/25H2-App-Experimental/SHA256_25H2.txt) | 已上傳 |
| [26H2 App](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/tag/26H2-App-Experimental) | **6** | [SHA256_7Z_Parts_26H2.txt](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/26H2-App-Experimental/SHA256_7Z_Parts_26H2.txt) | [SHA256_26H2.txt](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/26H2-App-Experimental/SHA256_26H2.txt) | 已上傳 |

24H2 的共同資料另有 [SHA256_ALL.txt](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/24H2-App-R3/SHA256_ALL.txt) 與 [ISO_Metadata.csv](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/24H2-App-R3/ISO_Metadata.csv)。

> [!CAUTION]
> 本節紀錄公開上傳的客觀狀態，不代表 Microsoft 或 Dolby 授權轉載。若缺乏再散布權利，請將二進位附件下架。Github 上存在的附件不代表其內容已獲官方授權、審查或驗證。

## 🔐 SHA-256 / 已公開的 ISO 校驗檔

三個 ISO 已在本機完成 SHA-256 計算，並經再次執行 `-Verify` 全部通過。以下校驗檔已上傳至各自公開的 GitHub Release：

| 版本 | SHA-256 下載 | 校驗結果 |
|---|---|---|
| **24H2 App** | [SHA256_24H2.txt](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/24H2-App-R3/SHA256_24H2.txt) | **PASS** |
| **25H2 App** | [SHA256_25H2.txt](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/25H2-App-Experimental/SHA256_25H2.txt) | **PASS** |
| **26H2 App** | [SHA256_26H2.txt](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/26H2-App-Experimental/SHA256_26H2.txt) | **PASS** |

> [!NOTE]
> SHA-256 可檢查取得的檔案是否與專案校驗檔一致，**不代表 Microsoft 官方簽章、原廠授權或映像安全審核**。目前公開附件除校驗檔外，另有三版加密 ISO 分卷；Windows／Dolby 等再散布權利必須另外確認，下載與 SHA-256 驗證本身不能作為授權依據。

### ISO File Names / ISO 檔案命名

```text
zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_24H2_App.iso
zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_25H2_App.iso
zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_26H2_App.iso
```

以上均為**本專案自訂檔名**；前綴 `6287d84d` 為檔名文字，**不能代替映像雜湊或證明來自官方**。

## 🔑 Archive / 壓縮格式與密碼

已使用 **7-Zip 加密分卷（`.7z.001`、`.7z.002`……）** 發布，單卷最大 1800 MiB，低於 GitHub Release 的 2 GiB 單檔限制。

```text
Archive Format  : 7z (split volumes)
Archive Password: 1742
```

如具備合法使用與取得權利，下載時必須取得**同一版本全部分卷**、放在同一資料夾，從 `.7z.001` 開始使用 7-Zip 解壓；**不需要逐卷解壓**。目前分卷數為：24H2 **3 卷**、25H2 **6 卷**、26H2 **6 卷**。

三個版本的加密 ISO 分卷、原始 ISO SHA-256，以及 `SHA256_7Z_Parts_版本.txt` 均已上傳。**已驗證的是 GitHub 附件的存在、檔名和大小，以及本機封裝測試；尚未從 GitHub 重新下載全套分卷做端到端還原驗證。**

---

# 🆕 24H2 App — Base Release / 基準版本

> **Current Verified Installation Baseline / 目前已完成安裝驗證的版本**

| Item | Value |
|---|---|
| Product | Windows 11 IoT Enterprise LTSC 2024 |
| Edition | `IoTEnterpriseS` |
| Version | `24H2` |
| Build family | `26100` |
| Verified R3 image | `10.0.26100.1742` |
| Architecture | `x64` |
| Language | `zh-TW` |
| Inbox Apps | 17 項共同配置 |
| Optional Features | .NET 3.5、Fax and Scan、XPS Viewer |
| Additional experiments | WordPad、AC-3／Dolby 恢復 |
| Install validation | **R3 安裝、OOBE、進入桌面 PASS** |

### Windows Setup R3 Fix

初期自訂 `install.wim` 在安裝接近完成時出現：

```text
CRelocateOS: Cannot move ... Windows.old
Error: 0x800700B7
Windows Setup Finalize: FAILED
```

檢查發現 WIM 根目錄有 `\Windows.old\`，且 Description 顯示 `<undefined>`。在**保留原始 WIM** 的前提下建立 R3 修正版：

- 移除 WIM 根目錄 `Windows.old` 安裝殘留。
- 補上 Image Description。
- 通過 `wimlib verify` 與 DISM 映像資訊檢查。
- 使用新 ISO 在 VMware **完成全新安裝、OOBE 並進入 Windows 桌面**。

**R3 的兩項修正是一起完成的，不能僅憑這次結果確定唯一根因。** 此次 PASS 也不代表 AC-3 實際播放或 Windows Update 回歸已經全部通過。

---

# 📦 25H2 App — Installation PASS / LTSC-based Experimental

| Item | Value |
|---|---|
| Reference base | 已更新的 Windows 11 24H2 參考系統 |
| Offline update | **`KB5054156.msu`** |
| Feature version | `25H2` |
| Build family | `26200` |
| Previously observed | `26200.9457` |
| Common Apps / FOD | 與 24H2 相同配置目標 |
| Status | **Experimental — 作者回報安裝測試 PASS；逐項功能回歸仍需確認** |

## What changed from 24H2?

```text
Updated 24H2 reference environment
       │
       ├─ Common 17 Inbox Apps / FOD / WordPad / AC-3 research
       │
       ▼
Offline enablement package: KB5054156.msu
       │
       ▼
25H2 / Build 26200
       │
       ▼
Sysprep → WinPE → WIM → Custom ISO → New VM validation
```

Microsoft 的 `KB5054156` 是 **25H2 Enablement Package**。官方要求來源為 Windows 11 24H2，並先安裝 **KB5064081（Build 26100.5074）或之後的累積更新**。

**重要：** Microsoft 官方的 Enablement Package 適用產品清單包括 Windows 11 IoT Enterprise（非 LTSC）；本專案在 LTSC 2024 上的做法**仍屬實驗、不得寫成官方 LTSC 25H2 升級管道**。

官方說明：[KB5054156 — Windows 11 25H2](https://support.microsoft.com/en-au/servicing/os/windows/docs/2025/02/kb5054156-feature-update-to-windows-11-version-25h2-by-using-an-enablement-package)

---

# 📦 26H2 App — Installation PASS / LTSC-based Experimental

| Item | Value |
|---|---|
| Reference base | 已更新的 Windows 11 24H2 參考系統 |
| Offline update | **`KB5121794.msu`** |
| Feature version | `26H2` |
| Build family | `26300` |
| Previously observed | `26300.9457` |
| Common Apps / FOD | 與 24H2 相同配置目標 |
| Status | **Experimental — 作者回報安裝測試 PASS；先決條件與逐項功能回歸仍需確認** |

## What changed from 24H2?

```text
Updated 24H2 reference environment
       │
       ├─ Common 17 Inbox Apps / FOD / WordPad / AC-3 research
       │
       ▼
Offline enablement package: KB5121794.msu
       │
       ▼
26H2 / Build 26300
       │
       ▼
Sysprep → WinPE → WIM → Custom ISO → New VM validation
```

Microsoft 的 `KB5121794` 是 **26H2 Enablement Package**。官方允許符合條件的 Windows 11 24H2 或 25H2 作為來源，並要求先安裝 **KB5124010（Build 26100.9546）或更高版本累積更新**。

> [!CAUTION]
> 本專案先前的 `26300.9457` 畫面不足以證明符合上述 `26100.9546` 先決條件；應核對實際安裝順序、累積更新與 KB 記錄。此處不宣稱 26H2 實驗映像具備官方 LTSC 支援資格。

官方說明：[KB5121794 — Windows 11 26H2](https://support.microsoft.com/zh-tw/servicing/os/windows-11/2026/09/kb5121794-feature-update-to-windows-11-version-26h2)

---

# 🔄 Release Evolution / 版本演進

以下為**三個獨立映像的發布順序**，不代表所有 VM 都逐版連續升級。

```text
                          Windows 11 IoT Enterprise LTSC 2024
                                  Updated 24H2 Base
                                          │
                  ┌───────────────────────┼────────────────────────┐
                  │                       │                        │
                  ▼                       ▼                        ▼
            24H2 / 26100           KB5054156.msu             KB5121794.msu
             Base image                  │                        │
                  │                       ▼                        ▼
                  │                 25H2 / 26200              26H2 / 26300
                  │                   Experimental              Experimental
                  │                       │                        │
                  └───────────────────────┼────────────────────────┘
                                          ▼
                          Same intended preinstalled App configuration
                             Separate Sysprep / WIM / ISO tests
```

---

# 🛍️ Microsoft Inbox Apps / 共用預裝應用程式

**三個版本相同的預裝配置：17 項主要 Inbox Apps**，及相依的 Microsoft Framework 套件。此處列的是**套件識別名稱**，不預填未逐版核對的精確 App 版本號。

## Microsoft Store / Installer（3）

| App | Package name |
|---|---|
| Microsoft Store | `Microsoft.WindowsStore` |
| Store Purchase App | `Microsoft.StorePurchaseApp` |
| Desktop App Installer | `Microsoft.DesktopAppInstaller` |

## Windows Utilities（4）

| App | Package name |
|---|---|
| Calculator／計算機 | `Microsoft.WindowsCalculator` |
| Paint／小畫家 | `Microsoft.Paint` |
| Notepad／記事本 | `Microsoft.WindowsNotepad` |
| Snipping Tool／剪取工具 | `Microsoft.ScreenSketch` |

## Media Apps（3）

| App | Package name |
|---|---|
| Camera／相機 | `Microsoft.WindowsCamera` |
| Photos／相片 | `Microsoft.Windows.Photos` |
| Media Player | `Microsoft.ZuneMusic` |

## Media Extensions（7）

| Extension | Package name |
|---|---|
| AV1 Video | `Microsoft.AV1VideoExtension` |
| AVC Encoder | `Microsoft.AVCEncoderVideoExtension` |
| VP9 Video | `Microsoft.VP9VideoExtensions` |
| HEIF Image | `Microsoft.HEIFImageExtension` |
| WebP Image | `Microsoft.WebpImageExtension` |
| Web Media | `Microsoft.WebMediaExtensions` |
| MPEG-2 Video | `Microsoft.MPEG2VideoExtension` |

共同配置之外的 **Framework / Dependencies** 會依來源套件的架構與版本安裝必要相依項。**不要將 Main Package 與 Bundle 的版本號直接比較為衝突**；這點已在此前的 Windows 11 Provisioning 測試中釐清。

> [!NOTE]
> `HEVC Video Extensions（H.265）` **未列入共同預裝清單**。`HEIF Image Extensions` 不保證能在缺乏適當 HEVC 解碼器時讀取所有 HEIC 影像。

---

# 🧩 Optional Features / 傳統 Windows 功能

| Component | Integration | Notes |
|---|---|---|
| .NET Framework 3.5 | Windows 11 官方 Languages and Optional Features 來源 | `NetFx3` |
| Windows Fax and Scan | Windows Capability / FOD | `Print.Fax.Scan~~~~0.0.1.0` |
| XPS Viewer | Windows Capability / FOD | `XPS.Viewer~~~~0.0.1.0` |
| WordPad | **Windows 10 FOD 跨版本相容性研究** | Windows 11 24H2 已移除 WordPad 的一般官方預裝途徑 |

WordPad 曾在測試 VM 以跨版本來源成功安裝並啟動、通過相應 Sysprep，但這**不表示 Microsoft 支援該方法，也不保證 Windows Update 後長期維持正常**。

---

# 🎵 Audio / Dolby Digital AC-3 Research

Microsoft 已確認 Windows 11 24H2 開始**不再預設包含 AC-3（Dolby Digital）解碼器**，但部分 OEM 會另外提供。來源：[Microsoft — Windows Media Player 常見錯誤與 AC-3 說明](https://support.microsoft.com/en-us/windows/apps/windowsmediaplayer/troubleshoot-windows-media-player-errors)。

本專案進行過兩條 AC-3 實驗：

| 方案 | 結果 |
|---|---|
| Dolby Digital Plus Decoder OEM `1.2.591.0` AppxBundle | 使用者安裝成功；未 Provision，Sysprep 因 `0x80073CF2` **FAIL** |
| 第三方 AnWave RollbackDolby | 安裝後的測試參考環境 **Sysprep PASS**，作為後續映像研究基礎 |

**尚未能確認三個版本在新安裝的 Windows Media Player／Media Foundation 路徑實際播放 AC-3、E-AC-3 都已 PASS。** 此功能仍需合法音軌實測、更新回歸及再散布權利確認。

> [!WARNING]
> AnWave 並非 Microsoft／Dolby 官方授權的 Windows AC-3 部署套件。任何 Dolby 或 Microsoft 解碼元件都受其原始授權限制；**技術能安裝、通過 Sysprep 或使用密碼壓縮，不等同獲准公開再散布**。

---

# 📀 Build Origin / 映像製作來源

### Reference Image Workflow

```text
Windows 11 IoT Enterprise LTSC 2024 / 24H2 / zh-TW / x64
        │
        ▼
Microsoft quality updates (record installed KBs and Build)
        │
        ▼
17 Inbox Apps + Required Frameworks
        │
        ▼
NetFx3 + Fax and Scan + XPS Viewer
        │
        ▼
WordPad / AC-3 compatibility research (separate licensing review)
        │
        ▼
VMware Snapshot / Functional Verification
        │
        ├────────── 24H2 base
        ├────────── 25H2 with offline KB5054156.msu
        └────────── 26H2 with offline KB5121794.msu
                       │
                       ▼
               Sysprep / Generalize
                       │
                       ▼
                     WinPE
                       │
                       ▼
               WIM Capture / Verify
                       │
                       ▼
                 Build Test ISO
                       │
                       ▼
        Fresh VM Install / OOBE / App & Codec Regression
```

### Sysprep

測試參考 VM 建立快照後，以系統管理員身分執行：

```powershell
& "$env:WINDIR\System32\Sysprep\Sysprep.exe" /generalize /oobe /shutdown
```

**成功關機後，從 WinPE 開機擷取映像，避免再次啟動已 Generalize 的參考 Windows 進入 OOBE。**

### WIM Capture (example)

在 WinPE 透過 `diskpart`、磁碟標籤與 `dir` 確認：

- `W:` 為目標 Windows 系統分割區。
- `E:` 為獨立、可寫入且有足夠空間的映像儲存磁碟。
- `W:\Windows` 與 `W:\Windows\System32\Config\SYSTEM` 存在。
- `E:\Windows` 不存在；目的地不是系統分割區。
- `Windows.old` 等殘留已適當排查，勿刪除仍需保留的升級回復資料。

```cmd
md E:\Scratch

dism /Capture-Image /ImageFile:E:\win11_custom_test.wim /CaptureDir:W:\ /Name:"Windows 11 IoT Enterprise LTSC Custom" /Description:"Windows 11 x64 zh-TW custom reference image" /Compress:max /CheckIntegrity /Verify /ScratchDir:E:\Scratch

dism /Get-ImageInfo /ImageFile:E:\win11_custom_test.wim /Index:1
```

> 上述是**示範指令**，必須依實際版本更改 Name／Description／檔名，並先確認磁碟代號。不要直接在正常運作的 Windows 系統分割區進行此離線 Capture。系統版本比工具更新時，優先使用相符或較新版的 Windows ADK／WinPE。

---

# 🐞 Troubleshooting / 重要問題與修正

## Windows Setup 100% 後失敗 — `0x800700B7`

24H2 初期 WIM 含有根目錄 `\Windows.old\`，安裝記錄顯示：

```text
CRelocateOS ... Windows.old
Operation failed: Relocate OS
Error: 0x800700B7
Failed execution phase: Finalize
```

R3 實驗處理方式：

1. **保留原版 install.wim**，以副本進行 WIM 編輯。
2. 移除副本 WIM 根目錄 `Windows.old` 殘留。
3. 設定映像 `Name` 和 `Description`。
4. 用 `wimlib verify`、DISM `/Get-ImageInfo` 驗證。
5. 製成新 ISO，在全新 VMware 虛擬硬碟安裝。

**R3 最終已成功完成全新安裝／OOBE。** 這證明組合修正有效；25H2／26H2 則另依作者最新回報已通過安裝測試，但尚不能因此認定全部 Apps、音訊與 Windows Update 回歸均已通過。

## WinPE 重新分配磁碟代號

正常 Windows 的 `C:`、`E:` 進入 WinPE 後可能不是相同字母；應用 `diskpart` 的 `list volume`、`detail volume` 和分割區內容確認來源與目的地。

## Dolby OEM AppX Sysprep FAIL

`Add-AppxPackage` 僅為目前使用者安裝，不等於 `Add-AppxProvisionedPackage` 已對所有新使用者完成授權與佈建。遇到 `0x80073CF2` 必須檢查 `C:\Windows\System32\Sysprep\Panther\setuperr.log`，不能靠降版或無授權的 `-SkipLicense` 繞過部署要求。

---

# 🔍 Verification / 驗證與追蹤

### OS Version / Edition

```powershell
Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' |
  Select-Object ProductName, EditionID, DisplayVersion, CurrentBuild, UBR
```

```cmd
dism /online /Get-CurrentEdition
winver
```

### Inbox Apps Provisioning

```powershell
Get-AppxProvisionedPackage -Online |
  Select-Object DisplayName, PackageName |
  Sort-Object DisplayName
```

### Windows FOD

```powershell
Get-WindowsOptionalFeature -Online -FeatureName NetFx3

Get-WindowsCapability -Online |
  Where-Object Name -match 'Print.Fax.Scan|XPS.Viewer'
```

### Installed Updates

```powershell
Get-HotFix | Sort-Object InstalledOn -Descending |
  Select-Object -First 30 HotFixID, InstalledOn, Description
```

> 有些 Enablement Package 可能不完整出現在 `Get-HotFix`；需要搭配 DISM 套件記錄、Windows 更新記錄與 Build 共同判斷，不能只依賴一條指令。

### WIM Metadata

```cmd
dism /Get-ImageInfo /ImageFile:install.wim /Index:1
```

應逐版確認 `Edition = IoTEnterpriseS`、`Architecture = x64`、`Languages = zh-TW`、Name／Description 和預期 Build。

### Activation

```cmd
slmgr /xpr
```

`Edition ≠ Activation`。本專案**不提供啟用工具、產品金鑰或授權繞過方法**。

### Regression Checklist

- [x] ISO 安裝測試（24H2 有安裝／OOBE 畫面；25H2／26H2 由作者回報安裝成功，個別記錄待彙整）
- [ ] 17 項預裝 Apps 及所需 Framework 運作正常
- [ ] NetFx3／Fax and Scan／XPS Viewer 正常
- [ ] WordPad（如適用）可開啟、編輯、儲存
- [ ] AC-3／E-AC-3 在依賴原生 Media Foundation 的程式中實際播放成功
- [ ] Windows Update 後重新檢查 Apps、WordPad 和 AC-3
- [ ] WIM／ISO／加密分卷 SHA-256 完整性核對
- [ ] 確認授權與再散布權利

---

# 📌 Release History / 現有成果

| 版本 | 現有證據 | 仍需完成 |
|---|---|---|
| **24H2 R3** | Sysprep、WIM 修正、完整性驗證、全新 ISO 安裝與 OOBE **PASS** | 影音實際播放、完整 App／Update 回歸、授權 |
| **25H2 Experimental** | `26200.9457` 版本畫面、離線 `KB5054156` 製作與 WIM 紀錄；**作者回報安裝測試 PASS** | 逐項 Apps／AC-3／Windows Update 回歸及詳細測試記錄 |
| **26H2 Experimental** | `26300.9457` 版本畫面、`KB5121794` 製作研究；**作者回報安裝測試 PASS** | 累積更新先決條件、逐項 Apps／AC-3／Windows Update 回歸及詳細測試記錄 |

本表的安裝 PASS 以已呈現的 24H2 R3 安裝證據與專案作者對三個版本的最新實測回報為基礎；不把尚未取得逐項紀錄的影音、更新等功能回歸自動判定為 PASS。

---

# 🔐 Security / Integrity

針對目前已發布的 Release 分卷，使用者若具有適用授權，建議執行以下完整性驗證流程：

1. 下載同一 Release 的**全部分卷**，及其 `SHA256_7Z_Parts_版本.txt` 和 `SHA256_版本.txt`。
2. 逐卷核對 SHA-256，避免下載不完整或內容遭修改。
3. 將 `.7z.001`、`.002`……放在**同一資料夾**。
4. 使用 7-Zip 從 `.001` 開始解壓。
5. 輸入密碼 `1742`。
6. 對解出的 ISO 再計算 SHA-256，與 Release 內的 ISO 雜湊比對。
7. 在隔離 VM 驗證後，才依合法授權進行部署。

```powershell
Get-FileHash ".\example.7z.001" -Algorithm SHA256
Get-FileHash ".\example.iso" -Algorithm SHA256
```

**Archive password / 壓縮密碼：`1742`**。SHA-256 應以各版本實際產生的值為準；此 README 不捏造任何 ISO 雜湊。

---

# ⚖️ Licensing / Distribution Notice

Windows、Windows IoT Enterprise、Microsoft Store、Windows Inbox Apps、Microsoft 的更新套件、Dolby 音訊技術以及其他第三方元件，都受到各自的適用授權與商標條款保護。

- 本 Repository 的存在與自訂映像成功部署，**不代表獲得 Windows 或 Dolby 安裝檔的公開再散布權利**。
- 若將來為本專案原創腳本／說明文件設定開源授權，**其授權也不延伸到 Microsoft／Dolby 二進位檔、OEM 授權檔或安裝 ISO**。
- 不包含啟用破解、未授權授權檔、產品金鑰或 DRM／授權規避機制。
- 研究環境應保留合法授權來源、檔案雜湊、測試報告及必要的第三方許可。
- **目前 Windows ISO 分卷已公開；若尚未取得相應的 Windows／第三方元件再散布權利，應立即移除公開附件並先完成授權核對。**

This project is **not affiliated with, sponsored by, or endorsed by Microsoft Corporation or Dolby Laboratories**.

---

# 🔗 References / 相關資料

- [Windows 11 IoT Enterprise LTSC 2024 — Microsoft Learn](https://learn.microsoft.com/zh-tw/windows/iot/iot-enterprise/whats-new/windows-11-iot-enterprise-ltsc-2024)
- [Windows IoT Enterprise Release History — Microsoft Learn](https://learn.microsoft.com/zh-tw/windows/iot/iot-enterprise/whats-new/release-history)
- [KB5054156 — 25H2 Enablement Package](https://support.microsoft.com/en-au/servicing/os/windows/docs/2025/02/kb5054156-feature-update-to-windows-11-version-25h2-by-using-an-enablement-package)
- [KB5121794 — 26H2 Enablement Package](https://support.microsoft.com/zh-tw/servicing/os/windows-11/2026/09/kb5121794-feature-update-to-windows-11-version-26h2)
- [Microsoft — AC-3 on Windows 11 24H2](https://support.microsoft.com/en-us/windows/apps/windowsmediaplayer/troubleshoot-windows-media-player-errors)
- [Previous project — Windows 10 IoT Enterprise LTSC 2021 Custom](https://github.com/hom-line/Windows-10-IoT-Enterprise-LTSC-2021-22H2-zh-TW-Custom)

---

# 📌 Project Status

```text
Repository            : Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom
Maintainer            : hom-line
Language              : zh-TW
Architecture          : x64
Edition (test images) : IoTEnterpriseS
Same preinstalled set : 17 Inbox Apps + required frameworks + FOD + WordPad/AC-3 research

24H2 / Build 26100  : R3 new VM installation / OOBE PASS
25H2 / Build 26200  : Installation PASS (maintainer report); detailed regression pending
26H2 / Build 26300  : Installation PASS (maintainer report); prerequisite/regression audit pending

GitHub Release pages : Public; 15 encrypted ISO volumes plus checksum assets uploaded
Archive password      : 1742 (only if legally distributable archives are published)
```
