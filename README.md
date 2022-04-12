Sonic the Hedgehog (Mega Drive) Disassembly
===========================================

Differences with the disassembly on the [Sonic Retro Github page](https://github.com/sonicretro/s1disasm):

* __dma__ macro - Replaces writeVRAM and writeCRAM macros.
* __gmptr__ macro - Generates ids for game modes.
* __index__ & __ptr__ macros - Creates relative and absolute pointer lists; automatically generates id numbers.
* __lsline__ macro - Allows level select menu strings to be stored as plain ascii.
* __mirror_index__ macro - Mirrors an existing pointer list, used to keep Sonic's mappings and DPLCs aligned.
* __nemesis__ & __nemfile__ macros - Records the file name and decompressed size of Nemesis-compressed art for VRAM management.
* __objpos__ macro - Object placement in levels, also uses object ids instead of fixed numbers.
* __plcm__ macro - Generates tile ids for VRAM addresses (e.g. tile_Nem_Ring). Automatically places graphics after previous graphics, if no VRAM address is specified.
* __spritemap__ & __piece__ macros - Creates sprite mappings.
* Z80 macros - See [axm68k](https://github.com/cvghivebrain/axm68k).
* Different labels used for object status table.
  * Constants used for render and status flags.
* Different labels used for some RAM addresses and routines.
  * Deprecated labels, as well as those from other games, are stored in [a compatibility file](Includes/Compatibility.asm).
* Automatic recompression of Kosinski-compressed data. Thanks to [Clownacy](https://github.com/Clownacy) for [the compressor](https://github.com/Clownacy/accurate-kosinski).
