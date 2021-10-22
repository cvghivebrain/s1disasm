@echo off
cd "..\..\"

rem assemble rom
axm68k /e Revision=%1 /m /k /p sonic.asm, %1.bin

rem check for success and fix header
IF NOT EXIST %1.bin EXIT 2
fixheadr.exe %1.bin

rem check file content
fc /b %1.bin s1rev%1.bin > nul

rem delete the built rom
del %1.bin

rem return the value of the fc call
exit errorlevel
