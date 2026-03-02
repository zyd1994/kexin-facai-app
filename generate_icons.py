#!/usr/bin/env python3
"""
图标生成脚本
自动生成Cordova项目所需的各种尺寸图标和启动画面
需要安装Pillow库: pip install Pillow
"""

import os
from PIL import Image, ImageDraw, ImageFont
import sys

def create_icon(size, output_path):
    """创建圆形金色图标"""
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # 计算圆形位置
    center = size // 2
    radius = int(size * 0.4)

    # 绘制金色圆形
    draw.ellipse(
        [center - radius, center - radius,
         center + radius, center + radius],
        fill=(255, 215, 0, 255)  # 金色
    )

    # 添加深金色边框
    border_radius = radius + int(size * 0.02)
    draw.ellipse(
        [center - border_radius, center - border_radius,
         center + border_radius, center + border_radius],
        outline=(212, 175, 55, 255),
        width=int(size * 0.04)
    )

    # 添加"财"字 (如果尺寸足够大)
    if size >= 48:
        try:
            # 尝试使用中文字体，如果不可用则使用默认
            font_size = int(size * 0.4)
            try:
                font = ImageFont.truetype("msyh.ttc", font_size)
            except:
                font = ImageFont.load_default()

            # 计算文字位置
            text = "财"
            bbox = draw.textbbox((0, 0), text, font=font)
            text_width = bbox[2] - bbox[0]
            text_height = bbox[3] - bbox[1]
            text_x = center - text_width // 2
            text_y = center - text_height // 2

            draw.text((text_x, text_y), text, fill=(255, 255, 255, 255), font=font)
        except:
            pass

    # 保存图片
    img.save(output_path, 'PNG')
    print(f"生成图标: {output_path} ({size}x{size})")

def create_splash(size, output_path):
    """创建启动画面"""
    width, height = size
    img = Image.new('RGB', (width, height), (255, 249, 230))  # 浅金色背景

    draw = ImageDraw.Draw(img)

    # 添加渐变效果 (简单版本)
    for i in range(height):
        # 从浅金色到金色的渐变
        r = 255
        g = 249 - int(i / height * 50)
        b = 230 - int(i / height * 100)
        draw.line([(0, i), (width, i)], fill=(r, g, b))

    # 添加中央圆形
    center_x = width // 2
    center_y = height // 2
    radius = min(width, height) // 4

    draw.ellipse(
        [center_x - radius, center_y - radius,
         center_x + radius, center_y + radius],
        fill=(255, 215, 0)  # 金色
    )

    # 添加"财"字
    if width >= 200 and height >= 200:
        try:
            font_size = min(width, height) // 8
            try:
                font = ImageFont.truetype("msyh.ttc", font_size)
            except:
                font = ImageFont.load_default()

            text = "财"
            bbox = draw.textbbox((0, 0), text, font=font)
            text_width = bbox[2] - bbox[0]
            text_height = bbox[3] - bbox[1]
            text_x = center_x - text_width // 2
            text_y = center_y - text_height // 2

            draw.text((text_x, text_y), text, fill=(255, 255, 255), font=font)
        except:
            pass

    # 保存图片
    img.save(output_path, 'PNG')
    print(f"生成启动画面: {output_path} ({width}x{height})")

def main():
    # 创建目录
    os.makedirs('res/icon/android', exist_ok=True)
    os.makedirs('res/screen/android', exist_ok=True)

    # 图标尺寸 (Android)
    icon_sizes = [
        ('ldpi', 36),
        ('mdpi', 48),
        ('hdpi', 72),
        ('xhdpi', 96),
        ('xxhdpi', 144),
        ('xxxhdpi', 192)
    ]

    # 生成图标
    for density, size in icon_sizes:
        output_path = f'res/icon/android/icon-{size}-{density}.png'
        create_icon(size, output_path)

    # 启动画面尺寸 (Android)
    splash_sizes = [
        ('land-ldpi', (320, 240)),
        ('land-mdpi', (480, 320)),
        ('land-hdpi', (800, 480)),
        ('land-xhdpi', (1280, 720)),
        ('port-ldpi', (240, 320)),
        ('port-mdpi', (320, 480)),
        ('port-hdpi', (480, 800)),
        ('port-xhdpi', (720, 1280))
    ]

    # 生成启动画面
    for density, size in splash_sizes:
        output_path = f'res/screen/android/splash-{density}.png'
        create_splash(size, output_path)

    print("\n图标生成完成！")
    print("如果中文字体显示不正常，请确保系统已安装中文字体。")

if __name__ == '__main__':
    main()