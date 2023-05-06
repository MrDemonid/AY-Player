@ECHO OFF
BREAK ON

:: set PL/M tools and sources paths
set SOURCES=..\SOURCE

if %PLM80% == "" goto nodef
set PLMBIN=%PLM80%\BIN
set PLMLIB=%PLM80%\LIB
goto clearprev

:nodef
:: !!! predefined path not found, use default !!!
set PLMBIN=C:\PLMTOOL\BIN
set PLMLIB=C:\PLMTOOL\LIB

:clearprev
:: clear previous files
del %SOURCES%\*.obj
del %SOURCES%\*.lst
del stcpl.com


:: set sources and plm80 paths with ISIS-II style
set :F0:=%PLMBIN%
set :F1:=%SOURCES%
set :F2:=%PLMLIB%

cls
%PLMBIN%\ASM80 :f1:keyb.m80
if errorlevel == 1 goto error

%PLMBIN%\ASM80 :f1:util.m80
if errorlevel == 1 goto error

%PLMBIN%\ASM80 :f1:vidasm.m80
if errorlevel == 1 goto error

%PLMBIN%\ASM80 :f1:stplay.m80
if errorlevel == 1 goto error

%PLMBIN%\PLM80 :f1:stcpl.plm DEBUG PAGEWIDTH(120)
if errorlevel == 1 goto error

echo ===========================================
echo = Yeehaw! All compiled! No Errors! Ready! =
echo ===========================================

pause
cls
@ECHO ON
%PLMBIN%\LINK :f1:stcpl.obj,:f1:util.obj,:f1:vidasm.obj,:f1:stplay.obj,:f1:keyb.obj,:f2:plm80.lib TO :f1:stcpl.lnk
%PLMBIN%\LOCATE :f1:stcpl.lnk TO :f1:stcpl.kz CODE(100H) STACKSIZE(100) MAP PRINT(:f1:stcpl.tra)
%PLMBIN%\OBJCPM :f1:stcpl.kz
@ECHO OFF

copy /b %SOURCES%\stcpl.com .\stcpl.com
if errorlevel == 1 goto error

:: copy to HDD image file, for emulator EMU80
:: if exist "D:\EMU80\PK8000\cf.cpm" %PLMBIN%\c8000w.exe -r "D:\EMU80\PK8000\cf.cpm" A: stcpl.com

goto end

:error
echo ######################################
echo ######################################
echo ######### AN ERROR OCCURED! ##########
echo ######################################
echo ######################################

:end
pause
del %SOURCES%\*.obj
del %SOURCES%\*.lst
del %SOURCES%\stcpl.kz
del %SOURCES%\stcpl.lnk
del %SOURCES%\stcpl.lin
del %SOURCES%\stcpl.sym
del %SOURCES%\stcpl.tra
del %SOURCES%\stcpl.com


:run
