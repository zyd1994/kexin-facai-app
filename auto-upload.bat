@echo off
chcp 65001 >nul
echo.
echo =============================================
echo     可欣发大财 - 全自动GitHub上传构建工具
echo =============================================
echo.
echo 此脚本将引导您完成所有步骤，将项目上传到GitHub。
echo GitHub Actions会自动构建APK，无需安装任何环境。
echo.
echo 重要：您需要有一个GitHub账号。
echo 如果没有，请先访问 https://github.com 注册。
echo.
pause

echo.
echo ============ 第1步：检查Git配置 ============
echo.
set /p GIT_USER="请输入您的Git用户名（建议使用英文名或GitHub用户名）："
set /p GIT_EMAIL="请输入您的Git邮箱（建议使用GitHub注册邮箱）："

echo.
echo 正在配置Git...
git config --global user.name "%GIT_USER%"
git config --global user.email "%GIT_EMAIL%"
echo ✅ Git配置完成

echo.
echo ============ 第2步：初始化本地Git仓库 ============
echo.
cd /d "%~dp0"
echo 初始化Git仓库...
call :run_command git init
echo 添加所有文件...
call :run_command git add .
echo 提交文件...
call :run_command git commit -m "初始提交：可欣发大财APP - 财运测试趣味应用"

echo.
echo ============ 第3步：创建GitHub仓库 ============
echo.
echo 请按照以下步骤在GitHub上创建仓库：
echo.
echo 1. 打开浏览器，访问 https://github.com
echo 2. 登录您的账号
echo 3. 点击右上角 "+" → "New repository"
echo 4. 填写仓库信息：
echo    - Repository name: kexin-facai-app
echo    - Description: 可欣发大财 - 财运测试APP
echo    - 选择 Public
echo    - 不要勾选 "Initialize with README"
echo 5. 点击 "Create repository"
echo.
echo 创建完成后，您会看到一个包含Git命令的页面。
echo 请复制页面上的远程仓库URL（HTTPS格式）。
echo 格式为：https://github.com/您的用户名/kexin-facai-app.git
echo.
set /p GITHUB_URL="请粘贴GitHub仓库URL（按Enter跳过使用默认值）："

if "%GITHUB_URL%"=="" (
    echo ❌ 必须提供GitHub仓库URL！
    echo 请重新运行脚本并提供正确的URL。
    pause
    exit /b 1
)

echo.
echo ============ 第4步：连接到GitHub并推送代码 ============
echo.
echo 连接到远程仓库...
call :run_command git remote add origin "%GITHUB_URL%"

echo 重命名分支为main...
call :run_command git branch -M main

echo 推送代码到GitHub...
call :run_command git push -u origin main

echo.
echo ============ 第5步：触发GitHub Actions构建 ============
echo.
echo 🎉 代码已成功推送到GitHub！
echo.
echo 接下来，请按以下步骤操作：
echo.
echo 1. 在浏览器中打开您的GitHub仓库：
echo    %GITHUB_URL%
echo.
echo 2. 点击顶部的 "Actions" 标签
echo 3. 在左侧选择 "Build Android APK" 工作流
echo 4. 等待构建完成（约5-10分钟）
echo.
echo 3. 构建完成后，在 "Artifacts" 部分：
echo    - 点击 "kexin-facai-apk"
echo    - 下载ZIP文件
echo    - 解压获得APK文件
echo.
echo 4. 将APK传输到Android手机安装
echo.
echo ============ 第6步：立即体验APP ============
echo.
echo 在等待构建的同时，您可以立即体验APP：
echo.
echo 双击打开：%~dp0www\index.html
echo 在浏览器中预览完整功能！
echo.
echo =============================================
echo 🎉 所有步骤已完成！
echo =============================================
echo.
echo 如果有任何问题，请查看 github-guide.md 文件
echo 或重新运行此脚本。
echo.
pause
exit /b

:run_command
echo 执行: %*
%*
if %errorlevel% neq 0 (
    echo ❌ 命令执行失败！
    echo 错误代码: %errorlevel%
    echo 请检查后重试。
    pause
    exit /b 1
)
echo ✅ 命令执行成功
goto :eof