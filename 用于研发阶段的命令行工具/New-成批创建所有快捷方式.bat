@ECHO off
SET ThisBatFileFullPath=%0
SET ThisBatFileContainingFolderFullPath=%~dp0
SET AutoExit=--auto-exit
IF %AutoExit% NEQ --auto-exit SET AutoExit=

@REM ECHO.
@REM ECHO DEBUG:
@REM ECHO ThisBatFileFullPath=%ThisBatFileFullPath%
@REM 
@REM ECHO.
@REM ECHO DEBUG:
@REM ECHO ThisBatFileContainingFolderFullPath=%ThisBatFileContainingFolderFullPath%
@REM 
@REM ECHO.
@REM ECHO DEBUG:
@REM ECHO AutoExit=%AutoExit%

CALL %ThisBatFileContainingFolderFullPath%..\工具集\通用辅助工具集\调用某-ps1-文件.bat %AutoExit% %ThisBatFileFullPath% %*
IF %AutoExit% NEQ --auto-exit PAUSE
