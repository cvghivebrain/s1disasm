@echo off

echo assemble revision %1 rom
"bin\axm68k.exe" /e Revision=%1 /m /k /p _Main.asm, %1.bin

echo compress and insert DAC driver
"bin\DualPCM_Compress.exe" "sound\DAC Driver.unc" "sound\DAC Driver Offset & Size.dat" %1.bin "bin\kosinski_compress.exe"

echo check for success and fix header
IF NOT EXIST %1.bin EXIT 2
"bin\fixheadr.exe" %1.bin

echo check file content
fc /b %1.bin s1rev%1.bin > nul
exit %errorlevel%
