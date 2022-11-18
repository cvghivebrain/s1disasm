@echo off

rem compress kosinski files
for %%f in ("256x256 Mappings\*.unc") do "bin\kosinski_compress.exe" "%%f" "256x256 Mappings\%%~nf.kos"
for %%f in ("Graphics Kosinski\*.bin") do "bin\kosinski_compress.exe" "%%f" "Graphics Kosinski\%%~nf.kos"

rem assemble final rom
IF EXIST s1built.bin move /Y s1built.bin s1built.prev.bin >NUL
IF EXIST DAC Driver.unc move /Y DAC Driver.unc >NUL
"bin\axm68k.exe" /m /k /p _Main.asm, s1built.bin >errors.txt, , _Main.lst
type errors.txt
if not exist s1built.bin pause & exit

rem compress and insert DAC driver
"bin\DualPCM_Compress.exe" "sound\DAC Driver.unc" "sound\DAC Driver Offset & Size.dat" s1built.bin "bin\kosinski_compress.exe"

rem check for success and fix header
IF NOT EXIST s1built.bin PAUSE & EXIT 2
"bin\fixheadr.exe" s1built.bin
exit 0
