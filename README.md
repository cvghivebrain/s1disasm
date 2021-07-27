Sonic the Hedgehog (Mega Drive) Disassembly
===========================================

Differences with the disassembly on the [Sonic Retro Github page](https://github.com/sonicretro/s1disasm):

* __index__ & __ptr__ macros - creates relative and absolute pointer lists; automatically generates id numbers
* __mirror_index__ macro - mirrors an existing pointer list, used to keep Sonic's mappings and DPLCs aligned
* __spritemap__ & __piece__ macros - creates sprite mappings
* Z80 macros - see [axm68k](https://github.com/cvghivebrain/axm68k)