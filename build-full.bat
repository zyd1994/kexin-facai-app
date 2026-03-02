@echo off
chcp 65001 >nul
echo.
echo =============================================
echo    可欣发大财 - 完整APK构建工具
echo    自动安装所有必要环境并构建APK
echo =============================================
echo.
echo 警告：此过程将下载约2GB的数据，需要稳定的网络连接！
echo 构建过程可能需要30分钟以上，请耐心等待。
echo.
pause

REM 检查并安装Chocolatey
echo.
echo [1/7] 检查Chocolatey包管理器...
where choco >nul 2>&1
if %errorlevel% neq 0 (
    echo 安装Chocolatey...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
    if %errorlevel% neq 0 (
        echo ❌ Chocolatey安装失败！
        echo 请手动安装Chocolatey：https://chocolatey.org/install
        pause
        exit /b 1
    )
    echo ✅ Chocolatey安装成功
) else (
    echo ✅ Chocolatey已安装
)

REM 安装OpenJDK 11
echo.
echo [2/7] 安装Java JDK 11...
choco install openjdk11 -y --no-progress
if %errorlevel% neq 0 (
    echo ❌ Java JDK安装失败！
    echo 请手动安装Java JDK 11或更高版本
    pause
    exit /b 1
)
echo ✅ Java JDK安装成功

REM 设置JAVA_HOME
for /f "tokens=*" %%i in ('where java') do set JAVA_PATH=%%i
set JAVA_HOME=%JAVA_PATH:\bin\java=%
echo JAVA_HOME设置为: %JAVA_HOME%

REM 安装Android命令行工具
echo.
echo [3/7] 安装Android命令行工具...
choco install android-sdk -y --no-progress
if %errorlevel% neq 0 (
    echo ❌ Android SDK安装失败！
    echo 尝试安装Android命令行工具...
    choco install androidcmdlinetools -y --no-progress
    if %errorlevel% neq 0 (
        echo ❌ Android命令行工具安装失败！
        echo 请手动安装Android Studio：https://developer.android.com/studio
        pause
        exit /b 1
    )
)
echo ✅ Android工具安装成功

REM 设置ANDROID_HOME
if defined ProgramFiles(x86) (
    set ANDROID_HOME=%ProgramFiles(x86)%\Android\android-sdk
) else (
    set ANDROID_HOME=%ProgramFiles%\Android\android-sdk
)
echo ANDROID_HOME设置为: %ANDROID_HOME%

REM 更新PATH
set PATH=%JAVA_HOME%\bin;%ANDROID_HOME%\tools;%ANDROID_HOME%\tools\bin;%ANDROID_HOME%\platform-tools;%PATH%

REM 接受Android许可证
echo.
echo [4/7] 接受Android许可证...
echo y | sdkmanager --licenses >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠ 许可证接受失败，尝试继续...
)

REM 安装必要的Android平台和构建工具
echo.
echo [5/7] 安装Android SDK组件...
sdkmanager "platform-tools" "platforms;android-33" "build-tools;33.0.0" >nul
if %errorlevel% neq 0 (
    echo ⚠ SDK组件安装失败，尝试继续...
)

REM 安装Cordova（如果未安装）
echo.
echo [6/7] 检查Cordova...
where cordova >nul 2>&1
if %errorlevel% neq 0 (
    echo 安装Cordova CLI...
    npm install -g cordova
    if %errorlevel% neq 0 (
        echo ❌ Cordova安装失败！
        pause
        exit /b 1
    )
    echo ✅ Cordova安装成功
) else (
    echo ✅ Cordova已安装
)

REM 安装项目依赖
echo.
echo [7/7] 安装项目依赖并构建APK...
cd /d "%~dp0"

if not exist "node_modules" (
    npm install
    if %errorlevel% neq 0 (
        echo ❌ 项目依赖安装失败！
        pause
        exit /b 1
    )
)

if not exist "platforms\android" (
    cordova platform add android
    if %errorlevel% neq 0 (
        echo ❌ Android平台添加失败！
        pause
        exit /b 1
    )
)

echo.
echo =============================================
echo 开始构建APK...
echo =============================================
echo.

cordova build android

if %errorlevel% neq 0 (
    echo.
    echo ❌ APK构建失败！
    echo.
    echo 常见问题：
    echo 1. 网络问题导致组件下载失败
    echo 2. 系统缺少必要的依赖
    echo 3. 磁盘空间不足
    echo.
    echo 建议方案：
    echo 1. 使用GitHub Actions云构建（推荐）
    echo 2. 手动安装Android Studio和Java JDK
    echo 3. 使用在线APK构建服务
    echo.
    pause
    exit /b 1
)

echo.
echo =============================================
echo 🎉 APK构建成功！
echo =============================================
echo.
echo APK文件位置：
echo %~dp0platforms\android\app\build\outputs\apk\debug\app-debug.apk
echo.
echo 文件大小：
for %%I in ("%~dp0platforms\android\app\build\outputs\apk\debug\app-debug.apk") do echo   %%~zI 字节
echo.
echo 将APK文件复制到Android手机安装即可
echo.
echo 提示：如需发布版本，需要创建签名密钥：
echo keytool -genkey -v -keystore my-release-key.keystore -alias alias_name ^
echo   -keyalg RSA -keysize 2048 -validity 10000
echo.
echo 然后运行：
echo cordova build android --release
echo.
pause