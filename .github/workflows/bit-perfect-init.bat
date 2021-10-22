@echo off
cd "..\..\"

rem assemble Z80 sound driver - same on all revisions
axm68k /m /k /p "sound\DAC Driver.asm", "sound\DAC Driver.unc"
IF NOT EXIST "sound\DAC Driver.unc" EXIT 2

rem compress kosinski files - same on all revisions
for %%f in ("256x256 Mappings\*.unc") do kosinski_compress "%%f" "256x256 Mappings\%%~nf.kos"
kosinski_compress "Graphics - Compressed\Ending Flowers.unc" "Graphics - Compressed\Ending Flowers.kos"
kosinski_compress "sound\DAC Driver.unc" "sound\DAC Driver.kos"

rem success
exit 0
