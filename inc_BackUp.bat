@ECHO OFF

set BATCHPATH=%cd% 
echo %BATCHPATH% is the current directory >CON

:: *** 2 command line parameters needed
IF [%2]==[] GOTO Syntax


:: ** first parameter must be a valid directory
PUSHD %1 && POPD || GOTO Syntax
:: ** Second parameter must be a valid directory
PUSHD %2 && POPD || GOTO Syntax




SET SOURCEDIR=%1
rem C:\lavoro\Clienti\Polverari\VxDataTestDir
SET BACKUPDIR=%2
rem C:\lavoro\Clienti\Polverari\VxDataBackUpDir

:: Move on sourced dir
cd %SOURCEDIR%

FOR %%I in (*.*) DO (
     ::Echo checking %%I >CON
     IF NOT EXIST %BACKUPDIR%\%%I (
         ECHO %%I doesn't exist in %BACKUPDIR%>CON
         ::Copying the file in BackUp
         copy %%I  %BACKUPDIR%\%%I
     ) ELSE call:SalvaDati %SOURCEDIR% %BACKUPDIR% %%I
)

:: Back on batch dir
cd %BATCHPATH%
pause

GOTO:EOF
 
:Syntax
ECHO.>CON
ECHO inc_backUp.bat,  Version 1.00 for Windows>CON
ECHO Perform incremental backup>CON
ECHO Written by Fernando Morani>CON
ECHO USAGE:>CON
ECHO inc_backUp.bat accepts 2 input paramters - That's Mandatory>CON
GOTO:EOF


:SalvaDati

SET FIRSTFILESIZE=0
SET SECONDFILESIZE=0

:: Check specified first file's actual size
SET temp=%1
SET tempFile="%3"

set FIRSTFILESIZE=%~z3
::echo FIRSTFILESIZE is %FIRSTFILESIZE%

:: Check specified second file's actual size
SET temp=%2
SET tempFile="%3"

FOR /F "usebackq" %%A IN ('%2\%3') DO set SECONDFILESIZE=%%~zA

::echo SECONDFILESIZE is %SECONDFILESIZE%

:: Compare file's size and verify the result
IF %FIRSTFILESIZE% NEQ %SECONDFILESIZE% (
    rem echo First is %FIRSTFILESIZE%
    rem echo Second is %SECONDFILESIZE%
    echo Different sizes copying the file %tempFile%
    copy %tempFile%  %BACKUPDIR%\%tempFile%
)
GOTO:EOF

