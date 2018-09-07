@echo off
set SVNPATH=C:\Git\1CMAIN\Main\Scripts\
set PBACKUPDIR=\\dc-qufib\d$\Backup\
set LBACKUPDIR=C:\FILEDATA\BACKS\
set LFBNAME=QUFIBMonthDiff.bak
set LDBNAME=QUFIBHourDiff.bak
set PSQLSCRIPT="%SVNPATH%Restore_LQT.sql"
set RESTLOG="Z:\restlog.txt"
rem Setlocal EnableDelayedExpansion

echo "NEW RESTORE" %date% %time%>>%RESTLOG%

robocopy %PBACKUPDIR% %LBACKUPDIR% %LDBNAME% /COPY:DAT /LOG+:%RESTLOG% /NP /TEE

if NOT ERRORLEVEL==1 goto :end
echo Succes copy %date% %time%>>%RESTLOG%

if not exist %LBACKUPDIR%%LDBNAME% (
echo File %LDBNAME% not found %time%>>%RESTLOG%
goto :end
)

echo Start restore %time%>>%RESTLOG%
sqlcmd -i %PSQLSCRIPT% -u>>%RESTLOG%
echo Compliet restore %time%>>%RESTLOG%

del /Q %LBACKUPDIR%%LDBNAME%

:end
echo End operations>>%RESTLOG%