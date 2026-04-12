@echo off
chcp 936 >nul
TITLE OPPO A57 刷机工具
CLS

:: ====================== 全局配置 ======================
:: 刷机相关路径
set "FIREHOSE_FILE=Firehose\prog_emmc_firehose_8937_ddr.mbn"
set "rawprogram=lk2nd\rawprogram0.xml"
set "EDL_TOOL=bin\edl.exe"
:: ADB相关配置
set "ADB_TOOL=bin\adb.exe"
set "FASTBOOT_TOOL=bin\fastboot.exe"

:: ====================== MD5 校验配置 ======================
:: 警告：必须填入所有文件的正确MD5值，否则脚本将无法运行！
:: 获取MD5值方法：CertUtil -hashfile "文件路径" MD5
set "MD5_EDL=33302af4a273d1d96304acdf4e82882b"
set "MD5_FIREHOSE=1626142bed4069f2b9e7f1d14df86200"
set "MD5_RAWPROGRAM=bac2616127d998a79479e753c800a0fc"
set "MD5_SYSTEM=acd39d06f0a4e989a89a9f840551ec3f"
set "MD5_VENDOR=c60a403f1e1cbbeaa90702770133b4ad"
set "MD5_BOOT=65fbd8e55a508f08c4699db210963148"
set "MD5_RECOVERY=543afe53dad6baae5a7a5072f0b0a59a"
set "MD5_ABOOT=76f37ec7d6a006cb76bbce39beb898d5"

:: ====================== 脚本开始 ======================
echo ==========================================
echo      OPPO A57 刷机工具
echo [重要提示]
echo 1. 刷机将修改设备系统，可能导致设备成为板砖
echo 2. 刷机前请备份所有重要数据
echo 3. 作者不对使用本脚本造成的任何损失负责
echo ==========================================
echo.
pause >nul
cls

:: ====================== 第一步：检查MD5值是否已填写 ======================
echo [阶段1/9] 检查MD5配置...
set "md5_missing=0"

if "%MD5_EDL%"=="" (
    echo [错误] 未填写 edl.exe 的MD5值
    set "md5_missing=1"
)
if "%MD5_FIREHOSE%"=="" (
    echo [错误] 未填写 Firehose文件 的MD5值
    set "md5_missing=1"
)
if "%MD5_RAWPROGRAM%"=="" (
    echo [错误] 未填写 rawprogram0.xml 的MD5值
    set "md5_missing=1"
)
if "%MD5_SYSTEM%"=="" (
    echo [错误] 未填写 system.img 的MD5值
    set "md5_missing=1"
)
if "%MD5_VENDOR%"=="" (
    echo [错误] 未填写 vendor.img 的MD5值
    set "md5_missing=1"
)
if "%MD5_BOOT%"=="" (
    echo [错误] 未填写 boot.img 的MD5值
    set "md5_missing=1"
)
if "%MD5_RECOVERY%"=="" (
    echo [错误] 未填写 recovery.img 的MD5值
    set "md5_missing=1"
)
if "%MD5_ABOOT%"=="" (
    echo [错误] 未填写 emmc_appsboot.mbn 的MD5值
    set "md5_missing=1"
)

if %md5_missing% equ 1 (
    echo.
    echo [严重错误] 缺少必要的MD5配置！
    echo 请右键编辑本脚本，在 "MD5校验配置" 部分填写所有文件的正确MD5值
    echo 获取MD5值命令示例：CertUtil -hashfile "bin\edl.exe" MD5
    pause >nul
    :: 直接退出整个脚本
    exit
)
echo [阶段1/9] MD5配置检查完成
echo.

:: ====================== 第二步：检查基础文件存在性 ======================
echo [阶段2/9] 检查基础文件存在性...
if not exist "%EDL_TOOL%" (
    echo [错误] 未找到edl.exe
    echo 请下载对应版本edl工具：https://github.com/bkerler/edl
    call :retry_or_exit "阶段2/9 基础文件检查失败"
    exit
)
if not exist "%FIREHOSE_FILE%" (
    echo [错误] Firehose文件缺失：%FIREHOSE_FILE%
    call :retry_or_exit "阶段2/9 基础文件检查失败"
    exit
)
if not exist "%rawprogram%" (
    echo [错误] rawprogram文件缺失：%rawprogram%
    call :retry_or_exit "阶段2/9 基础文件检查失败"
    exit
)
if not exist "images\system.img" (
    echo [错误] 缺失必要文件：images\system.img
    call :retry_or_exit "阶段2/9 基础文件检查失败"
    exit
)
if not exist "images\vendor.img" (
    echo [错误] 缺失必要文件：images\vendor.img
    call :retry_or_exit "阶段2/9 基础文件检查失败"
    exit
)
if not exist "images\boot.img" (
    echo [错误] 缺失必要文件：images\boot.img
    call :retry_or_exit "阶段2/9 基础文件检查失败"
    exit
)
if not exist "images\recovery.img" (
    echo [错误] 缺失必要文件：images\recovery.img
    call :retry_or_exit "阶段2/9 基础文件检查失败"
    exit
)
if not exist "images\emmc_appsboot.mbn" (
    echo [错误] 缺失必要文件：images\emmc_appsboot.mbn
    call :retry_or_exit "阶段2/9 基础文件检查失败"
    exit
)
echo [阶段2/9] 所有基础文件存在
echo.

:: ====================== 第三步：强制MD5 校验 ======================
echo [阶段3/9] 开始强制校验文件MD5完整性...
echo 警告：任何文件MD5不匹配都会立即终止脚本！
echo.

:: 校验 edl.exe
call :check_md5 "%EDL_TOOL%" %MD5_EDL% "edl.exe"
if errorlevel 1 (
    echo [错误] edl.exe MD5校验失败！文件可能损坏或被篡改
    echo 请重新下载正确的文件并更新MD5值
    call :retry_or_exit "阶段3/9 MD5校验失败"
    exit
)

:: 校验 Firehose 文件
call :check_md5 "%FIREHOSE_FILE%" %MD5_FIREHOSE% "Firehose文件"
if errorlevel 1 (
    echo [错误] Firehose文件 MD5校验失败！
    call :retry_or_exit "阶段3/9 MD5校验失败"
    exit
)

:: 校验 rawprogram0.xml
call :check_md5 "%rawprogram%" %MD5_RAWPROGRAM% "rawprogram0.xml"
if errorlevel 1 (
    echo [错误] rawprogram0.xml MD5校验失败！
    call :retry_or_exit "阶段3/9 MD5校验失败"
    exit
)

:: 校验 system.img
echo [提示] 正在校验 system.img (文件较大，可能需要几分钟，请耐心等待)...
call :check_md5 "images\system.img" %MD5_SYSTEM% "system.img"
if errorlevel 1 (
    echo [错误] system.img MD5校验失败！
    call :retry_or_exit "阶段3/9 MD5校验失败"
    exit
)

:: 校验 vendor.img
echo [提示] 正在校验 vendor.img...
call :check_md5 "images\vendor.img" %MD5_VENDOR% "vendor.img"
if errorlevel 1 (
    echo [错误] vendor.img MD5校验失败！
    call :retry_or_exit "阶段3/9 MD5校验失败"
    exit
)

:: 校验 boot.img
call :check_md5 "images\boot.img" %MD5_BOOT% "boot.img"
if errorlevel 1 (
    echo [错误] boot.img MD5校验失败！
    call :retry_or_exit "阶段3/9 MD5校验失败"
    exit
)

:: 校验 recovery.img
call :check_md5 "images\recovery.img" %MD5_RECOVERY% "recovery.img"
if errorlevel 1 (
    echo [错误] recovery.img MD5校验失败！
    call :retry_or_exit "阶段3/9 MD5校验失败"
    exit
)

:: 校验 emmc_appsboot.mbn
call :check_md5 "images\emmc_appsboot.mbn" %MD5_ABOOT% "emmc_appsboot.mbn"
if errorlevel 1 (
    echo [错误] emmc_appsboot.mbn MD5校验失败！
    call :retry_or_exit "阶段3/9 MD5校验失败"
    exit
)

echo.
echo ================================================
echo      【安全通过】所有文件MD5校验完全匹配！
echo ================================================
echo 文件完整性确认无误，可以安全进行刷机
echo ================================================
echo.
pause >nul
cls

:: ====================== 第四步：刷入lk2nd  ======================
:flash_lk2nd
echo [阶段4/9] 准备刷入lk2nd...
echo ================================================
echo 刷机前确认：
echo 1. 已安装9008驱动
echo 2. 设备已正确进入9008模式（设备管理器显示Qualcomm 9008）
echo 3. 确认Firehose文件与设备芯片匹配：%FIREHOSE_FILE%
echo 4. 使用USB 2.0接口（USB 3.0可能出现问题）
echo 5. 关闭占用端口的软件（如搞机助手、杀毒软件）
echo ================================================
echo. 按任意键开始刷入lk2nd...
pause >nul

echo [阶段4/9] 开始刷入lk2nd...
%EDL_TOOL% --loader %FIREHOSE_FILE% rawprogram %rawprogram%

if %errorlevel% neq 0 (
    echo [错误] lk2nd刷入失败
    echo 排查方案：
    echo 1. Firehose文件不匹配：请替换对应设备/芯片的prog_emmc_firehose文件
    echo 2. 驱动问题：检查9008驱动是否安装并正确识别
    echo 3. edl工具版本：尝试更新edl工具到最新版本
    echo 4. 设备硬件：确认设备正确进入EDL模式，硬件无故障
    call :retry_or_exit "阶段4/9 lk2nd刷入失败"
    goto :flash_lk2nd
)

echo [阶段4/9] lk2nd刷入成功
%EDL_TOOL% reset
echo 设备将自动重启，请等待进入fastboot模式...
echo.

:: ====================== 第五步：检查LineageOS刷机文件 ======================
echo [阶段5/9] 检查LineageOS刷机文件...
echo (文件已在MD5校验阶段确认存在且完整)
echo.

:: ====================== 第六步：自动检测fastboot设备（30秒超时） ======================
:detect_fastboot
echo [阶段6/9] 开始自动检测fastboot设备（超时时间：30秒）...
set "timeout=30"
set "device_detected=0"

:fastboot_loop
if %timeout% equ 0 (
    echo [错误] 30秒内未检测到fastboot设备！
    echo 排查方案：
    echo 1. OPPO A57是否通过USB连接电脑
    echo 2. OPPO A57是否已进入fastboot模式
    echo 3. 是否安装OPPO A57的USB驱动程序
    call :retry_or_exit "阶段6/9 fastboot设备检测失败"
    goto :detect_fastboot
)

echo 剩余检测时间：%timeout%秒...
%FASTBOOT_TOOL% devices | findstr "fastboot" >nul
if %errorlevel% equ 0 (
    set "device_detected=1"
    goto :fastboot_detected
)

timeout /t 1 /nobreak >nul
set /a timeout-=1
goto :fastboot_loop

:fastboot_detected
echo [阶段6/9] 设备已连接并进入fastboot模式
echo.

:: ====================== 第七步：确认刷机 ======================
:confirm_flash
set /p "confirm=请输入 YES 确认继续刷机（数据将会清空）："
if /i not "%confirm%"=="YES" (
    echo 用户取消操作
    pause >nul
    exit
)
echo.

:: ====================== 第八步：刷入LineageOS镜像 ======================
:flash_images
echo [阶段7/9] 开始刷入系统镜像...
:: 刷入system
%FASTBOOT_TOOL% flash system images\system.img
if errorlevel 1 (
    echo [错误] system.img刷入失败
    call :retry_or_exit "阶段7/9 system.img刷入失败"
    goto :flash_images
)
echo [成功] system镜像刷入完成
echo.

:: 刷入vendor（oem分区）
echo [阶段7/9] 开始刷入vendor镜像...
%FASTBOOT_TOOL% flash oem images\vendor.img
if errorlevel 1 (
    echo [错误] vendor.img刷入失败
    call :retry_or_exit "阶段7/9 vendor.img刷入失败"
    goto :flash_images
)
echo [成功] vendor镜像刷入完成
echo.

:: 刷入aboot
echo [阶段7/9] 开始刷入aboot...
%FASTBOOT_TOOL% flash aboot images\emmc_appsboot.mbn
if errorlevel 1 (
    echo [错误] emmc_appsboot.mbn刷入失败
    call :retry_or_exit "阶段7/9 aboot刷入失败"
    goto :flash_images
)
echo [成功] aboot刷入完成
echo.

:: 刷入recovery
echo [阶段7/9] 开始刷入recovery...
%FASTBOOT_TOOL% flash recovery images\recovery.img
if errorlevel 1 (
    echo [错误] recovery.img刷入失败
    call :retry_or_exit "阶段7/9 recovery.img刷入失败"
    goto :flash_images
)
echo [成功] recovery镜像刷入完成
echo.

:: 刷入boot
echo [阶段7/9] 开始刷入boot镜像...
%FASTBOOT_TOOL% flash boot images\boot.img
if errorlevel 1 (
    echo [错误] boot.img刷入失败
    call :retry_or_exit "阶段7/9 boot.img刷入失败"
    goto :flash_images
)
echo [成功] boot镜像刷入完成
echo.

:: ====================== 第九步：清除缓存和用户数据 ======================
:erase_partitions
echo [阶段8/9] 清除cache分区...
%FASTBOOT_TOOL% erase cache
if errorlevel 1 (
    echo [错误] cache分区清除失败
    call :retry_or_exit "阶段8/9 cache分区清除失败"
    goto :erase_partitions
)

echo [阶段8/9] 清除userdata分区...
%FASTBOOT_TOOL% erase userdata
if errorlevel 1 (
    echo [错误] userdata分区清除失败
    call :retry_or_exit "阶段8/9 userdata分区清除失败"
    goto :erase_partitions
)

echo [成功] 分区清理完成
echo.

:: ====================== 第十步：重启设备并修复WiFi和时间 ======================
echo [阶段9/9] 重启设备...
%FASTBOOT_TOOL% reboot
echo 设备正在重启，请等待设备完全开机并连接USB调试...
echo 请确保：
echo 1. 设备已开启USB调试
echo 2. 设备已授权当前电脑的USB调试权限
echo 3. 设备已连接WiFi或移动数据
echo.
echo 准备完成后按任意键继续...
pause >nul
cls

:: ====================== WiFi小叉消除 + 时间同步 ======================
:fix_wifi_time
echo [后续] 开始修复WiFi小叉和时间同步...
echo.

:: 启动ADB服务
echo 启动ADB服务...
%ADB_TOOL% start-server

:: 检测设备连接
echo 检测设备连接...
%ADB_TOOL% devices
echo.
set "device_found="
for /f "tokens=2" %%a in ('%ADB_TOOL% devices ^| findstr /r "device$"') do (
    set "device_found=1"
)

if not defined device_found (
    echo [错误] 未检测到已授权的设备
    echo 排查方案：
    echo 1. 设备是否通过USB连接电脑
    echo 2. 设备是否开启USB调试
    echo 3. 设备是否授权当前电脑的USB调试权限
    echo 4. 是否安装ADB驱动程序
    call :retry_or_exit "WiFi/时间修复阶段 设备检测失败"
    goto :fix_wifi_time
)

echo [成功] 设备已连接并授权
echo.

:: 清除原有网络验证配置
echo 清除原有网络验证配置...
%ADB_TOOL% shell settings delete global captive_portal_https_url >nul 2>&1
%ADB_TOOL% shell settings delete global captive_portal_http_url >nul 2>&1
echo [成功] 清除原有验证配置完成
echo.

:: 设置小米网络验证服务器
echo 设置HTTP网络验证服务器...
%ADB_TOOL% shell "settings put global captive_portal_http_url http://connect.rom.miui.com/generate_204" >nul 2>&1
if %errorlevel% neq 0 (
    echo [警告] HTTP验证服务器设置失败
) else (
    echo [成功] HTTP验证服务器已设置为小米服务器
)

echo 设置HTTPS网络验证服务器...
%ADB_TOOL% shell "settings put global captive_portal_https_url https://connect.rom.miui.com/generate_204" >nul 2>&1
if %errorlevel% neq 0 (
    echo [警告] HTTPS验证服务器设置失败
) else (
    echo [成功] HTTPS验证服务器已设置为小米服务器
)
echo.

:: 设置NTP时间服务器
echo 设置NTP时间服务器...
%ADB_TOOL% shell settings put global ntp_server ntp1.aliyun.com >nul 2>&1
if %errorlevel% neq 0 (
    echo [警告] NTP服务器设置失败
) else (
    echo [成功] NTP服务器已设置为阿里云服务器
)
echo.

:: 开启自动时间同步
echo 开启自动时间和时区同步...
%ADB_TOOL% shell settings put global auto_time 1 >nul 2>&1
%ADB_TOOL% shell settings put global auto_time_zone 1 >nul 2>&1
if %errorlevel% equ 0 (
    echo [成功] 已开启自动时间和时区同步
) else (
    echo [警告] 自动时间同步开启失败
)
echo.

:: ====================== 完成提示 ======================
echo ==========================================
echo              全部操作完成
echo ==========================================
echo 提示：
echo 1. 若时间仍不准确，请手动设置时区为北京/GMT+8
echo 2. 若WiFi仍显示小叉，请断开重连或重启设备
echo ==========================================
echo.
echo 按任意键退出...
pause >nul
exit

:: ====================== 通用重试/退出函数 ======================
:retry_or_exit
set "error_stage=%~1"
echo.
echo ====================== 错误处理 ======================
echo 当前失败阶段：%error_stage%
set /p "choice=请选择操作 [1=重新尝试 2=退出脚本]："
if /i "%choice%"=="1" (
    echo 正在重新尝试 %error_stage% 阶段...
    echo.
    exit /b 0  :: 仅退出函数，回到原失败位置重试
) else if /i "%choice%"=="2" (
    echo 用户选择退出脚本，即将关闭窗口...
    pause >nul
    exit  :: 直接终止整个脚本进程，彻底退出
) else (
    echo 输入无效，默认退出脚本...
    pause >nul
    exit  :: 直接终止整个脚本进程，彻底退出
)

:: ====================== MD5 校验函数 (请勿修改) ======================
:check_md5
set "file_path=%~1"
set "expected_md5=%~2"
set "file_desc=%~3"

:: 计算文件MD5
for /f "skip=1 tokens=* delims=" %%a in ('CertUtil -hashfile "%file_path%" MD5 ^| findstr /v "CertUtil"') do (
    set "actual_md5=%%a"
    goto :process_md5
)

:process_md5
:: 去除MD5中的空格
set "actual_md5=%actual_md5: =%"

:: 对比MD5
if /i "%actual_md5%"=="%expected_md5%" (
    echo [成功] %file_desc% MD5校验通过
    exit /b 0
) else (
    echo [失败] %file_desc% MD5校验不匹配
    echo    预期 MD5: %expected_md5%
    echo    实际 MD5: %actual_md5%
    exit /b 1
)