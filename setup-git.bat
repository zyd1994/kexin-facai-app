@echo off
chcp 65001 >nul
echo.
echo =============================================
echo     准备Git仓库 - 用于GitHub上传
echo =============================================
echo.
echo 此脚本将帮助您准备项目文件，以便上传到GitHub。
echo 上传后，GitHub Actions会自动构建APK。
echo.
echo 请确保您已：
echo 1. 注册GitHub账号 (https://github.com)
echo 2. 创建名为"kexin-facai-app"的仓库
echo.
pause

echo.
echo [1/3] 初始化Git仓库...
cd /d "%~dp0"
git init
if %errorlevel% neq 0 (
    echo ❌ Git初始化失败！
    echo 请确保已安装Git：https://gitforwindows.org/
    pause
    exit /b 1
)
echo ✅ Git仓库初始化成功

echo.
echo [2/3] 添加所有文件...
git add .
if %errorlevel% neq 0 (
    echo ❌ 添加文件失败！
    pause
    exit /b 1
)
echo ✅ 文件已添加到暂存区

echo.
echo [3/3] 提交文件...
git commit -m "初始提交：可欣发大财APP项目 - 财运测试趣味应用"
if %errorlevel% neq 0 (
    echo ❌ 提交失败！
    pause
    exit /b 1
)
echo ✅ 提交成功

echo.
echo =============================================
echo 🎉 Git仓库准备完成！
echo =============================================
echo.
echo 下一步操作：
echo.
echo 1. 连接到GitHub仓库：
echo    git remote add origin https://github.com/您的用户名/kexin-facai-app.git
echo.
echo 2. 推送代码到GitHub：
echo    git push -u origin main
echo.
echo 如果提示分支错误，请先执行：
echo    git branch -M main
echo    git push -u origin main
echo.
echo 3. 登录GitHub，进入仓库的"Actions"页面
echo    等待自动构建完成（约5-10分钟）
echo.
echo 4. 在"Artifacts"部分下载APK文件
echo.
echo 详细步骤请查看 github-guide.md 文件
echo.
echo =============================================
echo 按任意键查看GitHub操作指南...
pause >nul

start "" "github-guide.md"