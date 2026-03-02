#!/bin/bash

echo ""
echo "============================================="
echo "    可欣发大财 - Android APK 构建工具"
echo "============================================="
echo ""

# 检查Node.js
echo "[1/5] 检查Node.js环境..."
if ! command -v node &> /dev/null; then
    echo "❌ 未检测到Node.js！"
    echo "请先安装Node.js: https://nodejs.org/"
    exit 1
fi
echo "✅ Node.js 已安装"

# 检查Cordova
echo "[2/5] 检查Cordova CLI..."
if ! command -v cordova &> /dev/null; then
    echo "⚠ Cordova CLI 未安装，正在尝试安装..."
    npm install -g cordova
    if [ $? -ne 0 ]; then
        echo "❌ Cordova 安装失败！"
        echo "请手动执行: npm install -g cordova"
        exit 1
    fi
    echo "✅ Cordova 安装成功"
else
    echo "✅ Cordova 已安装"
fi

# 检查Java
echo "[3/5] 检查Java环境..."
if ! command -v java &> /dev/null; then
    echo "❌ 未检测到Java！"
    echo "请先安装Java JDK 8或更高版本"
    exit 1
fi
echo "✅ Java 已安装"

# 检查项目依赖
echo "[4/5] 安装项目依赖..."
if [ ! -d "node_modules" ]; then
    npm install
    if [ $? -ne 0 ]; then
        echo "❌ 依赖安装失败！"
        echo "请手动执行: npm install"
        exit 1
    fi
    echo "✅ 项目依赖安装成功"
else
    echo "✅ 项目依赖已存在"
fi

# 添加Android平台（如果不存在）
echo "[5/5] 配置Android平台..."
if [ ! -d "platforms/android" ]; then
    cordova platform add android
    if [ $? -ne 0 ]; then
        echo "❌ Android平台添加失败！"
        echo "请确保Android SDK已正确安装"
        echo "并设置ANDROID_HOME环境变量"
        exit 1
    fi
    echo "✅ Android平台添加成功"
else
    echo "✅ Android平台已存在"
fi

# 生成图标（可选）
echo ""
echo "可选：生成应用图标..."
read -p "需要Python和Pillow库，是否生成？(Y/N): " generate_icons

if [[ $generate_icons =~ ^[Yy]$ ]]; then
    if [ -f "generate_icons.py" ]; then
        python3 generate_icons.py
        if [ $? -ne 0 ]; then
            echo "⚠ 图标生成失败，使用默认图标"
        else
            echo "✅ 图标生成成功"
        fi
    else
        echo "⚠ 图标生成脚本不存在，使用默认图标"
    fi
fi

# 构建APK
echo ""
echo "============================================="
echo "开始构建APK..."
echo "============================================="
echo ""

cordova build android

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ APK构建失败！"
    echo "请检查以上错误信息"
    echo ""
    echo "常见问题："
    echo "1. Android SDK未正确配置"
    echo "2. 缺少必要的Android构建工具"
    echo "3. 网络问题导致依赖下载失败"
    exit 1
fi

echo ""
echo "============================================="
echo "🎉 APK构建成功！"
echo "============================================="
echo ""
echo "APK文件位置："
echo "platforms/android/app/build/outputs/apk/debug/app-debug.apk"
echo ""
echo "将APK文件复制到Android手机安装即可"
echo ""
echo "提示：如需发布版本，请执行："
echo "cordova build android --release"
echo ""