@ECHO off

REM * * * * * * * * * * * * * * * * * * * * * * * * *
REM * * * * * * * * * * * * * * * * * * * * * * * * *
REM * * * * * * * * * * * * * * * * * * * * * * * * *
SET RelativePathToPowerShellCommonLoaderBatFile=ͨ�ø������߼�\����ĳ-ps1-�ļ�.bat
REM * * * * * * * * * * * * * * * * * * * * * * * * *
REM * * * * * * * * * * * * * * * * * * * * * * * * *
REM * * * * * * * * * * * * * * * * * * * * * * * * *





SET ThisBatFileFullPath=%0
SET ThisBatFileContainerFolderFullPath=%~dp0

REM * * * * * * * * * * * * * * * * * * * * * * * * *
CALL %ThisBatFileContainerFolderFullPath%%RelativePathToPowerShellCommonLoaderBatFile% %ThisBatFileFullPath% %*
REM * * * * * * * * * * * * * * * * * * * * * * * * *
