@ECHO off

REM * * * * * * * * * * * * * * * * * * * * * * * * *
REM * * * * * * * * * * * * * * * * * * * * * * * * *
REM * * * * * * * * * * * * * * * * * * * * * * * * *
SET RelativePathToPowerShellCommonLoaderBatFile=通用辅助工具集\调用某-ps1-文件.bat
REM * * * * * * * * * * * * * * * * * * * * * * * * *
REM * * * * * * * * * * * * * * * * * * * * * * * * *
REM * * * * * * * * * * * * * * * * * * * * * * * * *





SET ThisBatFileFullPath=%0
SET ThisBatFileContainerFolderFullPath=%~dp0

REM * * * * * * * * * * * * * * * * * * * * * * * * *
CALL %ThisBatFileContainerFolderFullPath%%RelativePathToPowerShellCommonLoaderBatFile% %ThisBatFileFullPath% %*
REM * * * * * * * * * * * * * * * * * * * * * * * * *
