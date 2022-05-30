@ECHO OFF
REM Set up
TITLE= Compiling %RELEASENAME% Masm32 - Release Tool
SET RELEASENAME=SND_RT
SET MASMBINPATH=\masm32\BIN
COLOR 1B


IF EXIST RELEASE\%RELEASENAME%.exe DEL RELEASE\%RELEASENAME%.exe
%MASMBINPATH%\ML /c /Cp /coff /Gz /nologo main.asm
%MASMBINPATH%\LINK /NOLOGO /OUT:RELEASE\%RELEASENAME%.exe /RELEASE /SUBSYSTEM:WINDOWS main.obj Rsrc\rsrc.res

DEL *.obj

ECHO.
PAUSE