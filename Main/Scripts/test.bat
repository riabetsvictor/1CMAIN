@echo off
set SVNPATH=C:\Users\viktor.ryabets\DESK\Для работы\SVN\Main\Scripts\
set PBACKUPDIR=\\dc-qufib\d$\Backup\
set LBACKUPDIR=C:\FILEDATA\BACKS\
set LFBNAME=QUFIBMonthDiff.bak
set LDBNAME=QUFIBHourDiff.bak
set PSQLSCRIPT="%SVNPATH%Restore_LQT.sql"
set RESTLOG="Z:\restlog.txt"
rem Setlocal EnableDelayedExpansion

echo "NEW RESTORE" %date% %time%>>%RESTLOG%

REM robocopy %PBACKUPDIR% %LBACKUPDIR% %LDBNAME% /COPY:DAT /LOG+:%RESTLOG% /NP /TEE

REM if NOT ERRORLEVEL==1 goto :end
REM echo Succes copy %date% %time%>>%RESTLOG%

REM if not exist %LBACKUPDIR%%LDBNAME% (
REM echo File %LDBNAME% not found %time%>>%RESTLOG%
REM goto :end
REM )

echo Start restore %time%>>%RESTLOG%
sqlcmd -i %PSQLSCRIPT% -u>>%RESTLOG%
echo Compliet restore %time%>>%RESTLOG%

del /Q %LBACKUPDIR%%LDBNAME%

:end
echo End operations>>%RESTLOG%