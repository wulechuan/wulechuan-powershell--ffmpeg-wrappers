@ECHO off

SET ThisToolsetRootPath=%~p1
@REM ECHO ThisToolsetRootPath=%ThisToolsetRootPath%




SET ShouldAutoExitIfNoErrors=0
IF '%1'=='--auto-exit' (
    SET ShouldAutoExitIfNoErrors=1
    SHIFT
)





REM Ϊ�˼�㣬ǿ�� .bat �ļ����������׵� .ps1 �ļ�ͬ����
SET PowerShellScriptFileName=%~dpn1.ps1
@REM ECHO PowerShellScriptFileName=%PowerShellScriptFileName%
SHIFT





SET thisArg="%~1"
SHIFT

SET thisArg=%thisArg:`=``%

SET args=%thisArg%

:�����������Ĳ���

IF '%1'=='' GOTO ���в������Ѵ������

SET thisArg="%~1"
SHIFT

SET thisArg=%thisArg:`=``%

REM �·��� %args% ��Ӣ��ð�ŷָ��Ƚ����ף���Ϊ Windows �������ļ����г���Ӣ��ð�š�
SET args=%args%:%thisArg%

GOTO �����������Ĳ���

:���в������Ѵ������

@REM ECHO Inside BAT args=%args%




REM �·��� %args% ������˫�����������������õ����ţ������ܲ���������
IF %ShouldAutoExitIfNoErrors%==1 (
    pwsh.exe -WorkingDirectory %ThisToolsetRootPath% -Command "& '%PowerShellScriptFileName%' "%args%""
    if %ErrorLevel% NEQ 0 PAUSE
) ELSE (
    pwsh.exe -NoExit -WorkingDirectory %ThisToolsetRootPath% -Command "& '%PowerShellScriptFileName%' "%args%""
    if %ErrorLevel% NEQ 0 PAUSE
)
