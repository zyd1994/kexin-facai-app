# GitHub Actions 云构建APK - 详细步骤指南

## 📋 准备工作

### 1. 注册GitHub账号（如果没有）
- 访问 [GitHub官网](https://github.com)
- 点击右上角 "Sign up" 注册新账号
- 完成邮箱验证

### 2. 安装Git客户端（可选，推荐）
- 下载 [Git for Windows](https://gitforwindows.org/)
- 安装时选择默认选项即可
- 安装后可在任意文件夹右键使用 "Git Bash Here"

## 🚀 详细操作步骤

### 步骤1：创建GitHub仓库

1. 登录GitHub后，点击右上角 **"+"** → **"New repository"**
2. 填写仓库信息：
   - **Repository name**: `kexin-facai-app` (或其他名称)
   - **Description**: 可欣发大财 - 财运测试APP
   - **Public** (公开，免费)
   - **不要勾选** "Initialize this repository with a README"
   - 点击 **"Create repository"**

### 步骤2：上传项目文件到GitHub

**方法A：使用Git命令行（推荐）**

```bash
# 1. 进入项目目录
cd "C:\Users\57490\kexin-facai-app"

# 2. 初始化Git仓库
git init

# 3. 添加所有文件
git add .

# 4. 提交文件
git commit -m "Initial commit: 可欣发大财APP项目"

# 5. 连接到GitHub仓库
git remote add origin https://github.com/你的用户名/kexin-facai-app.git

# 6. 推送代码
git push -u origin main
```

**注意**：如果提示 "error: src refspec main does not match any"，请尝试：
```bash
git branch -M main
git push -u origin main
```

**方法B：使用GitHub网页上传**

1. 在刚创建的仓库页面，找到 **"uploading an existing file"**
2. 点击 **"upload files"**
3. 将 `kexin-facai-app` 文件夹内的**所有文件和文件夹**拖拽到上传区域
   - 确保上传 `.github` 文件夹（包含Actions配置）
   - 确保上传 `www` 文件夹（包含APP代码）
   - 确保上传 `config.xml`、`package.json` 等配置文件
4. 点击 **"Commit changes"**

### 步骤3：触发GitHub Actions构建

1. 上传完成后，进入仓库页面
2. 点击顶部菜单 **"Actions"**
3. 左侧选择 **"Build Android APK"** 工作流
4. 如果工作流没有自动运行，点击 **"Run workflow"** → **"Run workflow"**

### 步骤4：等待构建完成

- 构建过程需要 **5-10分钟**
- 可以实时查看构建日志
- 等待所有步骤显示 **绿色对勾✓**

### 步骤5：下载APK文件

1. 构建完成后，在 **"Build Android APK"** 工作流页面
2. 找到 **"Artifacts"** 部分
3. 点击 **"kexin-facai-apk"** 下载ZIP文件
4. 解压ZIP文件，获得APK文件

## 📱 安装APK到手机

### Android手机设置
1. 将APK文件通过USB、微信、QQ等方式传输到手机
2. 在手机上打开 **"设置"** → **"安全"**
3. 开启 **"未知来源应用安装"**（不同手机位置可能不同）
4. 找到APK文件，点击安装
5. 安装完成后即可运行 **"可欣发大财"** APP

## 🔧 常见问题解决

### Q1：Git push失败，提示权限问题
**解决**：
```bash
# 检查远程仓库地址是否正确
git remote -v

# 如果使用HTTPS，尝试使用SSH：
git remote set-url origin git@github.com:你的用户名/kexin-facai-app.git

# 生成SSH密钥并添加到GitHub
ssh-keygen -t ed25519 -C "your_email@example.com"
# 将 ~/.ssh/id_ed25519.pub 内容添加到GitHub Settings → SSH keys
```

### Q2：Actions构建失败
**可能原因**：
1. **配置文件错误**：确保上传了完整的 `.github/workflows/build-apk.yml` 文件
2. **依赖问题**：Actions会自动解决，等待重新运行
3. **超时问题**：免费账号有6小时限制，我们的构建只需10分钟

**解决**：
- 查看构建日志，找到具体错误
- 重新推送代码触发新的构建

### Q3：无法下载Artifacts
**解决**：
- 确保构建成功完成（所有步骤为绿色）
- 等待几分钟再尝试下载
- 如果超过7天未下载，Artifacts会自动删除（可重新触发构建）

### Q4：APK安装失败
**解决**：
- 确保手机Android版本在5.0以上
- 检查手机存储空间
- 重启手机后重试

## 📞 获取帮助

如果遇到问题：
1. 查看构建日志中的具体错误信息
2. 搜索GitHub Actions相关文档
3. 可以在GitHub仓库的 **"Issues"** 中提问

## 🎉 成功提示

当您看到以下提示时，说明APK构建成功：
```
APK构建完成！
APK文件列表：
- app-debug.apk (约5-10MB)
```

恭喜！您的"可欣发大财"APP已成功打包为Android APK！

---
**祝您财源广进，好运连连！** 🎱💰