@echo off
chcp 65001 >nul
echo.
echo =============================================
echo    可欣发大财 - 最小化APK构建工具
echo    只安装Java，尝试使用现有Android环境
echo =============================================
echo.
echo 此脚本只安装Java JDK，不安装完整的Android SDK。
echo 如果您已经安装了Android Studio，此脚本可能成功。
echo 否则，请使用 build-full.bat 或 GitHub Actions。
echo.
pause

REM 检查Java
echo.
echo [1/4] 检查Java JDK...
where java >nul 2>&1
if %errorlevel% neq 0 (
    echo 未找到Java，尝试安装OpenJDK 11...

    REM 检查是否有Chocolatey
    where choco >nul 2>&1
    if %errorlevel% neq 0 (
        echo 安装Chocolatey包管理器...
        powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
        if %errorlevel% neq 0 (
            echo ❌ Chocolatey安装失败！
            echo 请手动安装Java JDK 11+
            echo 下载: https://adoptium.net/
            pause
            exit /b 1
        )
    )

    echo 使用Chocolatey安装OpenJDK 11...
    choco install openjdk11 -y --no-progress
    if %errorlevel% neq 0 (
        echo ❌ Java安装失败！
        echo 请手动安装Java JDK 11+
        pause
        exit /b 1
    )
    echo ✅ Java安装成功
) else (
    echo ✅ Java已安装
    for /f "tokens=*" %%i in ('where java') do echo   位置: %%i
)

REM 设置JAVA_HOME
for /f "tokens=*" %%i in ('where java') do set JAVA_PATH=%%i
set JAVA_HOME=%JAVA_PATH:\bin\java=%
echo JAVA_HOME设置为: %JAVA_HOME%
set PATH=%JAVA_HOME%\bin;%PATH%

REM 检查Android环境
echo.
echo [2/4] 检查Android环境...
where adb >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠ 未找到ADB (Android调试桥)
    echo.
    echo 您需要安装Android SDK才能构建APK。
    echo.
    echo 选项1：安装Android Studio（推荐）
    echo   下载: https://developer.android.com/studio
    echo   安装后重启命令行，确保ANDROID_HOME已设置
    echo.
    echo 选项2：使用GitHub Actions云构建（无需安装）
    echo   1. 创建GitHub仓库
    echo   2. 上传项目文件
    echo   3. 进入Actions页面，下载构建好的APK
    echo.
    echo 选项3：运行 build-full.bat 自动安装完整环境
    echo   （需要下载约2GB数据）
    echo.
    echo 按任意键退出，然后选择上述选项之一...
    pause >nul
    exit /b 1
) else (
    echo ✅ Android SDK已安装
    for /f "tokens=*" %%i in ('where adb') do (
        echo   ADB位置: %%i
        set ADB_PATH=%%i
    )

    REM 设置ANDROID_HOME
    set ANDROID_HOME=%ADB_PATH:\platform-tools\adb=%
    echo   ANDROID_HOME: %ANDROID_HOME%
    set PATH=%ANDROID_HOME%\platform-tools;%ANDROID_HOME%\tools;%PATH%
)

REM 检查构建工具
echo.
echo [3/4] 检查Android构建工具...
where aapt >nul 2>&1
if %errorlevel% neq 0 (
    echo ⚠ 未找到AAPT (Android资源打包工具)
    echo 可能需要安装Android构建工具...

    REM 尝试使用sdkmanager安装
    if exist "%ANDROID_HOME%\tools\bin\sdkmanager.bat" (
        echo 尝试安装构建工具...
        call "%ANDROID_HOME%\tools\bin\sdkmanager.bat" "build-tools;33.0.0" "platforms;android-33"
        if %errorlevel% neq 0 (
            echo ❌ 构建工具安装失败！
            echo 请通过Android Studio安装构建工具
            pause
            exit /b 1
        )
    ) else (
        echo ❌ 找不到sdkmanager！
        echo 请通过Android Studio安装Android SDK Build-Tools
        pause
        exit /b 1
    )
) else (
    echo ✅ Android构建工具已安装
)

REM 构建APK
echo.
echo [4/4] 构建APK...
cd /d "%~dp0"

echo 检查Cordova...
where cordova >nul 2>&1
if %errorlevel% neq 0 (
    npm install -g cordova
)

echo 检查项目依赖...
if not exist "node_modules" (
    npm install
)

echo 检查Android平台...
if not exist "platforms\android" (
    cordova platform add android
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
    echo 建议：
    echo 1. 运行 build-full.bat 安装完整环境
    echo 2. 使用GitHub Actions云构建
    echo 3. 确保Android Studio已正确安装
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
echo 按任意键退出...
pause >nul