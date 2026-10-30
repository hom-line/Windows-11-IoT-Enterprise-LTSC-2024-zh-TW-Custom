# Windows 11 IoT Enterprise LTSC 2024 — Custom 24H2 / 25H2 / 26H2 zh-TW

Custom Windows 11 IoT Enterprise LTSC reference images, Traditional Chinese integration, Inbox Apps, WordPad compatibility research, FOD, and Windows deployment documentation.

本專案以 **Windows 11 IoT Enterprise LTSC 2024（24H2）** 為基礎，整合繁體中文、常用 Microsoft Apps、Windows Optional Features 與部署工具，並製作三套獨立的自訂系統映像：**24H2、25H2、26H2**。

依專案開發者實測，三套 ISO 均已完成全新安裝與基本使用測試。各版本的詳細資訊與分卷下載連結如下。

---

# ⬇️ Download / 版本下載

| Release | Edition ID | Version | Main Build | Language | 7-Zip Parts | Status |
|---|---|---|---|---|---|---|
| **[24H2 App R3](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/tag/24H2-App-R3)** | `IoTEnterpriseS` | `24H2` | `26100` | `zh-TW` | **3** | **Recommended Baseline** |
| **[25H2 App](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/tag/25H2-App-Experimental)** | `IoTEnterpriseS` | `25H2` | `26200` | `zh-TW` | **6** | Experimental |
| **[26H2 App](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/tag/26H2-App-Experimental)** | `IoTEnterpriseS` | `26H2` | `26300` | `zh-TW` | **6** | Experimental |

**三個版本使用共同的 17 項 Inbox Apps 與 FOD 整合配置。** 25H2／26H2 是以 LTSC 2024 為參考基底的自訂實驗版，並非 Microsoft 官方發布的新版 LTSC 2024。

---
# 🆕 24H2 App R3 — IoTEnterpriseS zh-TW

> **Recommended / 官方 LTSC 2024 基底**

[➡️ View / Download 24H2 Release](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/tag/24H2-App-R3)

## Version Information

| Item | Value |
|---|---|
| Product / Reference Base | Windows 11 IoT Enterprise LTSC 2024 |
| Edition ID | `IoTEnterpriseS` |
| Version | `24H2` |
| OS Main Build | `26100` |
| Recorded Test Build | `26100.1742`（先前記錄，不代表目前最高更新版本） |
| Architecture | `x64` |
| Language | `zh-TW` |
| Inbox Apps | 17 項共同配置 |
| WordPad | 傳統 WordPad 相容性整合研究（非 Windows 11 官方功能） |
| FOD / Optional Features | .NET Framework 3.5、Windows Fax and Scan、XPS Viewer |
| Enablement Package | `無` |
| Installation Test | **PASS — ISO 全新安裝及基本使用（開發者實測）** |
| Release | `24H2-App-R3` |
| Archive | Password-protected multi-volume 7-Zip |
| Archive Parts | **3** |
| Archive Password | **`1742`** |

### What changed / 本版說明

- 以 **Windows 11 IoT Enterprise LTSC 2024 / 24H2** 為官方 LTSC 參考基底。
- 初期封裝曾遇到 Windows Setup `0x800700B7`；後續在 WIM 副本處理 `Windows.old` 殘留與 Image Description，再重新製作 R3 ISO。
- **R3 已完成全新安裝、OOBE 與進入桌面測試。**

## 📥 24H2 Direct Download / 直接下載

請將以下 **3 個分卷**放在同一個資料夾；下列連結對應 GitHub Release 中實際存在的附件。

1. [⬇️ Part 1 — `.7z.001`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/24H2-App-R3/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_24H2_App.7z.001)
2. [⬇️ Part 2 — `.7z.002`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/24H2-App-R3/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_24H2_App.7z.002)
3. [⬇️ Part 3 — `.7z.003`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/24H2-App-R3/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_24H2_App.7z.003)

### 🔐 SHA-256 / 完整性校驗

- [⬇️ 分卷 SHA-256 — `SHA256_7Z_Parts_24H2.txt`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/24H2-App-R3/SHA256_7Z_Parts_24H2.txt)
- [⬇️ ISO SHA-256 — `SHA256_24H2.txt`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/24H2-App-R3/SHA256_24H2.txt)

### 🔑 Extract Password / 解壓密碼

```text
1742
```

從第一個分卷 `zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_24H2_App.7z.001` 以 7-Zip 開啟，其餘分卷會自動讀取，**不需要逐一解壓縮**。

---

# 📦 25H2 App — IoTEnterpriseS zh-TW

> **Experimental / LTSC-based 實驗映像**

[➡️ View / Download 25H2 Release](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/tag/25H2-App-Experimental)

## Version Information

| Item | Value |
|---|---|
| Product / Reference Base | Windows 11 IoT Enterprise LTSC 2024 |
| Edition ID | `IoTEnterpriseS` |
| Version | `25H2` |
| OS Main Build | `26200` |
| Recorded Test Build | `26200.9457`（先前記錄，不代表目前最高更新版本） |
| Architecture | `x64` |
| Language | `zh-TW` |
| Inbox Apps | 17 項共同配置 |
| WordPad | 傳統 WordPad 相容性整合研究（非 Windows 11 官方功能） |
| FOD / Optional Features | .NET Framework 3.5、Windows Fax and Scan、XPS Viewer |
| Enablement Package | `KB5054156.msu` |
| Installation Test | **PASS — ISO 全新安裝及基本使用（開發者實測）** |
| Release | `25H2-App-Experimental` |
| Archive | Password-protected multi-volume 7-Zip |
| Archive Parts | **6** |
| Archive Password | **`1742`** |

### What changed from 24H2? / 版本差異

- 以獨立更新的 24H2 參考映像為基底，研究套用 `KB5054156.msu` 的 25H2 Enablement Package。
- Windows 主 Build 由 `26100` 變為 `26200`，沿用 `IoTEnterpriseS`、`x64`、`zh-TW` 與共同預裝配置。
- **25H2 ISO 已完成全新安裝與基本使用測試。** 這是實驗性配置，不表示 Microsoft 支援 LTSC 2024 轉成 25H2。

## 📥 25H2 Direct Download / 直接下載

請將以下 **6 個分卷**放在同一個資料夾；下列連結對應 GitHub Release 中實際存在的附件。

1. [⬇️ Part 1 — `.7z.001`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/25H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_25H2_App.7z.001)
2. [⬇️ Part 2 — `.7z.002`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/25H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_25H2_App.7z.002)
3. [⬇️ Part 3 — `.7z.003`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/25H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_25H2_App.7z.003)
4. [⬇️ Part 4 — `.7z.004`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/25H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_25H2_App.7z.004)
5. [⬇️ Part 5 — `.7z.005`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/25H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_25H2_App.7z.005)
6. [⬇️ Part 6 — `.7z.006`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/25H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_25H2_App.7z.006)

### 🔐 SHA-256 / 完整性校驗

- [⬇️ 分卷 SHA-256 — `SHA256_7Z_Parts_25H2.txt`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/25H2-App-Experimental/SHA256_7Z_Parts_25H2.txt)
- [⬇️ ISO SHA-256 — `SHA256_25H2.txt`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/25H2-App-Experimental/SHA256_25H2.txt)

### 🔑 Extract Password / 解壓密碼

```text
1742
```

從第一個分卷 `zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_25H2_App.7z.001` 以 7-Zip 開啟，其餘分卷會自動讀取，**不需要逐一解壓縮**。

---

# 🧪 26H2 App — IoTEnterpriseS zh-TW

> **Experimental / LTSC-based 實驗映像**

[➡️ View / Download 26H2 Release](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/tag/26H2-App-Experimental)

## Version Information

| Item | Value |
|---|---|
| Product / Reference Base | Windows 11 IoT Enterprise LTSC 2024 |
| Edition ID | `IoTEnterpriseS` |
| Version | `26H2` |
| OS Main Build | `26300` |
| Recorded Test Build | `26300.9457`（先前記錄，不代表目前最高更新版本） |
| Architecture | `x64` |
| Language | `zh-TW` |
| Inbox Apps | 17 項共同配置 |
| WordPad | 傳統 WordPad 相容性整合研究（非 Windows 11 官方功能） |
| FOD / Optional Features | .NET Framework 3.5、Windows Fax and Scan、XPS Viewer |
| Enablement Package | `KB5121794.msu` |
| Installation Test | **PASS — ISO 全新安裝及基本使用（開發者實測）** |
| Release | `26H2-App-Experimental` |
| Archive | Password-protected multi-volume 7-Zip |
| Archive Parts | **6** |
| Archive Password | **`1742`** |

### What changed from 24H2? / 版本差異

- 由另一條已更新的 24H2 參考映像分支研究 `KB5121794.msu`，不是 25H2 自訂 ISO 的連續升級。
- Windows 主 Build 由 `26100` 變為 `26300`，沿用 `IoTEnterpriseS`、`x64`、`zh-TW` 與共同預裝配置。
- **26H2 ISO 已完成全新安裝與基本使用測試。** 這是實驗性配置；套件先決條件與 Windows Update 後續相容性仍應另外核對。

## 📥 26H2 Direct Download / 直接下載

請將以下 **6 個分卷**放在同一個資料夾；下列連結對應 GitHub Release 中實際存在的附件。

1. [⬇️ Part 1 — `.7z.001`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/26H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_26H2_App.7z.001)
2. [⬇️ Part 2 — `.7z.002`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/26H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_26H2_App.7z.002)
3. [⬇️ Part 3 — `.7z.003`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/26H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_26H2_App.7z.003)
4. [⬇️ Part 4 — `.7z.004`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/26H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_26H2_App.7z.004)
5. [⬇️ Part 5 — `.7z.005`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/26H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_26H2_App.7z.005)
6. [⬇️ Part 6 — `.7z.006`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/26H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_26H2_App.7z.006)

### 🔐 SHA-256 / 完整性校驗

- [⬇️ 分卷 SHA-256 — `SHA256_7Z_Parts_26H2.txt`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/26H2-App-Experimental/SHA256_7Z_Parts_26H2.txt)
- [⬇️ ISO SHA-256 — `SHA256_26H2.txt`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/26H2-App-Experimental/SHA256_26H2.txt)

### 🔑 Extract Password / 解壓密碼

```text
1742
```

從第一個分卷 `zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_26H2_App.7z.001` 以 7-Zip 開啟，其餘分卷會自動讀取，**不需要逐一解壓縮**。

---

# 📱 Installed Apps / 共同整合的 17 項 Inbox Apps

以下為三版共用的 Microsoft App 佈建清單；版本號與 Framework 依實際映像而異。**清單代表建置配置，並不等於三個版本的每個 App 都完成獨立 GUI 功能回歸。**

| Category | Application / Extension | Package Identity |
|---|---|---|
| Store | Microsoft Store | `Microsoft.WindowsStore` |
| Store | Microsoft Store Purchase App | `Microsoft.StorePurchaseApp` |
| Installer | App Installer | `Microsoft.DesktopAppInstaller` |
| Utility | Calculator / 小算盤 | `Microsoft.WindowsCalculator` |
| Utility | Paint / 小畫家 | `Microsoft.Paint` |
| Utility | Notepad / 記事本 | `Microsoft.WindowsNotepad` |
| Utility | Snipping Tool / 剪取工具 | `Microsoft.ScreenSketch` |
| Multimedia | Camera / 相機 | `Microsoft.WindowsCamera` |
| Multimedia | Photos / 相片 | `Microsoft.Windows.Photos` |
| Multimedia | Media Player / 媒體播放器 | `Microsoft.ZuneMusic` |
| Codec Extension | AV1 Video Extension | `Microsoft.AV1VideoExtension` |
| Codec Extension | AVC Encoder Video Extension | `Microsoft.AVCEncoderVideoExtension` |
| Codec Extension | VP9 Video Extensions | `Microsoft.VP9VideoExtensions` |
| Codec Extension | HEIF Image Extensions | `Microsoft.HEIFImageExtension` |
| Codec Extension | WebP Image Extensions | `Microsoft.WebpImageExtension` |
| Codec Extension | Web Media Extensions | `Microsoft.WebMediaExtensions` |
| Codec Extension | MPEG-2 Video Extension | `Microsoft.MPEG2VideoExtension` |

### Required Frameworks / 相依框架

依各 App 實際需求整合或檢查 `Microsoft.VCLibs`、`Microsoft.UI.Xaml`、`Microsoft.NET.Native` 與 `Microsoft.WindowsAppRuntime` 等相依元件。**不能將所有 Framework 稱為同一固定版本，需由實際 AppX/MSIX 套件與映像清單確認。**

## 🧩 WordPad & FOD / 傳統工具與選用功能

| Component | Integration / 說明 |
|---|---|
| **WordPad / 寫字板** | 歷史建置曾研究使用 Windows 10 FOD／相容性來源整合到 Windows 11。WordPad 已非 Windows 11 官方標準附帶功能；須依各版本實際映像確認檔案、可啟動性及合法來源。 |
| **.NET Framework 3.5** | `NetFx3` — Windows Optional Feature；建置目標包含此功能。 |
| **Windows Fax and Scan** | `Print.Fax.Scan~~~~0.0.1.0` — Windows Capability / FOD。 |
| **XPS Viewer** | `XPS.Viewer~~~~0.0.1.0` — Windows Capability / FOD。 |

**關於影音擴充：** HEVC Video Extensions（H.265）不列入此專案 17 項預裝清單。AC-3／Dolby 相關工作屬影音相容性研究，**不宣稱已預裝或獲得授權**，也不將其計入 17 項。WordPad、FOD 與影音擴充是否能正常操作，應以實際版本的個別功能測試為準。

---

# 🔑 Archive Extraction & Verification / 解壓縮及 SHA-256 驗證

已知各版均使用 **7-Zip 加密分卷**，密碼同為 `1742`。

1. 取得你有權使用的版本之全部分卷，確認與該版本的 GitHub Release Tag 一致。
2. 檢查每個 `.7z.001`、`.7z.002` 等分卷的 SHA-256，對照該版 `SHA256_7Z_Parts_版本.txt`。
3. 將全部分卷放在同一資料夾，從 `.7z.001` 開始解壓；不要逐卷手動解壓。
4. 解壓完成後，對 ISO 計算 SHA-256，與該版 `SHA256_版本.txt` 比對。

```powershell
# 將 filename 換成實際分卷或 ISO 檔名
Get-FileHash -LiteralPath ".\filename.7z.001" -Algorithm SHA256
Get-FileHash -LiteralPath ".\filename.iso" -Algorithm SHA256
```

[⬇️ Download `SHA256_ALL.txt` — 綜合校驗檔](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/24H2-App-R3/SHA256_ALL.txt) · [⬇️ Download `ISO_Metadata.csv`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/24H2-App-R3/ISO_Metadata.csv)

本機 SHA-256 重新檢查已有 PASS 紀錄，但尚未確認從 GitHub 重新下載三版全部分卷、還原 ISO 後再次校驗的完整端到端測試。SHA-256 一致不等於 Microsoft 官方簽章或安全認證。

---

# 🧰 Development & Build / 建置說明

三個版本採用**獨立的 24H2 參考分支**製作：

```text
Windows 11 IoT Enterprise LTSC 2024 (24H2 / 26100)
                 │
       Updated Reference VM
                 │
      ┌──────────┼──────────┐
      ▼          ▼          ▼
    24H2       25H2       26H2
  Setup R3  KB5054156  KB5121794
   Build     Build      Build
   26100     26200      26300
      │          │          │
      └──────────┴──────────┘
                 ▼
        Sysprep → WinPE
                 ▼
          WIM → Custom ISO
                 ▼
       Fresh Installation PASS
```

**注意：** 25H2／26H2 是基於 LTSC 2024 參考映像的非官方實驗分支。Microsoft 官方 **Windows 11 IoT Enterprise LTSC 2024** 是 24H2／Build 26100；不能將上述研究成果稱為「Microsoft 官方 LTSC 25H2／26H2」。功能啟用套件的適用條件及更新支援應另依 Microsoft 官方文件確認。

### Windows Setup R3 修正紀錄

24H2 初版曾在 Setup Finalize 階段遇到 `0x800700B7`。後續對 WIM 副本處理 `Windows.old` 殘留並更新 Image Description、重新封裝，R3 已成功完成安裝。這些修改同時發生，不應推論唯一失敗原因。

[完整建置紀錄](docs/BUILD_zh-TW.md) · [三版驗收紀錄](docs/VALIDATION_zh-TW.md)

---

# ✅ Validation Status / 測試與驗收

| Test | 24H2 | 25H2 | 26H2 |
|---|---|---|---|
| ISO fresh installation / 全新重灌 | **PASS** | **PASS** | **PASS** |
| Basic desktop use / 基本使用 | **PASS（開發者回報）** | **PASS（開發者回報）** | **PASS（開發者回報）** |
| Local ISO SHA-256 verification | **PASS** | **PASS** | **PASS** |
| Individual 17 Apps launch & functions | 尚無完整逐項紀錄 | 尚無完整逐項紀錄 | 尚無完整逐項紀錄 |
| WordPad / FOD full functional regression | 待逐項證據 | 待逐項證據 | 待逐項證據 |
| New scripts & framework dependency verification | 待腳本實機驗收 | 待腳本實機驗收 | 待腳本實機驗收 |
| Windows Update / Sysprep complete post-update regression | 待獨立彙整 | 待獨立彙整 | 待獨立彙整 |

**已完成的 ISO 全新重灌測試不需因新增腳本而重做。** 測試結果僅代表此處列出的範圍；更新後、不同裝置及長期運作穩定性仍可能不同。

---

# 🛠️ PowerShell Tools / 驗證與佈建工具

| Script | Purpose |
|---|---|
| [`scripts/Provision-InboxApps.ps1`](scripts/Provision-InboxApps.ps1) | 合法來源 AppX／MSIX 套件、Manifest、SHA-256 與授權檔預檢，明確指定才執行佈建 |
| [`scripts/Verify-InboxApps.ps1`](scripts/Verify-InboxApps.ps1) | 查核 17 項 Apps、必要 Framework 與 Windows FOD／Optional Features |
| [`scripts/Verify-Windows-Edition.ps1`](scripts/Verify-Windows-Edition.ps1) | 核對 `24H2／25H2／26H2`、Build、`IoTEnterpriseS`、x64、zh-TW |

[腳本使用說明與 Manifest 範例](docs/SCRIPTS_zh-TW.md)

---

# ⚖️ Licensing / 技術分享與授權聲明

本 Repository 為非官方之技術研究、教學與測試文件，不代表 Microsoft、Dolby 或其他品牌的認證、贊助或背書。

- [`LICENSE`](LICENSE) 僅適用作者**有權授權的原創程式與文件**，不涵蓋 Windows ISO／WIM／ESD、Microsoft AppX／MSIX、FOD、產品金鑰、授權 XML、Dolby／AC-3 或其他第三方元件。
- 使用者應自行確認安裝、啟用、修改、使用及公開再散布所需權利，並做好資料備份與測試。
- **技術分享、加密壓縮、免費提供或附 SHA-256，都不能代替 Microsoft 或第三方再散布授權。** 現有 GitHub Release 包含加密 Windows 安裝映像分卷；若沒有取得適用的公開再散布權利，應暫停提供並移除相關二進位附件。
- 原創程式與文件以「AS IS」提供，免責範圍以適用法律許可為限；法律上不得排除的責任仍依法處理。

[詳細授權及免責聲明](docs/LEGAL_NOTICE_zh-TW.md)

---

# 📚 References / 參考資料

- [Windows 11 IoT Enterprise LTSC 2024 — Microsoft Learn](https://learn.microsoft.com/windows/iot/iot-enterprise/whats-new/windows-11-iot-enterprise-ltsc-2024)
- [Windows IoT Enterprise Release History](https://learn.microsoft.com/windows/iot/iot-enterprise/whats-new/release-history)
- [Windows 10 IoT Enterprise LTSC 2021 Custom — Related Project](https://github.com/hom-line/Windows-10-IoT-Enterprise-LTSC-2021-22H2-zh-TW-Custom)

**Maintainer:** [hom-line](https://github.com/hom-line) · **Language:** `zh-TW` · **Architecture:** `x64`
