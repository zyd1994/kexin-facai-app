@echo off
chcp 65001 >nul
echo.
echo =============================================
echo     检查构建环境工具
echo =============================================
echo.

echo 1. 检查Java JDK...
where java >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('where java') do (
        echo   ✅ 找到: %%i
        set JAVA_PATH=%%i
    )

    REM 提取JAVA_HOME
    if defined JAVA_PATH (
        set JAVA_HOME=%JAVA_PATH:\bin\java=%
        echo   JAVA_HOME: %JAVA_HOME%
    )
) else (
    echo   ❌ 未找到Java
)

echo.
echo 2. 检查Android SDK...
where adb >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('where adb') do (
        echo   ✅ 找到ADB: %%i
        set ADB_PATH=%%i
    )

    REM 提取ANDROID_HOME
    if defined ADB_PATH (
        set ANDROID_HOME=%ADB_PATH:\platform-tools\adb=%
        echo   ANDROID_HOME: %ANDROID_HOME%
    )
) else (
    echo   ❌ 未找到ADB (Android SDK)
)

echo.
echo 3. 检查Android构建工具...
where aapt >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('where aapt') do echo   ✅ 找到AAPT: %%i
) else (
    echo   ❌ 未找到AAPT (Android构建工具)
)

echo.
echo 4. 检查Node.js...
where node >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('where node') do echo   ✅ 找到Node.js: %%i
    node --version
) else (
    echo   ❌ 未找到Node.js
)

echo.
echo 5. 检查Cordova...
where cordova >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('where cordova') do echo   ✅ 找到Cordova: %%i
    cordova --version
) else (
    echo   ❌ 未找到Cordova
)

echo.
echo 6. 检查npm...
where npm >nul 2>&1
if %errorlevel% equ 0 (
    for /f "tokens=*" %%i in ('where npm') do echo   ✅ 找到npm: %%i
    npm --version
) else (
    echo   ❌ 未找到npm
)

echo.
echo =============================================
echo 建议：
echo.
if defined JAVA_PATH (
    echo ✅ Java已安装
) else (
    echo ❌ 需要安装Java JDK 8+
    echo   下载: https://adoptium.net/
)

if defined ADB_PATH (
    echo ✅ Android SDK已安装
) else (
    echo ❌ 需要安装Android SDK
    echo   下载Android Studio: https://developer.android.com/studio
)

echo.
echo 运行 build-full.bat 自动安装缺失工具
echo 或运行 build.bat 尝试构建（如果工具已安装）
echo =============================================
echo.
pause