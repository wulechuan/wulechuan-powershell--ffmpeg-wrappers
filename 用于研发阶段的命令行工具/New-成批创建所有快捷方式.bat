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

CALL %ThisBatFileContainingFolderFullPath%..\���߼�\ͨ�ø������߼�\����ĳ-ps1-�ļ�.bat %AutoExit% %ThisBatFileFullPath% %*
IF %AutoExit% NEQ --auto-exit PAUSE
