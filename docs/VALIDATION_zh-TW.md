# Windows 11 三版本建置與驗收紀錄（2026-10-30）

本報告依本專案可檢查到的 GitHub 發布資訊、開發者先前提供的畫面／操作紀錄，及 **2026-10-30 的 PowerShell SHA-256 校驗結果**整理。個別驗收項目與證據來源明確區分；本報告不是獨立第三方認證。

## 1. 版本總覽

| 項目 | 24H2 App | 25H2 App | 26H2 App |
|---|---|---|---|
| 系統主 Build | 26100 | 26200 | 26300 |
| 曾觀察之 Build | 26100.1742（R3 測試映像） | 26200.9457 | 26300.9457 |
| Edition 紀錄 | IoTEnterpriseS | IoTEnterpriseS | IoTEnterpriseS |
| 安裝測試 | **PASS**（R3 全新安裝／OOBE 有歷史畫面） | **PASS**（開發者最新回報） | **PASS**（開發者最新回報） |
| 共同 17 項 Inbox Apps | 相同製作配置 | 相同製作配置 | 相同製作配置 |
| SHA-256 首次計算 | **PASS** | **PASS** | **PASS** |
| SHA-256 重新驗證 | **PASS** | **PASS** | **PASS** |
| 公開個別 SHA-256 | [已上傳](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/24H2-App-R3/SHA256_24H2.txt) | [已上傳](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/25H2-App-Experimental/SHA256_25H2.txt) | [已上傳](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/26H2-App-Experimental/SHA256_26H2.txt) |
| 逐項 Apps／AC-3／Update 回歸 | **未取得完整證據** | **未取得完整證據** | **未取得完整證據** |
| ISO 公開再散布權利 | 尚未確認 | 尚未確認 | 尚未確認 |

> [!IMPORTANT]
> **安裝 PASS** 是能完成安裝並使用 Windows 的驗證，**不是**逐項完成 Microsoft Store、各種影音編碼、AC-3／E-AC-3、Windows Update 與長期穩定度的統一 PASS。SHA-256 僅證明檔案完整性的一致性，不驗證來源簽章、無惡意程式或授權。

## 2. 原始建置／功能證據

### 24H2 R3

- 初期 Windows Setup 在 Finalize 回傳 `0x800700B7`，與 WIM 根目錄 `Windows.old` 殘留有關。
- 複製 WIM、移除殘留、補上 Description、執行完整性檢查後，後續 ISO 全新安裝成功並進入 OOBE／桌面。
- 24H2 的獨立安裝驗收紀錄較充分。

### 25H2

- 自已更新的 24H2 參考映像套用 `KB5054156.msu`，版本畫面曾呈現 26200.9457。
- 開發者最新明確回報：25H2 ISO 已測試，可正常安裝使用。
- 未取得完整的逐項 App、音效解碼及 Windows Update 測試 CSV／截圖彙整。

### 26H2

- 自獨立已更新的 24H2 參考映像套用 `KB5121794.msu`，版本畫面曾呈現 26300.9457。
- 開發者最新明確回報：26H2 ISO 已測試，可正常安裝使用。
- 需再核對相關累積更新先決條件、逐項 App／音效／Windows Update 及 WIM metadata 的完整證據。

## 3. ISO SHA-256 完整性驗證 — PASS

於 2026-10-30，開發者使用 `Generate-Win11-ISO-SHA256.ps1` 對三個實際 ISO 計算 SHA-256，產生：

```text
SHA256_24H2.txt
SHA256_25H2.txt
SHA256_26H2.txt
SHA256_ALL.txt
ISO_Metadata.csv
```

隨後重新執行 `-Verify`，PowerShell 回報：

```text
PASS：24H2 SHA-256 一致
PASS：25H2 SHA-256 一致
PASS：26H2 SHA-256 一致

三個 ISO 均通過 SHA-256 校驗。
```

三份 **各版 SHA256_*.txt** 後續經 GitHub CLI 上傳成功；公開 GitHub Release API 已確認各自存在一份同名附件。

**本文件沒有抄寫不存在的 64 位 SHA-256 值。** 精確雜湊應以附檔中的實際內容為準。

### 驗證侷限

- 驗證同一台主機檔案在前後兩次計算時內容一致。
- 不保證該 ISO 與任何 Microsoft 官方 ISO 完全相同，因為本來就是自訂映像。
- 不保證未來再次重新封裝 ISO 後仍保有相同雜湊；只要重新產生映像就必須重新校驗。
- `ISO_Metadata.csv` 可能包含建立者的本地路徑或時間資訊，公開前應檢查並移除個人識別或環境敏感欄位。

## 4. 待補的完整驗收

| 驗收項目 | 驗收方法 |
|---|---|
| 全新安裝／OOBE | 每個版本保存 VM 新磁碟安裝、OOBE 進桌面的時間及畫面 |
| Windows 系統資訊 | `winver`、`EditionID`、`CurrentBuild` 與 `UBR` |
| 17 項 Inbox Apps | App Provisioned／新使用者首次啟動／主功能操作 |
| Framework 與 FOD | `NetFx3`、Fax／Scan、XPS Viewer 的狀態與操作 |
| WordPad | 啟動、開啟／編輯／儲存檔案與更新後相容性 |
| AC-3／E-AC-3 | 使用合法測試媒體，在具體依賴 Media Foundation 的播放器播放，提供成功證據 |
| Windows Update | 更新前後版本及共同配置差異，避免元件遺失 |
| Build 先決條件 | 核對 25H2／26H2 累積更新 KB 與實際套用歷程 |
| ISO 完整性 | 重新封裝後重新產生 SHA-256，保留原始結果 |
| 公開再散布 | 微軟／Dolby／其他第三方適用授權核對 |

## 5. 已公開的資料

- [24H2 App](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/tag/24H2-App-R3)
- [25H2 App](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/tag/25H2-App-Experimental)
- [26H2 App](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/tag/26H2-App-Experimental)
- [建置指南](BUILD_zh-TW.md)

ISO 本體尚未公開發布；即使透過 7-Zip 密碼分卷，仍需符合再散布條款。
