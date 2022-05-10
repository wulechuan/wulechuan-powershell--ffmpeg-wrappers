@ECHO off





REM * * * * * * * * * * * * * * * * * * * * * * * * *
REM * * * * * * * * * * * * * * * * * * * * * * * * *
REM * * * * * * * * * * * * * * * * * * * * * * * * *
SET SHOULD_DEBUG=0
SET RelativePathToPowerShellCommonLoaderBatFile=..\工具集\通用辅助工具集\调用某-ps1-文件.bat
REM * * * * * * * * * * * * * * * * * * * * * * * * *
REM * * * * * * * * * * * * * * * * * * * * * * * * *
REM * * * * * * * * * * * * * * * * * * * * * * * * *





SET ThisBatFileFullPath=%0
SET ThisBatFileContainingFolderFullPath=%~dp0
SET AutoExit=--auto-exit

IF %AutoExit% NEQ --auto-exit SET AutoExit=

IF %SHOULD_DEBUG% EQU 1 (
    ECHO.
    ECHO DEBUG:
    ECHO ThisBatFileFullPath=%ThisBatFileFullPath%

    ECHO.
    ECHO DEBUG:
    ECHO ThisBatFileContainingFolderFullPath=%ThisBatFileContainingFolderFullPath%

    ECHO.
    ECHO DEBUG:
    ECHO AutoExit=%AutoExit%

    ECHO.
    ECHO DEBUG:
    ECHO %ThisBatFileContainingFolderFullPath%%RelativePathToPowerShellCommonLoaderBatFile%

    ECHO.
    ECHO.
    ECHO.
)





REM * * * * * * * * * * * * * * * * * * * * * * * * *
REM * * * * * * * * * * * * * * * * * * * * * * * * *
REM * * * * * * * * * * * * * * * * * * * * * * * * *
CALL %ThisBatFileContainingFolderFullPath%%RelativePathToPowerShellCommonLoaderBatFile% %AutoExit% %ThisBatFileFullPath% %*
REM * * * * * * * * * * * * * * * * * * * * * * * * *
REM * * * * * * * * * * * * * * * * * * * * * * * * *
REM * * * * * * * * * * * * * * * * * * * * * * * * *





IF %AutoExit% NEQ --auto-exit (
    PAUSE
) ELSE (
    IF %SHOULD_DEBUG% EQU 1 (
        PAUSE
    )
)
