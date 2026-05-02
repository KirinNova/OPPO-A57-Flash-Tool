# OPPO-A57-Flash-Tool
专为 **OPPO A57 (2016)** 打造的 Windows 批处理一键线刷工具，基于 **9008/EDL + Fastboot** 双模式实现全自动可视化刷机，内置文件校验、失败重试、WiFi联网修复、阿里云NTP时间同步，零命令操作、新手即用。

📥 立即下载 | Download
👉 [GitHub Releases 发布页](https://github.com/KirinNova/OPPO-A57-Flash-Tool/releases)

---

## 项目简介 | Project Overview
### 中文
本工具为OPPO A57 (2016) 定制自动化刷机脚本，依托EDL线刷工具、ADB/Fastboot平台工具开发。解决原厂手动刷机步骤繁琐、易报错、门槛高的痛点，全程图形文字引导+自动文件校验，大幅降低刷机变砖风险。
刷机流程：9008刷入lk2nd二级引导 → 自动识别Fastboot设备 → 一键刷入全核心分区 → 清空数据缓存 → 开机自动修复WiFi与网络时间。

### English
A fully automatic one-click flashing script exclusively for OPPO A57 (2016), built with EDL, ADB and Fastboot binaries. It simplifies complicated manual flashing procedures, reduces operation errors and lowers the threshold for beginners. With visual guidance and automatic file check, it minimizes bricking risks.
Workflow: Flash lk2nd bootloader via 9008 Mode → Auto detect Fastboot device → Flash full system partitions → Wipe data & cache → Auto fix Wi-Fi and time sync after boot.

---

## 核心特性 | Core Features
- ✅ 全自动化流程：无需手动输命令，回车即可完成全套刷机
- ✅ 文件预校验：提前检测工具/镜像完整性，杜绝缺失文件变砖
- ✅ 失败重试机制：刷机异常弹窗可选重试/退出
- ✅ 完整分区线刷：一键刷入 system/vendor/boot/recovery/aboot
- ✅ 自动修复：解决刷机后WiFi已连无网、系统时间错乱问题
- ✅ 中文可视化界面：步骤清晰、超时等待，零基础上手
- ✅ 专属适配：针对OPPO A57 高通8937平台深度定制

---

## 支持机型 | Supported Device
- OPPO A57（2016 标准版）

## 环境要求 | System Requirements
1. 系统：Windows 7/8/10/11（32/64位通用）
2. 驱动：Qualcomm 9008 驱动 + ADB/Fastboot 驱动
3. 接口：优先电脑后置 **USB 2.0** 接口
4. 电量：设备电量 ≥ 50%

## 使用教程 | Usage Guide
### 准备工作
1. 前往 Releases 下载最新工具压缩包
2. 解压至**纯英文无空格路径**（禁止中文目录）
3. 完整安装高通9008刷机驱动

### 刷机步骤
1. 双击运行 `OPPO-A57-Flash-Tool.bat`
2. 阅读风险声明，按任意键继续
3. 脚本自动校验全部依赖文件
4. 手机关机进入9008模式，按提示回车刷入lk2nd
5. 等待自动重启进入Fastboot，脚本自动识别设备
6. 输入 `YES` 确认刷机（清空全部用户数据）
7. 等待自动刷分区、清缓存、重启设备
8. 首次开机后按回车，自动修复WiFi与网络时间
9. 提示刷机完成即可拔线使用

### 进入9008模式 | Enter 9008 Mode
关机状态下，**同时按住音量上+音量下**，插入USB线；设备管理器出现 `Qualcomm HS-USB QDLoader 9008` 即为成功。

---

## 项目文件结构 | File Structure
```
OPPOA57-Flash-Tool/
├── bin/                # 核心工具二进制
│   ├── edl.exe
│   ├── adb.exe
│   └── fastboot.exe
├── Firehose/           # 高通刷机加载器
│   └── prog_emmc_firehose_8937_ddr.mbn
├── lk2nd/              # 二级引导配置
│   └── rawprogram0.xml
├── images/             # 系统分区镜像
│   ├── system.img
│   ├── vendor.img
│   ├── boot.img
│   ├── recovery.img
│   └── emmc_appsboot.mbn
└── OPPO-A57-Flash-Tool.bat  # 主运行脚本
```

---

## 功能说明 | Function Description
1. **lk2nd 引导刷入**：9008模式刷入适配二级引导，解锁Fastboot完整刷机权限
2. **全分区一键刷机**：自动刷入所有核心系统分区，无需手动操作
3. **自动数据清空**：清除userdata/cache，规避刷机卡开机、无限重启
4. **WiFi联网修复**：替换网络验证配置，修复连接WiFi无法上网故障
5. **网络时间同步**：内置阿里云NTP服务器，自动校准系统时间

---

## 注意事项 | Important Notes
1. 刷机将**清空所有数据**，可能失去官方保修，操作前务必备份
2. 工具必须放在**纯英文无空格目录**，避免路径报错
3. 严禁混用其他机型镜像，仅使用OPPO A57专用固件
4. 本工具仅限**技术研究用途**，违规操作造成设备损坏，作者不承担责任

---

## 常见问题 FAQ
**Q：提示未找到 edl.exe**
A：保持完整文件夹结构，不要单独移动bat主脚本，重新解压工具包即可。

**Q：电脑识别不到9008设备**
A：重装高通9008驱动，更换USB 2.0接口或原装数据线。

**Q：刷入lk2nd失败**
A：确认驱动正常、已正确进入9008模式，切换后置USB2.0接口重试。

**Q：刷机后WiFi连得上但无法上网**
A：开机后重新运行脚本，执行内置WiFi修复功能即可生效。
