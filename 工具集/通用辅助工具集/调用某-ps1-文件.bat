@ECHO off

SET ThisToolsetRootPath=%~p1
@REM ECHO ThisToolsetRootPath=%ThisToolsetRootPath%




SET ShouldAutoExitIfNoErrors=0
IF '%1'=='--auto-exit' (
    SET ShouldAutoExitIfNoErrors=1
    SHIFT
)





REM 为了简便，强制 .bat 文件与与其配套的 .ps1 文件同名。
SET PowerShellScriptFileName=%~dpn1.ps1
@REM ECHO PowerShellScriptFileName=%PowerShellScriptFileName%
SHIFT





SET thisArg="%~1"
SHIFT

SET thisArg=%thisArg:`=``%

SET args=%thisArg%

:继续处理更多的参数

IF '%1'=='' GOTO 所有参数均已处理完毕

SET thisArg="%~1"
SHIFT

SET thisArg=%thisArg:`=``%

REM 下方的 %args% 用英语冒号分隔比较稳妥，因为 Windows 不允许文件名中出现英语冒号。
SET args=%args%:%thisArg%

GOTO 继续处理更多的参数

:所有参数均已处理完毕

@REM ECHO Inside BAT args=%args%




REM 下方的 %args% 必须用双引号括起来，不能用单引号，更不能不括起来。
IF %ShouldAutoExitIfNoErrors%==1 (
    pwsh.exe -WorkingDirectory %ThisToolsetRootPath% -Command "& '%PowerShellScriptFileName%' "%args%""
    if %ErrorLevel% NEQ 0 PAUSE
) ELSE (
    pwsh.exe -NoExit -WorkingDirectory %ThisToolsetRootPath% -Command "& '%PowerShellScriptFileName%' "%args%""
    if %ErrorLevel% NEQ 0 PAUSE
)
