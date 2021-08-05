Sonic the Hedgehog (Mega Drive) Disassembly
===========================================

Differences with the disassembly on the [Sonic Retro Github page](https://github.com/sonicretro/s1disasm):

* __dma__ macro - Replaces writeVRAM and writeCRAM macros.
* __index__ & __ptr__ macros - Creates relative and absolute pointer lists; automatically generates id numbers.
* __mirror_index__ macro - Mirrors an existing pointer list, used to keep Sonic's mappings and DPLCs aligned.
* __objpos__ macro - Object placement in levels, also uses object ids instead of fixed numbers.
* __plcm__ macro - Generates tile ids for VRAM addresses (e.g. tile_Nem_Ring).
* __spritemap__ & __piece__ macros - Creates sprite mappings.
* Z80 macros - See [axm68k](https://github.com/cvghivebrain/axm68k).
* Different labels used for object status table.
  * Constants used for render flags.