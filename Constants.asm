; ---------------------------------------------------------------------------
; Constants
; ---------------------------------------------------------------------------

sizeof_ost:		equ $40

; VRAM data
vram_window:	equ $A000	; window namespace - unused
vram_fg:	equ $C000	; foreground namespace ($1000 bytes)
vram_bg:	equ $E000	; background namespace ($1000 bytes)
vram_sonic:	equ $F000	; Sonic graphics ($2E0 bytes)
vram_sprites:	equ $F800	; sprite table ($280 bytes)
vram_hscroll:	equ $FC00	; horizontal scroll table ($380 bytes)

; Levels
id_GHZ:		equ 0
id_LZ:		equ 1
id_MZ:		equ 2
id_SLZ:		equ 3
id_SYZ:		equ 4
id_SBZ:		equ 5
id_EndZ:	equ 6
id_SS:		equ 7

; Colours
cBlack:		equ $000		; colour black
cWhite:		equ $EEE		; colour white
cBlue:		equ $E00		; colour blue
cGreen:		equ $0E0		; colour green
cRed:		equ $00E		; colour red
cYellow:	equ cGreen+cRed		; colour yellow
cAqua:		equ cGreen+cBlue	; colour aqua
cMagenta:	equ cBlue+cRed		; colour magenta

; Joypad input
btnStart:	equ %10000000 ; Start button	($80)
btnA:		equ %01000000 ; A		($40)
btnC:		equ %00100000 ; C		($20)
btnB:		equ %00010000 ; B		($10)
btnR:		equ %00001000 ; Right		($08)
btnL:		equ %00000100 ; Left		($04)
btnDn:		equ %00000010 ; Down		($02)
btnUp:		equ %00000001 ; Up		($01)
btnDir:		equ %00001111 ; Any direction	($0F)
btnABC:		equ %01110000 ; A, B or C	($70)
bitStart:	equ 7
bitA:		equ 6
bitC:		equ 5
bitB:		equ 4
bitR:		equ 3
bitL:		equ 2
bitDn:		equ 1
bitUp:		equ 0

; Object variables
ost_render:		equ 1	; bitfield for x/y flip, display mode
	render_xflip:		equ 1	; xflip ; x flips sprites left facing or not
	render_yflip:		equ 2	; yflip
	render_rel:		equ 4	; relative screen position - coordinates are based on the level
	render_abs:		equ 0	; absolute screen position - coordinates are based on the screen (e.g. the HUD)
	render_bg:		equ 8	; align to background
	render_useheight:	equ $10	; use ost_height to decide if object is on screen, otherwise height is assumed to be $20 (used for large objects)
	render_rawmap:		equ $20	; sprites use raw mappings - i.e. object consists of a single sprite instead of multipart sprite mappings (e.g. broken block fragments)
	render_behind:		equ $40	; object is behind a loop (Sonic only)
	render_onscreen:	equ $80	; object is on screen
	render_xflip_bit:	equ 0
	render_yflip_bit:	equ 1
	render_rel_bit:		equ 2
	render_bg_bit:		equ 3
	render_useheight_bit:	equ 4
	render_rawmap_bit:	equ 5
	render_behind_bit:	equ 6
	render_onscreen_bit:	equ 7
ost_tile:		equ 2	; palette line & VRAM setting (2 bytes)
	tile_xflip:	equ $800
	tile_yflip:	equ $1000
	tile_pal1:	equ 0
	tile_pal2:	equ $2000
	tile_pal3:	equ $4000
	tile_pal4:	equ $6000
	tile_hi:	equ $8000
	tile_xflip_bit:	equ 3
	tile_yflip_bit:	equ 4
	tile_pal12_bit:	equ 5
	tile_pal34_bit:	equ 6
	tile_hi_bit:	equ 7
ost_mappings:		equ 4	; mappings address (4 bytes)
ost_x_pos:		equ 8	; x-axis position (2 bytes)
ost_x_sub:		equ $A	; x-axis subpixel position (2 bytes)
ost_y_screen:		equ $A	; y-axis position for screen-fixed items (2 bytes)
ost_y_pos:		equ $C	; y-axis position (2 bytes)
ost_y_sub:		equ $E	; y-axis subpixel position (2 bytes)
ost_x_vel:		equ $10	; x-axis velocity (2 bytes)
ost_y_vel:		equ $12	; y-axis velocity (2 bytes)
ost_inertia:		equ $14	; potential speed (2 bytes)
ost_height:		equ $16	; height/2
ost_width:		equ $17	; width/2
ost_priority:		equ $18	; sprite stack priority - 0 is highest, 7 is lowest
ost_actwidth:		equ $19	; action width/2
ost_frame:		equ $1A	; current frame displayed
ost_anim_frame:		equ $1B	; current frame in animation script
ost_anim:		equ $1C	; current animation
ost_anim_restart:	equ $1D	; restart animation flag / next animation number (Sonic)
ost_anim_time:		equ $1E	; time to next frame
ost_anim_delay:		equ $1F	; time to delay animation
ost_col_type:		equ $20	; collision response type
ost_col_property:	equ $21	; collision extra property
ost_status:		equ $22	; orientation or mode
	status_xflip:		equ 1	; xflip
	status_yflip:		equ 2	; yflip (objects only)
	status_air:		equ 2	; Sonic is in the air (Sonic only)
	status_jump:		equ 4	; jumping or rolling (Sonic only)
	status_platform:	equ 8	; Sonic is standing on this (objects) / Sonic is standing on object (Sonic)
	status_rolljump:	equ $10	; Sonic is jumping after rolling (Sonic only)
	status_pushing:		equ $20	; Sonic is pushing this (objects) / Sonic is pushing an object (Sonic)
	status_underwater:	equ $40	; Sonic is underwater (Sonic only)
	status_onscreen:	equ $80	; object is on-screen
	status_xflip_bit:	equ 0
	status_yflip_bit:	equ 1
	status_air_bit:		equ 1
	status_jump_bit:	equ 2
	status_platform_bit:	equ 3
	status_rolljump_bit:	equ 4
	status_pushing_bit:	equ 5
	status_underwater_bit:	equ 6
	status_onscreen_bit:	equ 7
ost_respawn:		equ $23	; respawn list index number
ost_routine:		equ $24	; routine number
ost_routine2:		equ $25	; secondary routine number
ost_solid:		equ $25 ; solid status flag
ost_angle:		equ $26	; angle
ost_subtype:		equ $28	; object subtype
ost_enemy_combo:	equ $3E	; number of enemies broken in a row (0-$A) (2 bytes)

; Object variables used by Sonic
ost_sonic_flash_time:	equ $30	; time Sonic flashes for after getting hit (2 bytes)
ost_sonic_inv_time:	equ $32	; time left for invincibility (2 bytes)
ost_sonic_shoe_time:	equ $34	; time left for speed shoes (2 bytes)
ost_sonic_angle_right:	equ $36 ; angle of floor on Sonic's right side
ost_sonic_angle_left:	equ $37 ; angle of floor on Sonic's left side
ost_sonic_sbz_disc:	equ $38 ; 1 if Sonic is stuck to SBZ disc

ost_sonic_restart_time:	equ $3A ; time until level restarts (2 bytes)
ost_sonic_jump:		equ $3C ; 1 if Sonic is jumping
ost_sonic_on_obj:	equ $3D	; OST index of object Sonic stands on
ost_sonic_lock_time:	equ $3E	; time left for locked controls, e.g. after hitting a spring (2 bytes)

; Animation flags
afEnd:		equ $FF	; return to beginning of animation
afBack:		equ $FE	; go back (specified number) bytes
afChange:	equ $FD	; run specified animation
afRoutine:	equ $FC	; increment routine counter
afReset:	equ $FB	; reset animation and 2nd object routine counter
af2ndRoutine:	equ $FA	; increment 2nd routine counter
afxflip:	equ $20
afyflip:	equ $40
SST_size = $40 ; the object size of every entry of an object 
