@echo off

IF EXIST s1built.bin move /Y s1built.bin s1built.prev.bin >NUL
axm68k /m /k /p sonic.asm, s1built.bin >errors.txt, , sonic.lst
type errors.txt

IF NOT EXIST s1built.bin PAUSE & EXIT
fixheadr.exe s1built.bin
