@echo off
chcp 65001 >nul
echo.
echo =============================================
echo    可欣发大财 - Android APK 构建工具
echo =============================================
echo.

REM 检查Node.js
echo [1/5] 检查Node.js环境...
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 未检测到Node.js！
    echo 请先安装Node.js: https://nodejs.org/
    pause
    exit /b 1
)
echo ✅ Node.js 已安装

REM 检查Cordova
echo [2/5] 检查Cordova CLI...
cordova --version >nul 2>&1
if errorlevel 1 (
    echo ⚠ Cordova CLI 未安装，正在尝试安装...
    npm install -g cordova >nul 2>&1
    if errorlevel 1 (
        echo ❌ Cordova 安装失败！
        echo 请手动执行: npm install -g cordova
        pause
        exit /b 1
    )
    echo ✅ Cordova 安装成功
) else (
    echo ✅ Cordova 已安装
)

REM 检查Java
echo [3/5] 检查Java环境...
java -version >nul 2>&1
if errorlevel 1 (
    echo ❌ 未检测到Java！
    echo 请先安装Java JDK 8或更高版本
    pause
    exit /b 1
)
echo ✅ Java 已安装

REM 检查项目依赖
echo [4/5] 安装项目依赖...
if not exist "node_modules" (
    npm install >nul 2>&1
    if errorlevel 1 (
        echo ❌ 依赖安装失败！
        echo 请手动执行: npm install
        pause
        exit /b 1
    )
    echo ✅ 项目依赖安装成功
) else (
    echo ✅ 项目依赖已存在
)

REM 添加Android平台（如果不存在）
echo [5/5] 配置Android平台...
if not exist "platforms\android" (
    cordova platform add android >nul 2>&1
    if errorlevel 1 (
        echo ❌ Android平台添加失败！
        echo 请确保Android SDK已正确安装
        echo 并设置ANDROID_HOME环境变量
        pause
        exit /b 1
    )
    echo ✅ Android平台添加成功
) else (
    echo ✅ Android平台已存在
)

REM 生成图标（可选）
echo.
echo 可选：生成应用图标...
echo 需要Python和Pillow库，是否生成？(Y/N)
set /p generate_icons=
if /i "%generate_icons%"=="Y" (
    if exist "generate_icons.py" (
        python generate_icons.py
        if errorlevel 1 (
            echo ⚠ 图标生成失败，使用默认图标
        ) else (
            echo ✅ 图标生成成功
        )
    ) else (
        echo ⚠ 图标生成脚本不存在，使用默认图标
    )
)

REM 构建APK
echo.
echo =============================================
echo 开始构建APK...
echo =============================================
echo.

cordova build android

if errorlevel 1 (
    echo.
    echo ❌ APK构建失败！
    echo 请检查以上错误信息
    echo.
    echo 常见问题：
    echo 1. Android SDK未正确配置
    echo 2. 缺少必要的Android构建工具
    echo 3. 网络问题导致依赖下载失败
    pause
    exit /b 1
)

echo.
echo =============================================
echo 🎉 APK构建成功！
echo =============================================
echo.
echo APK文件位置：
echo platforms\android\app\build\outputs\apk\debug\app-debug.apk
echo.
echo 将APK文件复制到Android手机安装即可
echo.
echo 提示：如需发布版本，请执行：
echo cordova build android --release
echo.
pause