# Windows 11 IoT Enterprise LTSC 2024 — Custom 24H2 / 25H2 / 26H2 (zh-TW)

**Windows 11 IoT Enterprise LTSC 2024 reference-image & deployment research** · 繁體中文 · x64 · Microsoft Inbox Apps · Sysprep · WinPE · DISM · WIM / ISO

本專案記錄以 **Windows 11 IoT Enterprise LTSC 2024（24H2）** 為參考基底，製作繁體中文自訂系統映像的流程、共同預裝 App、功能套件、版本實驗、安裝測試與完整性校驗。另以各自獨立的 24H2 參考映像為起點，研究 **25H2／26H2** 的非官方 LTSC-based 實驗版本。

**已完成的事實：** 依專案開發者於 2026-10-31 的補充確認，24H2、25H2、26H2 **各自使用 ISO 實際全新重灌成功，基本使用結果與 24H2 基準一致**。三個版本的 SHA-256 本機重新校驗亦有 PASS 紀錄。此狀態**不等於**已完成逐項 App 啟動、Framework、Windows Update、AC-3 或新版 PowerShell 腳本的全部回歸。

> [!IMPORTANT]
> **版本定位：** Microsoft 官方 **Windows 11 IoT Enterprise LTSC 2024** 是 **24H2／Build 26100**。本專案 25H2／26H2 是基於 LTSC 2024 的自訂實驗配置，**並非 Microsoft 官方的「LTSC 2024 25H2／26H2」發行版**。一般 Windows 11 IoT Enterprise 的 25H2／26H2 正式版本與 LTSC 授權／維護週期不同。

> [!WARNING]
> **授權先行：** 本儲存庫的原創腳本及文件不包含 Windows、Microsoft AppX/MSIX、Dolby 或其他第三方元件的再散布授權。Release 內目前存在加密 Windows ISO 分卷，但**可存取、加密、附 SHA-256 或註明技術分享都不構成再散布許可**。若無各權利人的適用授權，應暫停公開提供相關二進位附件。請參閱 [法律與授權範圍](docs/LEGAL_NOTICE_zh-TW.md)。

---

## 📑 Quick Navigation / 快速導覽

- [Download / 版本總覽](#-download--release-overview)
- [24H2 App R3 — Recommended Baseline](#-24h2-app-r3--iotenterprises-zh-tw)
- [25H2 App — Experimental](#-25h2-app--iotenterprises-zh-tw)
- [26H2 App — Experimental](#-26h2-app--iotenterprises-zh-tw)
- [17 項 Inbox Apps 與共同整合](#-inbox-apps--optional-features-%E5%85%B1%E5%90%8C%E9%A0%90%E8%A3%9D%E9%85%8D%E7%BD%AE)
- [測試與驗收狀態](#-validation--test-status-%E9%A9%97%E6%94%B6%E7%B4%80%E9%8C%84)
- [PowerShell 工具](#-powershell-scripts--%E9%A9%97%E8%AD%89%E8%88%87%E4%BD%88%E5%BB%BA%E5%B7%A5%E5%85%B7)
- [Build / 安裝流程與疑難排解](#-build--deployment-notes-%E5%BB%BA%E7%BD%AE%E8%88%87%E5%AE%89%E8%A3%9D%E7%AD%86%E8%A8%98)
- [Licensing / 授權聲明](#%EF%B8%8F-licensing--redistribution-%E6%8E%88%E6%AC%8A%E8%88%87%E5%86%8D%E6%95%A3%E5%B8%83%E9%99%90%E5%88%B6)

# ⬇️ Download / Release Overview

下列均為 **GitHub 現有 Release Tag**（不是新命名的 `v0.x.x` 版號），連結與分卷數已依 Release 附件核對：

| Release | Edition ID | Version | Main Build | Language | Archive | Role | ISO fresh install |
|---|---|---|---|---|---|---|---|
| **[24H2 App R3](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/tag/24H2-App-R3)** | `IoTEnterpriseS` | `24H2` | `26100` | `zh-TW` | **3 parts** | **Current / Recommended Baseline** | **PASS (developer test)** |
| [25H2 App](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/tag/25H2-App-Experimental) | `IoTEnterpriseS` | `25H2` | `26200` | `zh-TW` | **6 parts** | Experimental | **PASS (developer test)** |
| [26H2 App](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/tag/26H2-App-Experimental) | `IoTEnterpriseS` | `26H2` | `26300` | `zh-TW` | **6 parts** | Experimental | **PASS (developer test)** |

- **24H2 建議作為可重複比對的基準**：它對應 Microsoft 官方 LTSC 2024 的功能版本。
- **25H2／26H2 供研究與比較**：能成功安裝不表示 Microsoft 對 LTSC 版的轉換、更新路線及支援週期提供認可。
- 三版宣告採用共同 17 項 Apps、Framework／FOD 整合規劃；**共同配置不等同於已逐項驗證每項程式功能。**

---
# 🆕 24H2 App R3 — IoTEnterpriseS zh-TW

> **Current / Recommended Baseline**

[➡️ View Release / 查看 24H2 發布頁](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/tag/24H2-App-R3)

## Version Information / 版本資訊

| Item | Value |
|---|---|
| Product / 系統基底 | Windows 11 IoT Enterprise LTSC 2024（官方 24H2 基底） |
| Edition ID | `IoTEnterpriseS`（依專案映像測試紀錄） |
| Version | `24H2` |
| OS Build family / 主 Build | `26100` |
| Recorded test build / 歷史測試 Build | `26100.1742（R3 歷史測試紀錄）`，非最新版保證 |
| Architecture | `x64` |
| Language | `zh-TW` |
| Inbox Apps | 17 項共同配置（逐項實際功能回歸需另驗證） |
| Optional features | .NET Framework 3.5、Fax and Scan、XPS Viewer（規劃整合） |
| Enablement package | 無額外功能啟用套件 |
| Release tag | `24H2-App-R3` |
| Installation acceptance | **PASS — 開發者已以該版本 ISO 全新重灌** |
| Archive | Password-protected multi-volume 7-Zip |
| Archive volumes | **3** |
| Archive password | **`1742`** |

> **Build 說明：** `26100` 為版本主 Build；歷史測試時曾出現的修訂號不能當作目前 ISO 的最新 UBR。請以完成安裝後的 `winver`、`Get-ComputerInfo` 和實際 WIM Metadata 為準。

## What changed / 此版的差異

本專案的基準 Release，先前修正 Windows Setup Finalize 階段問題後重新封裝成 R3。

1. 以 Windows 11 IoT Enterprise LTSC 2024／24H2 為參考基底，整合繁體中文與共同預裝配置。
2. 早期映像的 Windows Setup Finalize 階段曾遭遇 0x800700B7；經檢查處理 WIM 內 Windows.old 殘留、映像 Description 及封裝流程後，R3 的全新安裝、OOBE、進入桌面測試成功。
3. 此版本是 25H2、26H2 實驗分支的共同參考基準。

### Build relationship / 版本關係

```text
Windows 11 IoT Enterprise LTSC 2024
              │
              ▼
24H2 reference image (Build 26100)
              │
      Setup R3 corrections
              │
              ▼
24H2-App-R3  [installation PASS]
```

## 📥 24H2 Direct Download / 分卷附件索引

**GitHub 目前列出的附件：共 3 個分卷。** 下列為倉庫目前公開附件的客觀索引；**公開可取得不等於 Microsoft 或第三方授權散布**，請先閱讀本 README 後面的 [授權與再散布限制](#%EF%B8%8F-licensing--redistribution-%E6%8E%88%E6%AC%8A%E8%88%87%E5%86%8D%E6%95%A3%E5%B8%83%E9%99%90%E5%88%B6)。

1. [⬇️ Part 1 — `.7z.001`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/24H2-App-R3/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_24H2_App.7z.001)
2. [⬇️ Part 2 — `.7z.002`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/24H2-App-R3/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_24H2_App.7z.002)
3. [⬇️ Part 3 — `.7z.003`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/24H2-App-R3/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_24H2_App.7z.003)

### 🔐 SHA-256 / 校驗資料

- [⬇️ Download `SHA256_24H2.txt` — ISO SHA-256](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/24H2-App-R3/SHA256_24H2.txt)
- [⬇️ Download `SHA256_7Z_Parts_24H2.txt` — 分卷 SHA-256](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/24H2-App-R3/SHA256_7Z_Parts_24H2.txt)

- [⬇️ `SHA256_ALL.txt` — 三版綜合清單](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/24H2-App-R3/SHA256_ALL.txt)
- [⬇️ `ISO_Metadata.csv` — ISO 中繼資料](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/24H2-App-R3/ISO_Metadata.csv)

### 🔑 Archive Password / 解壓密碼

```text
1742
```

若已確認具有適用的取得／使用權利，請將同一版的全部分卷放在同一資料夾，使用 7-Zip 從下列第一卷開啟：

```text
zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_24H2_App.7z.001
```

其餘 `.7z.002` 至 `.7z.003` 由 7-Zip 自動讀取；**不須逐一解壓縮**。

### SHA-256 Verification / 雜湊比對

```powershell
Get-FileHash -LiteralPath ".\zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_24H2_App.7z.001" -Algorithm SHA256
# 同樣對本版本其餘分卷逐一執行，與 SHA256_7Z_Parts_24H2.txt 比對。
# 若在已授權的環境中取得原始 ISO，亦需與 SHA256_24H2.txt 比對。
```

> 本機 7-Zip 測試與 ISO SHA-256 重新驗證已有開發紀錄；**尚未證實自 GitHub 重新下載全部分卷，經完整還原並重新驗證 ISO**。各附件 SHA-256 以實際清單為準，不從檔名推測。

---

# 📦 25H2 App — IoTEnterpriseS zh-TW

> **Experimental / LTSC-based custom build**

[➡️ View Release / 查看 25H2 發布頁](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/tag/25H2-App-Experimental)

## Version Information / 版本資訊

| Item | Value |
|---|---|
| Product / 系統基底 | Windows 11 IoT Enterprise LTSC 2024 基底（非官方 25H2 LTSC） |
| Edition ID | `IoTEnterpriseS`（依專案映像測試紀錄） |
| Version | `25H2` |
| OS Build family / 主 Build | `26200` |
| Recorded test build / 歷史測試 Build | `26200.9457（歷史觀察值）`，非最新版保證 |
| Architecture | `x64` |
| Language | `zh-TW` |
| Inbox Apps | 17 項共同配置（逐項實際功能回歸需另驗證） |
| Optional features | .NET Framework 3.5、Fax and Scan、XPS Viewer（規劃整合） |
| Enablement package | KB5054156（功能啟用套件） |
| Release tag | `25H2-App-Experimental` |
| Installation acceptance | **PASS — 開發者已以該版本 ISO 全新重灌** |
| Archive | Password-protected multi-volume 7-Zip |
| Archive volumes | **6** |
| Archive password | **`1742`** |

> **Build 說明：** `26200` 為版本主 Build；歷史測試時曾出現的修訂號不能當作目前 ISO 的最新 UBR。請以完成安裝後的 `winver`、`Get-ComputerInfo` 和實際 WIM Metadata 為準。

## What changed / 此版的差異

以獨立的 24H2 參考映像為起點，於自訂測試環境嘗試套用 25H2 啟用套件的實驗映像。

1. 沿用 24H2 的 Edition 研究目標（IoTEnterpriseS）、x64、zh-TW 與共同 17 項 Inbox Apps 規劃。
2. 在已更新的 24H2 參考映像上套用 KB5054156，曾觀察到 25H2／Build 26200 的版本資訊；並非 Microsoft 官方 LTSC 2024 的功能更新管道。
3. 開發者已確認使用 25H2 ISO 全新重灌成功，基本使用結果與 24H2 一致；尚不能據此推論全部 App、Framework、Windows Update 等回歸均通過。

> **更新先決條件：** Microsoft 對一般 Windows 11 25H2 啟用套件要求先安裝 KB5064081／26100.5074 或更新累積更新；此要求不構成對 LTSC 2024 使用此路徑的官方支援保證。

### Build relationship / 版本關係

```text
24H2 updated reference image (Build 26100)
              │
              ▼
KB5054156（功能啟用套件）
              │
              ▼
25H2 experimental image (Build 26200)
              │
       Clean ISO install PASS
              │
              ▼
25H2-App-Experimental
```

## 📥 25H2 Direct Download / 分卷附件索引

**GitHub 目前列出的附件：共 6 個分卷。** 下列為倉庫目前公開附件的客觀索引；**公開可取得不等於 Microsoft 或第三方授權散布**，請先閱讀本 README 後面的 [授權與再散布限制](#%EF%B8%8F-licensing--redistribution-%E6%8E%88%E6%AC%8A%E8%88%87%E5%86%8D%E6%95%A3%E5%B8%83%E9%99%90%E5%88%B6)。

1. [⬇️ Part 1 — `.7z.001`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/25H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_25H2_App.7z.001)
2. [⬇️ Part 2 — `.7z.002`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/25H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_25H2_App.7z.002)
3. [⬇️ Part 3 — `.7z.003`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/25H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_25H2_App.7z.003)
4. [⬇️ Part 4 — `.7z.004`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/25H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_25H2_App.7z.004)
5. [⬇️ Part 5 — `.7z.005`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/25H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_25H2_App.7z.005)
6. [⬇️ Part 6 — `.7z.006`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/25H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_25H2_App.7z.006)

### 🔐 SHA-256 / 校驗資料

- [⬇️ Download `SHA256_25H2.txt` — ISO SHA-256](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/25H2-App-Experimental/SHA256_25H2.txt)
- [⬇️ Download `SHA256_7Z_Parts_25H2.txt` — 分卷 SHA-256](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/25H2-App-Experimental/SHA256_7Z_Parts_25H2.txt)


### 🔑 Archive Password / 解壓密碼

```text
1742
```

若已確認具有適用的取得／使用權利，請將同一版的全部分卷放在同一資料夾，使用 7-Zip 從下列第一卷開啟：

```text
zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_25H2_App.7z.001
```

其餘 `.7z.002` 至 `.7z.006` 由 7-Zip 自動讀取；**不須逐一解壓縮**。

### SHA-256 Verification / 雜湊比對

```powershell
Get-FileHash -LiteralPath ".\zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_25H2_App.7z.001" -Algorithm SHA256
# 同樣對本版本其餘分卷逐一執行，與 SHA256_7Z_Parts_25H2.txt 比對。
# 若在已授權的環境中取得原始 ISO，亦需與 SHA256_25H2.txt 比對。
```

> 本機 7-Zip 測試與 ISO SHA-256 重新驗證已有開發紀錄；**尚未證實自 GitHub 重新下載全部分卷，經完整還原並重新驗證 ISO**。各附件 SHA-256 以實際清單為準，不從檔名推測。

---

# 🧪 26H2 App — IoTEnterpriseS zh-TW

> **Experimental / LTSC-based custom build**

[➡️ View Release / 查看 26H2 發布頁](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/tag/26H2-App-Experimental)

## Version Information / 版本資訊

| Item | Value |
|---|---|
| Product / 系統基底 | Windows 11 IoT Enterprise LTSC 2024 基底（非官方 26H2 LTSC） |
| Edition ID | `IoTEnterpriseS`（依專案映像測試紀錄） |
| Version | `26H2` |
| OS Build family / 主 Build | `26300` |
| Recorded test build / 歷史測試 Build | `26300.9457（歷史觀察值）`，非最新版保證 |
| Architecture | `x64` |
| Language | `zh-TW` |
| Inbox Apps | 17 項共同配置（逐項實際功能回歸需另驗證） |
| Optional features | .NET Framework 3.5、Fax and Scan、XPS Viewer（規劃整合） |
| Enablement package | KB5121794（功能啟用套件） |
| Release tag | `26H2-App-Experimental` |
| Installation acceptance | **PASS — 開發者已以該版本 ISO 全新重灌** |
| Archive | Password-protected multi-volume 7-Zip |
| Archive volumes | **6** |
| Archive password | **`1742`** |

> **Build 說明：** `26300` 為版本主 Build；歷史測試時曾出現的修訂號不能當作目前 ISO 的最新 UBR。請以完成安裝後的 `winver`、`Get-ComputerInfo` 和實際 WIM Metadata 為準。

## What changed / 此版的差異

由另一條 24H2 參考映像分支建立，研究 26H2／Build 26300 的相容性；不是以 25H2 自訂 ISO 連續升級製作。

1. 保留共同的 IoTEnterpriseS 目標、繁體中文、x64 與 17 項 Inbox Apps 配置。
2. 由獨立 24H2 參考映像研究 KB5121794，曾觀察到 26H2／Build 26300；不表示 LTSC 2024 已官方升級成 26H2。
3. 開發者已確認使用 26H2 ISO 全新重灌成功、基本使用結果與 24H2 一致；目前仍需補足功能、套件及更新先決條件核對。

> **更新先決條件：** Microsoft 對一般 Windows 11 26H2 啟用套件要求 KB5124010／26100.9546 或更新累積更新。專案過去記錄的 26300.9457 低於這個先決條件所列修訂號，應重新查核實際安裝時的套件及修訂歷程，不能以該歷史數字證明符合 Microsoft 目前的要求。

### Build relationship / 版本關係

```text
24H2 updated reference image (Build 26100)
              │
              ▼
KB5121794（功能啟用套件）
              │
              ▼
26H2 experimental image (Build 26300)
              │
       Clean ISO install PASS
              │
              ▼
26H2-App-Experimental
```

## 📥 26H2 Direct Download / 分卷附件索引

**GitHub 目前列出的附件：共 6 個分卷。** 下列為倉庫目前公開附件的客觀索引；**公開可取得不等於 Microsoft 或第三方授權散布**，請先閱讀本 README 後面的 [授權與再散布限制](#%EF%B8%8F-licensing--redistribution-%E6%8E%88%E6%AC%8A%E8%88%87%E5%86%8D%E6%95%A3%E5%B8%83%E9%99%90%E5%88%B6)。

1. [⬇️ Part 1 — `.7z.001`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/26H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_26H2_App.7z.001)
2. [⬇️ Part 2 — `.7z.002`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/26H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_26H2_App.7z.002)
3. [⬇️ Part 3 — `.7z.003`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/26H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_26H2_App.7z.003)
4. [⬇️ Part 4 — `.7z.004`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/26H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_26H2_App.7z.004)
5. [⬇️ Part 5 — `.7z.005`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/26H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_26H2_App.7z.005)
6. [⬇️ Part 6 — `.7z.006`](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/26H2-App-Experimental/zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_26H2_App.7z.006)

### 🔐 SHA-256 / 校驗資料

- [⬇️ Download `SHA256_26H2.txt` — ISO SHA-256](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/26H2-App-Experimental/SHA256_26H2.txt)
- [⬇️ Download `SHA256_7Z_Parts_26H2.txt` — 分卷 SHA-256](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/26H2-App-Experimental/SHA256_7Z_Parts_26H2.txt)


### 🔑 Archive Password / 解壓密碼

```text
1742
```

若已確認具有適用的取得／使用權利，請將同一版的全部分卷放在同一資料夾，使用 7-Zip 從下列第一卷開啟：

```text
zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_26H2_App.7z.001
```

其餘 `.7z.002` 至 `.7z.006` 由 7-Zip 自動讀取；**不須逐一解壓縮**。

### SHA-256 Verification / 雜湊比對

```powershell
Get-FileHash -LiteralPath ".\zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_26H2_App.7z.001" -Algorithm SHA256
# 同樣對本版本其餘分卷逐一執行，與 SHA256_7Z_Parts_26H2.txt 比對。
# 若在已授權的環境中取得原始 ISO，亦需與 SHA256_26H2.txt 比對。
```

> 本機 7-Zip 測試與 ISO SHA-256 重新驗證已有開發紀錄；**尚未證實自 GitHub 重新下載全部分卷，經完整還原並重新驗證 ISO**。各附件 SHA-256 以實際清單為準，不從檔名推測。

---

# 📦 Inbox Apps & Optional Features / 共同預裝配置

三套映像的 **17 項 Microsoft Inbox Apps 目標清單**如下；套件版本、Framework 相依性與新使用者第一次啟動，應依實際部署結果核對。

| # | App / 功能 | Package identity |
|---:|---|---|
| 1 | Microsoft Store Purchase App | `Microsoft.StorePurchaseApp` |
| 2 | Microsoft Store | `Microsoft.WindowsStore` |
| 3 | App Installer / winget 支援 | `Microsoft.DesktopAppInstaller` |
| 4 | Calculator / 小算盤 | `Microsoft.WindowsCalculator` |
| 5 | Paint / 小畫家 | `Microsoft.Paint` |
| 6 | Notepad / 記事本 | `Microsoft.WindowsNotepad` |
| 7 | Snipping Tool / 剪取工具 | `Microsoft.ScreenSketch` |
| 8 | Camera / 相機 | `Microsoft.WindowsCamera` |
| 9 | Photos / 相片 | `Microsoft.Windows.Photos` |
| 10 | Media Player / 媒體播放器 | `Microsoft.ZuneMusic` |
| 11 | AV1 Video Extension | `Microsoft.AV1VideoExtension` |
| 12 | AVC Encoder Video Extension | `Microsoft.AVCEncoderVideoExtension` |
| 13 | VP9 Video Extensions | `Microsoft.VP9VideoExtensions` |
| 14 | HEIF Image Extensions | `Microsoft.HEIFImageExtension` |
| 15 | WebP Image Extensions | `Microsoft.WebpImageExtension` |
| 16 | Web Media Extensions | `Microsoft.WebMediaExtensions` |
| 17 | MPEG-2 Video Extension | `Microsoft.MPEG2VideoExtension` |

### Framework 與 Windows Optional Features

- **Framework**：依實際 Microsoft 套件需求核對 `Microsoft.VCLibs`、`Microsoft.UI.Xaml`、`Microsoft.NET.Native`、`Microsoft.WindowsAppRuntime`；不硬編來源不明的舊版固定 Framework 數量。
- **Windows Optional Features / FOD**：.NET Framework 3.5 (`NetFx3`)、Fax and Scan、XPS Viewer；實際安裝狀態應以 PowerShell／DISM 回報為準。
- **WordPad**：僅作為傳統元件相容性研究的一部分，並非保證每套環境皆具可用 WordPad。
- **HEVC (H.265)**：不列入本專案 17 項必要 App，亦不自動加入。
- **AC-3／E-AC-3、Dolby**：不屬於上述 17 項，且沒有因此取得音訊編解碼器或 Dolby 授權；影音相容性與合法測試媒體播放需獨立驗收。

---

# ✅ Validation & Test Status / 驗收紀錄

| 驗收項目 | 24H2 | 25H2 | 26H2 | 證據邊界 |
|---|---|---|---|---|
| 各版本 ISO 全新重灌／基本使用 | **PASS** | **PASS** | **PASS** | 2026-10-31 開發者確認；非此處重新執行 |
| ISO SHA-256 本機首次計算與再次驗證 | **PASS** | **PASS** | **PASS** | 依專案歷史記錄／公開清單 |
| GitHub Release 附件存在 | **Confirmed** | **Confirmed** | **Confirmed** | GitHub Release API 附件名稱及數量 |
| GitHub 重新下載所有分卷、完整解壓及 ISO 再校驗 | Pending | Pending | Pending | 不把本機 7-Zip 測試當作網路端到端校驗 |
| 17 項 App 個別啟動與新使用者體驗 | Not fully evidenced | Not fully evidenced | Not fully evidenced | App 佈建清單 ≠ GUI 功能 PASS |
| 必要 Framework／FOD 逐項回歸 | Not fully evidenced | Not fully evidenced | Not fully evidenced | 需相依 Manifest、套件與實機結果 |
| Sysprep、Windows Update 後全回歸 | Not fully evidenced | Not fully evidenced | Not fully evidenced | 原先個別 Sysprep 成功不代表所有版本／組合皆 PASS |
| AC-3、WordPad 相容性功能驗證 | Separate tests required | Separate tests required | Separate tests required | 不宣稱內含未授權第三方組件 |
| 對外再散布權 | Unconfirmed | Unconfirmed | Unconfirmed | 應以權利人授權與適用條款為準 |

> **重點：** 三次 ISO 全新重灌已完成，**不要求重做相同安裝測試**；待補的是與之不同的逐項功能證據、版號與更新歷程確認。詳情見 [驗收報告](docs/VALIDATION_zh-TW.md)。

---

# 🛠️ PowerShell Scripts / 驗證與佈建工具

本儲存庫提供 PowerShell 5.1 原創工具。開發用途是協助合法授權的測試環境盤點與佈建，而非提供第三方套件、授權 XML 或跳過授權檢查。

| Script | Purpose | Default mode |
|---|---|---|
| [`scripts/Verify-Windows-Edition.ps1`](scripts/Verify-Windows-Edition.ps1) | Edition ID、24H2／25H2／26H2、Build、x64、繁體中文 | Read-only |
| [`scripts/Verify-InboxApps.ps1`](scripts/Verify-InboxApps.ps1) | 17 項 Apps、依 Manifest 確認必要 Framework、Optional Features／FOD | Read-only |
| [`scripts/Provision-InboxApps.ps1`](scripts/Provision-InboxApps.ps1) | 有合法來源的 AppX/MSIX、Manifest、SHA-256／授權及相依性預檢後佈建 | **Dry-run by default** |

測試 VM 的 Windows PowerShell 5.1（系統管理員）示例；以下指令應在 Clone 下來的儲存庫根目錄執行：

```powershell
New-Item -ItemType Directory C:\Temp -Force | Out-Null

# 依正在執行的那套 VM 版本，選擇 24H2、25H2 或 26H2。
.\scripts\Verify-Windows-Edition.ps1 -ExpectedVersion 24H2 -StrictLanguage -JsonPath C:\Temp\Edition.json

# 使用本地自行準備的部署 Manifest；未提供時 Framework 驗證是不完整的。
.\scripts\Verify-InboxApps.ps1 -ManifestPath "D:\Win11AppConfig\InboxApps.manifest.json" -CsvPath C:\Temp\InboxApps.csv -JsonPath C:\Temp\InboxApps.json

# 預設僅對合法來源套件進行唯讀預檢，不安裝。
.\scripts\Provision-InboxApps.ps1 -SourceRoot "D:\Win11AppSource" -ManifestPath "D:\Win11AppConfig\InboxApps.manifest.json"
```

注意：`SourceRoot`、`ManifestPath` 需替換成測試機上實際存在的位置；Manifest 必須包含所需合法套件、授權條件及 SHA-256。實際寫入 Windows 須依 [腳本使用說明](docs/SCRIPTS_zh-TW.md) 在具快照的參考 VM 額外明確啟用 `-Apply` 與確認參數。**新版腳本本身尚未完成各 VM 的 Parser／實機執行驗收**。

---

# 🧱 Build & Deployment Notes / 建置與安裝筆記

### Reference images / 版本分支

```text
Windows 11 IoT Enterprise LTSC 2024 (24H2 / 26100)
                     │
            Updated reference VM
                     │
         ┌───────────┼───────────┐
         ▼           ▼           ▼
     24H2 R3    25H2 branch   26H2 branch
     Build      + KB5054156   + KB5121794
     26100         26200         26300
         │           │           │
         └───────────┴───────────┘
                     ▼
           Separate WIM / ISO
                     ▼
      Clean installation tests PASS
```

### Windows Setup R3 / 24H2 修正紀錄

先前 24H2 自訂映像在 Windows Setup Finalize 階段出現 `0x800700B7`。此專案歷史記錄指出曾處理 WIM 根目錄的 `Windows.old` 殘留、更新映像 Description 並重新封裝，之後 R3 完成 ISO 全新安裝、OOBE 與桌面驗證。這項修正不代表所有可能的 `0x800700B7` 都有相同原因。

### Build prerequisites / 更新套件核對

- **25H2**：專案記錄使用 `KB5054156.msu`；Microsoft 對一般 Windows 11 25H2 的說明列出至少 `KB5064081`（Build 26100.5074）或更新累積更新的先決條件。
- **26H2**：專案記錄使用 `KB5121794.msu`；Microsoft 對一般 Windows 11 26H2 的說明列出至少 `KB5124010`（Build 26100.9546）或更新累積更新的先決條件。專案過去記錄的 `26300.9457` 應再與實際安裝歷程比對。
- 以上為 **一般 Windows 11 版本啟用套件**的官方說明，**不構成 Microsoft 對 LTSC 2024 的 25H2／26H2 實驗更新路徑的支援承諾**。

完整製作與 WIM／ISO 證據：[建置說明](docs/BUILD_zh-TW.md) · [驗收報告](docs/VALIDATION_zh-TW.md) · [Release 原始紀錄](releases/)。

---

# 🔐 Integrity & Extraction / 完整性與解壓原則

每個 Release 都提供自己的 ISO SHA-256 與分卷 SHA-256 清單。**僅在取得與使用均符合適用授權的前提下**：

1. 確認目前持有檔案的合法來源與完整分卷數。
2. 以 `Get-FileHash -Algorithm SHA256` 對**每個分卷**計算雜湊，與同版本的 `SHA256_7Z_Parts_版本.txt` 比對。
3. 將同版本全部 `.7z.001`、`.7z.002`……放在同一資料夾，不混用不同版本。
4. 7-Zip 從 `.001` 開始解壓，後續分卷自動處理。
5. 對還原的 ISO 計算 SHA-256，與同版本 `SHA256_版本.txt` 核對。
6. 在獲正式部署授權且已有備份／VM 快照時，再進行後續測試或使用。

```powershell
Get-FileHash -LiteralPath ".\example.7z.001" -Algorithm SHA256
Get-FileHash -LiteralPath ".\example.iso" -Algorithm SHA256
```

SHA-256 一致證明**檔案與校驗清單內容一致**，不證明它是 Microsoft 官方未修改映像、不代表安全認證，也不表示擁有再散布授權。

---

# ⚖️ Licensing & Redistribution / 授權與再散布限制

本專案為**非官方、獨立、以研究與技術分享為目的**的文件及原創腳本專案，與 Microsoft、Dolby 或其授權合作夥伴無從屬、贊助或背書關係。

- [`LICENSE`](LICENSE) 的 MIT 許可**只涵蓋作者有權授權的原創 PowerShell 程式與文件**。
- Windows ISO／WIM／ESD、Windows IoT Enterprise、Microsoft Store／AppX／MSIX、授權 XML、更新套件、Dolby、AC-3／E-AC-3、OEM 資源、商標及其他第三方元件**均不受本專案 MIT 授權涵蓋**。
- 使用者應自行確認軟體取得、安裝、修改、啟用、使用與**公開再散布**所需權利。**技術分享、壓縮密碼、付費與否或 SHA-256 均不能取代第三方授權。**
- **目前 GitHub Releases 已上傳 Windows 安裝映像的加密分卷。若沒有對應的公開再散布許可，應停止公開提供並移除附件，只保留可依法公開的原創技術文件與工具。**
- 原創程式與文件依 `LICENSE` 以「AS IS」提供。使用者須自行備份、使用測試 VM 並承擔於法律容許範圍內的操作風險；依法不得排除的責任仍依法處理。

詳情：[技術分享與法律聲明](docs/LEGAL_NOTICE_zh-TW.md)。

---

# 📚 Documentation & Official References / 文件與官方參考

| Document | Purpose |
|---|---|
| [README.md](README.md) | Release 入口與版本完整說明 |
| [docs/BUILD_zh-TW.md](docs/BUILD_zh-TW.md) | WinPE、DISM、Sysprep、建置流程 |
| [docs/VALIDATION_zh-TW.md](docs/VALIDATION_zh-TW.md) | 安裝、SHA-256 與回歸測試證據 |
| [docs/SCRIPTS_zh-TW.md](docs/SCRIPTS_zh-TW.md) | PowerShell Script 操作與 Manifest |
| [docs/LEGAL_NOTICE_zh-TW.md](docs/LEGAL_NOTICE_zh-TW.md) | 技術分享、授權及免責範圍 |
| [releases/](releases/) | 各版 GitHub Release 文字紀錄 |

官方文件：
- [Windows 11 IoT Enterprise LTSC 2024 — Microsoft Learn](https://learn.microsoft.com/windows/iot/iot-enterprise/whats-new/windows-11-iot-enterprise-ltsc-2024)
- [Windows IoT Enterprise release history](https://learn.microsoft.com/windows/iot/iot-enterprise/whats-new/release-history)
- [KB5054156 — Windows 11 25H2 enablement package](https://support.microsoft.com/en-us/servicing/os/windows/docs/2025/02/kb5054156-feature-update-to-windows-11-version-25h2-by-using-an-enablement-package)
- [KB5121794 — Windows 11 26H2 enablement package](https://support.microsoft.com/en-us/servicing/os/windows-11/2026/09/kb5121794-feature-update-to-windows-11-version-26h2)
- [Related project: Windows 10 IoT Enterprise LTSC Custom](https://github.com/hom-line/Windows-10-IoT-Enterprise-LTSC-2021-22H2-zh-TW-Custom)

---

**Maintained by [hom-line](https://github.com/hom-line)** · Documentation updated: **2026-10-31** · Language: **zh-TW** · Platform: **x64**
