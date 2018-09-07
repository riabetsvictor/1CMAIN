@echo off

set RUNCMD="C:\Program Files (x86)\1cv8\8.3.8.2197\bin\1cv8.exe"
set PATHIB="viktor\local-qufib-test"
set PATHDUMPIB="C:\Users\viktor.ryabets\DESK\Для работы\SVN\Production\Configuration\"
set LOG="Z:\vcslog.txt"

set PATHREPORTS="C:\Users\viktor.ryabets\DESK\Для работы\SVN\Production\Externals\ReportsExternal\"
set PATHDATAPROC="C:\Users\viktor.ryabets\DESK\Для работы\SVN\Production\Externals\DataProcessorsExternal\"
set PATHDPUNLOADEPF="C:\Users\viktor.ryabets\DESK\Для работы\SVN\Main\1CProjects\DataProcessorsExternal\ВыгрузитьОбработки.epf"

set svn="C:\Program Files\TortoiseSVN\bin\svn.exe"
set SVNPATH="C:\Users\viktor.ryabets\DESK\Для работы\SVN\Production\*"
set SVNPATH0="C:\Users\viktor.ryabets\DESK\Для работы\SVN\Production\"
set SVNPATH00="C:\Users\viktor.ryabets\DESK\Для работы\SVN\Production\

echo Start unload IB %date% %time%>>%LOG%

start "SVN Cleanup" /wait %svn% cleanup %SVNPATH%
start "SVN Update" /wait %svn% update %SVNPATH%

start /wait wmic process where "name='1cv8.exe'" call terminate
timeout /T 5 /NOBREAK
call "C:\Users\viktor.ryabets\DESK\Для работы\SVN\Main\Scripts\83_DelCach.bat">>%LOG%

start "" /wait %RUNCMD% DESIGNER /S%PATHIB% /DumpConfigToFiles %PATHDUMPIB% -Format Hierarchical /Out%LOG% -NoTruncate

echo Start DataProcessors binary unload %date% %time%>>%LOG%
start "" /wait %RUNCMD% ENTERPRISE /S%PATHIB% /DisableStartupMessages /RunModeOrdinaryApplication /Execute %PATHDPUNLOADEPF%
echo Complite DataProcessors binary unload %date% %time%>>%LOG%

echo Start commit to SVN %date% %time%>>%LOG%

cd %SVNPATH0%
Setlocal EnableDelayedExpansion
chcp 1251 >NUL

for /f "tokens=* delims=eof" %%a in ('%svn% status') do (
	>NUl chcp 866
	
	set x=%%a
	set f=!x:~0,1!
	set fname=!x:~8!
	set fname=!SVNPATH00!!fname!"
	
	if !f!==? (
		!svn! add !fname!
		for /f "tokens=* delims=eof" %%e in (!fname!) do (
			if %%~xe==.epf start "" /wait !RUNCMD! DESIGNER /S!PATHIB! /Out!LOG! -NoTruncate /DumpExternalDataProcessorOrReportToFiles !PATHDATAPROC! !fname! -Format Hierarchical
			if %%~xe==.erf start "" /wait !RUNCMD! DESIGNER /S!PATHIB! /Out!LOG! -NoTruncate /DumpExternalDataProcessorOrReportToFiles !PATHREPORTS! !fname! -Format Hierarchical
		)
	)
	
	if !f!==M (
		for /f "tokens=* delims=eof" %%e in (!fname!) do (
			if %%~xe==.epf start "" /wait !RUNCMD! DESIGNER /S!PATHIB! /Out!LOG! -NoTruncate /DumpExternalDataProcessorOrReportToFiles !PATHDATAPROC! !fname! -Format Hierarchical
			if %%~xe==.erf start "" /wait !RUNCMD! DESIGNER /S!PATHIB! /Out!LOG! -NoTruncate /DumpExternalDataProcessorOrReportToFiles !PATHREPORTS! !fname! -Format Hierarchical
		)
	)
)

Setlocal EnableDelayedExpansion
chcp 1251 >NUL

for /f "tokens=* delims=eof" %%a in ('%svn% status') do (
	> NUL chcp 866

	set x=%%a
	set f=!x:~0,1!
	set fname=!x:~8!
	if !f!==? !svn! add !SVNPATH00!!fname!"
)

%svn% commit -m ""

echo Complite commit to SVN %date% %time%>>%LOG%

:end
echo End unload IB %date% %time%>>%LOG%