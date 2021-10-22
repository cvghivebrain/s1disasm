@echo off
cd "..\..\"

echo assemble revision %1 rom
axm68k /e Revision=%1 /m /k /p sonic.asm, %1.bin

echo check for success and fix header
IF NOT EXIST %1.bin EXIT 2
fixheadr.exe %1.bin

echo check file content
fc /b %1.bin s1rev%1.bin > nul

echo delete the built rom
del %1.bin
exit errorlevel
