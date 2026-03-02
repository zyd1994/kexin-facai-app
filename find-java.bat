@echo off
chcp 65001 >nul
echo.
echo 搜索Java安装...
echo.

set FOUND=0

REM 检查常见Java安装路径
for %%d in (
    "C:\Program Files\Java"
    "C:\Program Files (x86)\Java"
    "%ProgramFiles%\Java"
    "%ProgramFiles(x86)%\Java"
    "%JAVA_HOME%"
) do (
    if exist "%%d" (
        echo 检查目录: %%d
        dir /b "%%d" 2>nul | findstr /i "jdk" >nul
        if %errorlevel% equ 0 (
            echo ✅ 找到Java目录: %%d
            set FOUND=1

            REM 查找java.exe
            for /r "%%d" %%j in (java.exe) do (
                echo   Java可执行文件: %%j

                REM 设置临时JAVA_HOME
                set "JAVA_PATH=%%j"
                goto :found_java
            )
        )
    )
)

:found_java
if %FOUND% equ 0 (
    echo ❌ 未找到Java安装
    echo.
    echo 建议安装位置:
    echo 1. C:\Program Files\Java\jdk-11 (推荐)
    echo 2. C:\Program Files\Java\jdk1.8.0_xxx
    echo.
    echo 下载: https://adoptium.net/
) else (
    echo.
    echo 尝试设置JAVA_HOME...
    if defined JAVA_PATH (
        set JAVA_HOME=%JAVA_PATH:\bin\java=%
        echo JAVA_HOME设置为: %JAVA_HOME%

        REM 临时添加到PATH
        set PATH=%JAVA_HOME%\bin;%PATH%
        echo.
        echo 测试Java版本...
        java -version
        echo.
        javac -version
    )
)

echo.
pause