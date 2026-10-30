# 25H2 App — 25H2-App-Experimental

| 項目 | 說明 |
|---|---|
| 版本 | 25H2 / Build 26200 |
| Edition | IoTEnterpriseS（自製測試映像） |
| 架構、語言 | x64 / zh-TW |
| 更新路線 | 已更新的 24H2 參考映像；離線 MSU：KB5054156.msu |
| 狀態 | LTSC 基礎自製實驗版；安裝測試 PASS（專案作者回報）；完整功能回歸尚待彙整 |
| ISO 檔名 | `zh-tw_windows_11_IoT_enterprise_ltsc_2024_x64_dvd_6287d84d_25H2_App.iso` |

## 共用預裝內容

三版預裝配置相同：17 項 Inbox Apps（Store、Store Purchase、App Installer、Calculator、Paint、Notepad、Snipping Tool、Camera、Photos、Media Player、AV1、AVC Encoder、VP9、HEIF、WebP、Web Media、MPEG-2），相依 Framework、.NET Framework 3.5、Fax and Scan、XPS Viewer，以及 WordPad 與 AC-3/Dolby 相容性研究。未包含 HEVC。

## 版本說明

24H2 是官方 LTSC 2024 版本基礎；25H2／26H2 是將相關 Enablement Package 應用於 LTSC 基礎上的**非官方實驗改版**，不表示 Microsoft 支援此 LTSC 升級路線。25H2 和 26H2 各自由 24H2 分支建立，不是連續升級。

## 測試驗證與公開 Release 附件狀態

三個 Release 頁面已公開，本版已上傳 **6 個加密 ISO 分卷**（7-Zip，單卷最多 1800 MiB），並附原始 ISO 與分卷 SHA-256 清單。密碼為 `1742`。本機 7-Zip 測試 PASS；**尚未將 GitHub 附件全套重新下載解壓驗證**。Windows 與 Dolby 等元件的公開再散布權須另行確認，密碼不等於授權。


- [25H2 分卷 SHA-256 清單](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/25H2-App-Experimental/SHA256_7Z_Parts_25H2.txt)
- [25H2 原始 ISO SHA-256](https://github.com/hom-line/Windows-11-IoT-Enterprise-LTSC-2024-zh-TW-Custom/releases/download/25H2-App-Experimental/SHA256_25H2.txt)

[返回完整 README](../README.md)

## 驗收說明

本專案作者確認 24H2、25H2、26H2 三個版本**均已進行安裝測試並成功使用**。三版共同預裝內容相同；惟個別 Apps、AC-3／E-AC-3 原生播放、Windows Update 後的全面回歸及授權驗證，仍須以個別測試報告判定，不以系統安裝成功代替。
