@ECHO off
SET ThisBatFileFullPath=%0
SET ThisBatFileContainerFolderFullPath=%~dp0
CALL %ThisBatFileContainerFolderFullPath%通用辅助工具集\调用某-ps1-文件.bat %ThisBatFileFullPath% %*
@ECHO on
