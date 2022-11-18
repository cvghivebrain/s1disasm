@echo off

echo compress kosinski files - same on all revisions
for %%f in ("256x256 Mappings\*.unc") do "bin\kosinski_compress.exe" "%%f" "256x256 Mappings\%%~nf.kos"
for %%f in ("Graphics Kosinski\*.bin") do "bin\kosinski_compress.exe" "%%f" "Graphics Kosinski\%%~nf.kos"

rem success
exit 0
