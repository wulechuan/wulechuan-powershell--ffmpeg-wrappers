@ECHO off

CALL %~dp0用于研发阶段的命令行工具\New-成批创建所有快捷方式.bat
IF %ERRORLEVEL% EQU 0 (
    ECHO 安装完毕！
) ELSE (
    ECHO 安装时出错！
)

ECHO.
PAUSE
