# 🎉 可欣发大财 - 财运测试趣味APP

一个简单、简约、好看的财运测试趣味APP，金色发财风格，支持生成安卓APK安装包。

## ✨ 功能特色

- **金色发财主题** - 专业设计的金色渐变界面，喜庆大气
- **5道财运测试题** - 简单有趣的选择题，测测你的财运指数
- **智能分数计算** - 根据选择计算得分，生成个性化财运分析
- **广告变现集成** - 支持观看广告解锁完整财运分析报告
- **跨平台支持** - 基于Cordova，可打包为Android APK

## 📱 界面预览

1. **欢迎页** - 金色主题Logo和启动按钮
2. **测试页** - 5道财运选择题，简洁美观
3. **结果页** - 财运分析报告，支持广告解锁详细内容

## 🚀 快速开始

### 方法1：直接在浏览器中运行

1. 打开 `www/index.html` 文件
2. 在浏览器中直接体验APP功能

### 方法2：打包为Android APK

#### 环境准备

1. **安装Node.js** (版本12.0.0或更高)
   - 访问 [Node.js官网](https://nodejs.org/) 下载安装
   - 安装后验证：`node --version`

2. **安装Cordova CLI**
   ```bash
   npm install -g cordova
   ```

3. **安装Java JDK** (版本8或更高)
   - 下载地址：https://adoptium.net/
   - 设置JAVA_HOME环境变量

4. **安装Android Studio** (包含Android SDK)
   - 下载地址：https://developer.android.com/studio
   - 安装后设置ANDROID_HOME环境变量
   - 在Android Studio中安装必要的SDK版本

#### 生成图标（可选）

项目已包含图标生成脚本，需要Python环境：

```bash
# 安装依赖
pip install -r requirements.txt

# 生成图标
python generate_icons.py
```

如果没有Python环境，可以手动创建图标文件：
- 将 `res/icon/android/icon.svg` 转换为不同尺寸的PNG
- 尺寸要求：36x36, 48x48, 72x72, 96x96, 144x144, 192x192
- 启动画面尺寸参考 `config.xml` 中的配置

#### 构建APK

1. **进入项目目录**
   ```bash
   cd kexin-facai-app
   ```

2. **安装项目依赖**
   ```bash
   npm install
   ```

3. **添加Android平台**
   ```bash
   cordova platform add android
   ```

4. **构建APK**
   ```bash
   cordova build android
   ```

5. **获取APK文件**
   构建完成后，APK文件位于：
   ```
   platforms/android/app/build/outputs/apk/debug/app-debug.apk
   ```

#### 高级构建选项

**构建发布版本（签名APK）**
```bash
# 1. 生成密钥库（第一次需要）
keytool -genkey -v -keystore my-release-key.keystore -alias alias_name -keyalg RSA -keysize 2048 -validity 10000

# 2. 创建签名配置文件
# 在项目根目录创建 release-signing.properties 文件
# 内容如下：
# storeFile=my-release-key.keystore
# storeType=jks
# keyAlias=alias_name
# keyPassword=your_key_password
# storePassword=your_store_password

# 3. 构建发布版
cordova build android --release
```

**构建AAB格式（上架Google Play）**
```bash
cordova build android --release -- --packageType=bundle
```

## 📁 项目结构

```
kexin-facai-app/
├── www/                      # 网页源码
│   └── index.html           # 主页面（包含CSS和JS）
├── res/                      # 资源文件
│   ├── icon/android/        # 应用图标
│   └── screen/android/      # 启动画面
├── hooks/                   # Cordova钩子脚本
├── config.xml              # Cordova配置文件
├── package.json            # 项目配置文件
├── generate_icons.py       # 图标生成脚本
├── requirements.txt        # Python依赖
├── .gitignore             # Git忽略文件
└── README.md              # 项目说明
```

## 🔧 自定义配置

### 修改应用信息
编辑 `config.xml` 文件：
- `id`: 应用包名（如：com.kexin.facai）
- `name`: 应用显示名称
- `version`: 应用版本号
- `author`: 作者信息

### 修改广告配置
项目中已集成AdMob插件，需要在 `www/index.html` 中配置广告单元ID：

1. 在Google AdMob平台注册应用并获取广告单元ID
2. 在JS代码中替换广告单元ID（搜索 `ADMOB_AD_UNIT_ID`）

### 修改题目内容
编辑 `www/index.html` 中的JavaScript部分：
- 修改 `questions` 数组中的题目和选项
- 修改 `results` 数组中的分数段和结果描述

## 📊 变现方案

1. **激励视频广告** - 用户观看广告解锁完整分析报告
2. **横幅广告** - 在页面底部显示横幅广告
3. **插页广告** - 在页面切换时显示插页广告

## 🤝 常见问题

### Q: 构建时出现"Command failed with exit code 1"
A: 检查环境配置：
- Node.js和npm是否正确安装
- Java JDK是否正确安装并配置JAVA_HOME
- Android SDK是否正确安装并配置ANDROID_HOME

### Q: 图标显示不正常
A: 确保图标文件存在且尺寸正确，可以重新运行图标生成脚本

### Q: 广告无法显示
A: 确保已配置正确的AdMob广告单元ID，并测试时使用测试广告ID

### Q: 如何更新应用内容
A: 直接修改 `www/index.html` 文件，然后重新构建APK

## ☁️ 使用GitHub Actions云构建（无需安装环境）

如果你不想在本地安装复杂的Android开发环境，可以使用GitHub Actions自动构建APK。

### 步骤：

1. **创建GitHub仓库**
   - 在GitHub上创建一个新的仓库（如 `kexin-facai-app`）
   - 将本项目所有文件上传到仓库

2. **触发自动构建**
   - 项目已包含 `.github/workflows/build-apk.yml` 工作流文件
   - 每次推送代码到 `main` 或 `master` 分支时，GitHub Actions会自动构建APK

3. **下载APK文件**
   - 进入仓库的 **Actions** 页面
   - 选择最新的工作流运行
   - 在 **Artifacts** 部分下载 `kexin-facai-apk.zip`
   - 解压后即可获得APK文件

### 优点：
- ✅ 无需安装Java、Android SDK等复杂环境
- ✅ 自动构建，无需手动操作
- ✅ 支持持续集成，更新代码后自动重新构建

### 注意事项：
- 需要GitHub账号
- 每次构建需要等待约5-10分钟
- 构建的APK为调试版本，如需发布版本需要配置签名

## 📄 许可证

MIT License - 详见项目文件

## ✍️ 作者

**可欣发大财** - 专为可欣设计的财运测试APP

---
💰 **祝你财源广进，好运连连！** 💰