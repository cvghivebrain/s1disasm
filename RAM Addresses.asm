; ---------------------------------------------------------------------------
; RAM Addresses - Variables (v) and Flags (f)
; ---------------------------------------------------------------------------

		pusho		; save options
		opt	ae+	; enable auto evens

; Error trap variables:

v_reg_buffer:			equ $FFFFFC00 ; stores registers d0-a7 during an error event ($40 bytes) - v_respawn_list uses same space
v_sp_buffer:			equ $FFFFFC40 ; stores most recent sp address (4 bytes) - v_respawn_list uses same space
v_error_type:			equ $FFFFFC44 ; error type - v_respawn_list uses same space

; Major data blocks:

v_256x256_tiles:		equ   $FF0000 ; 256x256 tile mappings ($A400 bytes)
				rsset $FFFFA400
v_level_layout:			rs.b sizeof_level ; $FFFFA400 ; level and background layouts ($400 bytes)
v_bgscroll_buffer:		rs.b $200 ; $FFFFA800 ; background scroll buffer
v_nem_gfx_buffer:		rs.b $200 ; $FFFFAA00 ; Nemesis graphics decompression buffer
v_sprite_queue:			rs.b $400 ; $FFFFAC00 ; sprite display queue, in order of priority
v_16x16_tiles:			equ $FFFFB000 ; 16x16 tile mappings
v_sonic_gfx_buffer:		equ $FFFFC800 ; buffered Sonic graphics ($17 cells) ($2E0 bytes)
v_sonic_pos_tracker:		equ $FFFFCB00 ; earlier position tracking list for Sonic, used by invinciblity stars ($100 bytes)
v_hscroll_buffer:		equ $FFFFCC00 ; scrolling table data (actually $380 bytes, but $400 is reserved for it)
				rsset $FFFFD000
v_ost_all:			rs.b sizeof_ost*countof_ost ; $FFFFD000 ; object variable space ($40 bytes per object; $80 objects) ($2000 bytes)
	v_ost_player:		equ v_ost_all ; object variable space for Sonic ($40 bytes)
	; Title screen and intro
	v_ost_titlesonic:	equ v_ost_all+(sizeof_ost*1) ; title screen Sonic
	v_ost_psb:		equ v_ost_all+(sizeof_ost*2) ; title screen "Press Start Button"
	v_ost_tm:		equ v_ost_all+(sizeof_ost*3) ; title screen "TM"
	v_ost_titlemask:	equ v_ost_all+(sizeof_ost*4) ; title screen sprite mask
	; Intro/credits
	v_ost_credits:		equ v_ost_all+(sizeof_ost*2) ; "Sonic Team Presents" and credits text
	; Try again
	v_ost_endeggman:	equ v_ost_all+(sizeof_ost*2) ; ending/"Try Again" Eggman
	v_ost_tryagain:		equ v_ost_all+(sizeof_ost*3) ; "Try Again" text
	v_ost_tryag_emeralds:	equ v_ost_all+(sizeof_ost*$20) ; "Try Again" chaos emeralds
	; Continue
	v_ost_cont_text:	equ v_ost_all+(sizeof_ost*1) ; continue screen text
	v_ost_cont_oval:	equ v_ost_all+(sizeof_ost*2) ; continue screen oval
	v_ost_cont_minisonic:	equ v_ost_all+(sizeof_ost*3) ; continue screen mini Sonics
	; Level - no interaction with Sonic
	v_ost_hud:		equ v_ost_all+(sizeof_ost*1) ; HUD
	v_ost_titlecard1:	equ v_ost_all+(sizeof_ost*2) ; title card - zone name
	v_ost_titlecard2:	equ v_ost_all+(sizeof_ost*3) ; title card - "zone"
	v_ost_titlecard3:	equ v_ost_all+(sizeof_ost*4) ; title card - "act" 1/2/3
	v_ost_titlecard4:	equ v_ost_all+(sizeof_ost*5) ; title card - oval
	v_ost_gameover1:	equ v_ost_all+(sizeof_ost*2) ; game over card - "game"/"time"
	v_ost_gameover2:	equ v_ost_all+(sizeof_ost*3) ; game over card - "over"
	v_ost_shield:		equ v_ost_all+(sizeof_ost*6) ; shield
	v_ost_stars1:		equ v_ost_all+(sizeof_ost*8) ; invincibility stars
	v_ost_stars2:		equ v_ost_all+(sizeof_ost*9) ; invincibility stars
	v_ost_stars3:		equ v_ost_all+(sizeof_ost*$A) ; invincibility stars
	v_ost_stars4:		equ v_ost_all+(sizeof_ost*$B) ; invincibility stars
	v_ost_splash:		equ v_ost_all+(sizeof_ost*$C) ; splash
	v_ost_bubble:		equ v_ost_all+(sizeof_ost*$D) ; bubble from Sonic's mouth
	v_ost_end_emeralds:	equ v_ost_all+(sizeof_ost*$10) ; ending chaos emeralds
	v_ost_haspassed1:	equ v_ost_all+(sizeof_ost*$17) ; has passed act - "Sonic has"
	v_ost_haspassed2:	equ v_ost_all+(sizeof_ost*$18) ; has passed act - "passed"
	v_ost_haspassed3:	equ v_ost_all+(sizeof_ost*$19) ; has passed act - "act" 1/2/3
	v_ost_haspassed4:	equ v_ost_all+(sizeof_ost*$1A) ; has passed act - score
	v_ost_haspassed5:	equ v_ost_all+(sizeof_ost*$1B) ; has passed act - time bonus
	v_ost_haspassed6:	equ v_ost_all+(sizeof_ost*$1C) ; has passed act - ring bonus
	v_ost_haspassed7:	equ v_ost_all+(sizeof_ost*$1D) ; has passed act - oval
	v_ost_watersurface1:	equ v_ost_all+(sizeof_ost*$1E) ; LZ water surface
	v_ost_watersurface2:	equ v_ost_all+(sizeof_ost*$1F) ; LZ water surface
	; Special stage results
	v_ost_ssresult1:	equ v_ost_all+(sizeof_ost*$17) ; special stage results screen
	v_ost_ssresult2:	equ v_ost_all+(sizeof_ost*$18) ; special stage results screen
	v_ost_ssresult3:	equ v_ost_all+(sizeof_ost*$19) ; special stage results screen
	v_ost_ssresult4:	equ v_ost_all+(sizeof_ost*$1A) ; special stage results screen
	v_ost_ssresult5:	equ v_ost_all+(sizeof_ost*$1B) ; special stage results screen
	v_ost_ssres_emeralds:	equ v_ost_all+(sizeof_ost*$20) ; special stage results screen chaos emeralds
	; Level - can interact with Sonic
	v_ost_level_obj:	equ v_ost_all+(sizeof_ost*$20) ; level object variable space ($1800 bytes)
v_ost_end:			equ v_ost_all+(sizeof_ost*countof_ost) ; $FFFFF000

v_snddriver_ram:		rs.b v_snddriver_size ; $FFFFF000 ; start of RAM for the sound driver data ($5C0 bytes)
								; sound driver equates are now defined in "sound/Sound Equates.asm"

unused_f5c0:			rs.b $40 ; $FFFFF5C0 ; unused space (reserved for sound driver?)

; General variables:

v_gamemode:			rs.b 1 ; $FFFFF600 ; game mode (00=Sega; 04=Title; 08=Demo; 0C=Level; 10=SS; 14=Cont; 18=End; 1C=Credit; 8C=PreLevel)
unused_f601:			rs.b 1
v_joypad_hold:			rs.b 1 ; $FFFFF602 ; joypad input - held, can be overridden by demos
v_joypad_press:			rs.b 1 ; $FFFFF603 ; joypad input - pressed, can be overridden by demos
v_joypad_hold_actual:		rs.b 1 ; $FFFFF604 ; joypad input - held, actual
v_joypad_press_actual:		rs.b 1 ; $FFFFF605 ; joypad input - pressed, actual
v_joypad2_hold_actual:		rs.b 1 ; $FFFFF606 ; joypad 2 input - held, actual - unused
v_joypad2_press_actual:		rs.b 1 ; $FFFFF607 ; joypad 2 input - pressed, actual - unused
unused_f608:			rs.b 4
v_vdp_mode_buffer:		rs.w 1 ; $FFFFF60C ; VDP register $81 buffer - contains $8134 which is sent to vdp_control_port
unused_f60e:			rs.b 6
v_countdown:			rs.w 1 ; $FFFFF614 ; decrements every time VBlank runs, used as a general purpose timer
v_fg_y_pos_vsram:		rs.w 1 ; $FFFFF616 ; foreground y position, sent to VSRAM during VBlank
v_bg_y_pos_vsram:		rs.w 1 ; $FFFFF618 ; background y position, sent to VSRAM during VBlank
v_fg_x_pos_hscroll:		rs.w 1 ; $FFFFF61A ; foreground x position - unused
v_bg_x_pos_hscroll:		rs.w 1 ; $FFFFF61C ; background x position - unused
v_bg3_y_pos_copy_unused:	rs.w 1 ; $FFFFF61E ; copy of v_bg3_y_pos - unused
v_bg3_x_pos_copy_unused:	rs.w 1 ; $FFFFF620 ; copy of v_bg3_x_pos - unused
unused_f622:			rs.b 2
v_vdp_hint_counter:		rs.w 1 ; $FFFFF624 ; VDP register $8A buffer - horizontal interrupt counter ($8Axx)
v_vdp_hint_line:		equ v_vdp_hint_counter+1 ; screen line where water starts and palette is changed by HBlank
v_palfade_start:		rs.b 1 ; $FFFFF626 ; palette fading - start position in bytes
v_palfade_size:			rs.b 1 ; $FFFFF627 ; palette fading - number of colours
v_vblank_0e_counter:		rs.b 1 ; $FFFFF628 ; counter that increments when VBlank routine $E is run - unused
unused_f629:			rs.b 1
v_vblank_routine:		rs.b 1 ; $FFFFF62A ; VBlank routine counter
unused_f62b:			rs.b 1
v_spritecount:			rs.b 1 ; $FFFFF62C ; number of sprites on-screen
unused_f62d:			rs.b 5
v_palcycle_num:			rs.w 1 ; $FFFFF632 ; palette cycling - current index number
v_palcycle_time:		rs.w 1 ; $FFFFF634 ; palette cycling - time until the next change
v_random:			rs.l 1 ; $FFFFF636 ; pseudo random number generator result
f_pause:			rs.w 1 ; $FFFFF63A ; flag set to pause the game
unused_f63c:			rs.b 4
v_vdp_dma_buffer:		rs.w 1 ; $FFFFF640 ; VDP DMA command buffer
unused_f642:			rs.b 2
f_hblank_pal_change:		rs.w 1 ; $FFFFF644 ; flag set to change palette during HBlank (0000 = no; 0001 = change)
v_water_height_actual:		rs.w 1 ; $FFFFF646 ; water height, actual
v_water_height_normal:		rs.w 1 ; $FFFFF648 ; water height, ignoring wobble
v_water_height_next:		rs.w 1 ; $FFFFF64A ; water height, next target
v_water_direction:		rs.b 1 ; $FFFFF64C ; water setting - 0 = no water; 1 = water moves down; -1 = water moves up
v_water_routine:		rs.b 1 ; $FFFFF64D ; water event routine counter
f_water_pal_full:		rs.b 1 ; $FFFFF64E ; flag set when water covers the entire screen (00 = partly/all dry; 01 = all underwater)
f_hblank_run_snd:		rs.b 1 ; $FFFFF64F ; flag set when sound driver should be run from HBlank
v_palcycle_buffer:		rs.b $30 ; $FFFFF650 ; palette data buffer (used for palette cycling)
v_plc_buffer:			rs.b sizeof_plc*countof_plc ; $FFFFF680 ; pattern load cues buffer (maximum $10 PLCs) ($60 bytes)
v_plc_buffer_dest:		equ v_plc_buffer+4 ; VRAM destination for 1st item in PLC buffer (2 bytes)
v_nem_mode_ptr:			rs.l 1 ; $FFFFF6E0 ; pointer for nemesis decompression code ($1502 or $150C)
v_nem_repeat:			rs.l 1 ; $FFFFF6E4 ; Nemesis register buffer - d0: repeat counter
v_nem_pixel:			rs.l 1 ; $FFFFF6E8 ; Nemesis register buffer - d1: pixel value
v_nem_d2:			rs.l 1 ; $FFFFF6EC ; Nemesis register buffer - d2
v_nem_header:			rs.l 1 ; $FFFFF6F0 ; Nemesis register buffer - d5: 3rd & 4th bytes of Nemesis archive header
v_nem_shift:			rs.l 1 ; $FFFFF6F4 ; Nemesis register buffer - d6: shift value
v_nem_tile_count:		rs.w 1 ; $FFFFF6F8 ; number of 8x8 tiles in a Nemesis archive
v_nem_tile_count_frame:		rs.w 1 ; $FFFFF6FA ; number of 8x8 tiles to process in 1 frame

				rsset $FFFFF700
v_camera_x_pos:			rs.l 1 ; $FFFFF700 ; foreground camera x position
v_camera_y_pos:			rs.l 1 ; $FFFFF704 ; foreground camera y position
v_bg1_x_pos:			rs.l 1 ; $FFFFF708 ; background x position
v_bg1_y_pos:			rs.l 1 ; $FFFFF70C ; background y position
v_bg2_x_pos:			rs.l 1 ; $FFFFF710 ; background 2 x position (e.g. GHZ treeline)
v_bg2_y_pos:			rs.l 1 ; $FFFFF714 ; background 2 y position
v_bg3_x_pos:			rs.l 1 ; $FFFFF718 ; background 3 x position (e.g. GHZ mountains)
v_bg3_y_pos:			rs.l 1 ; $FFFFF71C ; background 3 y position
v_boundary_left_next:		rs.w 1 ; $FFFFF720 ; left level boundary, next (actual boundary shifts to match this)
v_boundary_right_next:		rs.w 1 ; $FFFFF722 ; right level boundary, next
v_boundary_top_next:		rs.w 1 ; $FFFFF724 ; top level boundary, next
v_boundary_bottom_next:		rs.w 1 ; $FFFFF726 ; bottom level boundary, next
v_boundary_left:		rs.w 1 ; $FFFFF728 ; left level boundary
v_boundary_right:		rs.w 1 ; $FFFFF72A ; right level boundary
v_boundary_top:			rs.w 1 ; $FFFFF72C ; top level boundary
v_boundary_bottom:		rs.w 1 ; $FFFFF72E ; bottom level boundary
v_boundary_unused:		rs.w 1 ; $FFFFF730 ; unused value from LevelSizeArray, always 4
v_boundary_left_unused:		rs.w 1 ; $FFFFF732 ; left level boundary plus $240 - unused
unused_f734:			rs.b 6
v_camera_x_diff:		rs.w 1 ; $FFFFF73A ; camera x position change since last frame * $100
v_camera_y_diff:		rs.w 1 ; $FFFFF73C ; camera y position change since last frame * $100
v_camera_y_shift:		rs.w 1 ; $FFFFF73E ; camera y position shift when Sonic looks up/down - $60 = default; $C8 = look up; 8 = look down
v_levelsizeload_unused_1:	rs.b 1 ; $FFFFF740
v_levelsizeload_unused_2:	rs.b 1 ; $FFFFF741
v_dle_routine:			rs.b 1 ; $FFFFF742 ; dynamic level event - routine counter
unused_f743:			rs.b 1
f_disable_scrolling:		rs.b 1 ; $FFFFF744 ; flag set to disable all scrolling and LZ water features
unused_f745:			rs.b 1
v_levelsizeload_unused_3:	rs.b 1 ; $FFFFF746
unused_f747:			rs.b 1
v_levelsizeload_unused_4:	rs.b 1 ; $FFFFF748
unused_f749:			rs.b 1
v_fg_x_redraw_flag:		rs.w 1 ; $FFFFF74A ; $10 when foreground camera x has moved 16 pixels and needs redrawing
v_fg_y_redraw_flag:		equ v_fg_x_redraw_flag+1 ; $10 when foreground camera y has moved 16 pixels and needs redrawing
v_bg1_x_redraw_flag:		rs.b 1 ; $FFFFF74C ; $10 when background x has moved 16 pixels and needs redrawing
v_bg1_y_redraw_flag:		rs.b 1 ; $FFFFF74D ; $10 when background y has moved 16 pixels and needs redrawing
v_bg2_x_redraw_flag:		rs.b 1 ; $FFFFF74E ; $10 when background 2 x has moved 16 pixels and needs redrawing
v_bg2_y_redraw_flag:		rs.b 1 ; $FFFFF74F ; $10 when background 2 y has moved 16 pixels and needs redrawing - unused
v_bg3_x_redraw_flag:		rs.b 1 ; $FFFFF750 ; $10 when background 3 x has moved 16 pixels and needs redrawing
v_bg3_y_redraw_flag:		rs.b 1 ; $FFFFF751 ; $10 when background 3 y has moved 16 pixels and needs redrawing - unused
unused_f752:			rs.b 2
v_fg_redraw_direction:		rs.b 1 ; $FFFFF754 ; 16x16 row redraw flag bitfield for foreground - 0 = top; 1 = bottom; 2 = left; 3 = right; 4 = top (all); 5 = bottom (all)
unused_f755:			rs.b 1
v_bg1_redraw_direction:		rs.b 1 ; $FFFFF756 ; 16x16 row redraw flag bitfield for background 1
unused_f757:			rs.b 1
v_bg2_redraw_direction:		rs.b 1 ; $FFFFF758 ; 16x16 row redraw flag bitfield for background 2
unused_f759:			rs.b 1
v_bg3_redraw_direction:		rs.b 1 ; $FFFFF75A ; 16x16 row redraw flag bitfield for background 3
unused_f75b:			rs.b 1
f_boundary_bottom_change:	rs.b 1 ; $FFFFF75C ; flag set when bottom level boundary is changing
unused_f75d:			rs.b 3
v_sonic_max_speed:		rs.w 1 ; $FFFFF760 ; Sonic's maximum speed
v_sonic_acceleration:		rs.w 1 ; $FFFFF762 ; Sonic's acceleration
v_sonic_deceleration:		rs.w 1 ; $FFFFF764 ; Sonic's deceleration
v_sonic_last_frame_id:		rs.b 1 ; $FFFFF766 ; Sonic's last frame id, compared with current frame to determine if graphics need updating
f_sonic_dma_gfx:		rs.b 1 ; $FFFFF767 ; flag set to DMA Sonic's graphics from RAM to VRAM
v_angle_right:			rs.b 1 ; $FFFFF768 ; angle of floor on Sonic's right side
unused_f769:			rs.b 1
v_angle_left:			rs.b 1 ; $FFFFF76A ; angle of floor on Sonic's left side
unused_f76b:			rs.b 1
v_opl_routine:			rs.b 1 ; $FFFFF76C ; ObjPosLoad - routine counter
unused_f76d:			rs.b 1
v_opl_screen_x_pos:		rs.w 1 ; $FFFFF76E ; ObjPosLoad - screen x position, rounded down to nearest $80
v_opl_ptr_right:		rs.l 1 ; $FFFFF770 ; ObjPosLoad - pointer to current objpos data
v_opl_ptr_left:			rs.l 1 ; $FFFFF774 ; ObjPosLoad - pointer to leftmost objpos data
v_opl_ptr_alt_right:		rs.l 1 ; $FFFFF778 ; ObjPosLoad - pointer to current secondary objpos data
v_opl_ptr_alt_left:		rs.l 1 ; $FFFFF77C ; ObjPosLoad - pointer to leftmost secondary objpos data
v_ss_angle:			rs.w 1 ; $FFFFF780 ; Special Stage angle
v_ss_rotation_speed:		rs.w 1 ; $FFFFF782 ; Special Stage rotation speed
unused_f784:			rs.b $C
v_demo_input_counter:		rs.w 1 ; $FFFFF790 ; tracks progress in the demo input data, increases by 2 when input changes
v_demo_input_time:		rs.b 1 ; $FFFFF792 ; time remaining for current demo "button press"
unused_f793:			rs.b 1
v_palfade_time:			rs.w 1 ; $FFFFF794 ; palette fading - time until next change
v_collision_index_ptr:		rs.l 1 ; $FFFFF796 ; ROM address for collision index of current level
v_palcycle_ss_num:		rs.w 1 ; $FFFFF79A ; palette cycling in Special Stage - current index number
v_palcycle_ss_time:		rs.w 1 ; $FFFFF79C ; palette cycling in Special Stage - time until next change
v_palcycle_ss_unused:		rs.w 1 ; $FFFFF79E ; palette cycling in Special Stage - unused offset value, always 0
v_ss_bg_mode:			rs.w 1 ; $FFFFF7A0 ; Special Stage fish/bird background animation mode
unused_f7a2:			rs.b 2
v_cstomp_y_pos:			rs.w 1 ; $FFFFF7A4 ; y position of MZ chain stomper, used for interaction with pushable green block
unused_f7a6:			rs.b 1
v_boss_status:			rs.b 1 ; $FFFFF7A7 ; status of boss and prison capsule - 01 = boss defeated; 02 = prison opened
v_sonic_pos_tracker_num:	rs.w 1 ; $FFFFF7A8 ; current location within position tracking data
v_sonic_pos_tracker_num_low:	equ v_sonic_pos_tracker_num+1
f_boss_boundary:		rs.b 1 ; $FFFFF7AA ; flag set to stop Sonic moving off the right side of the screen at a boss
unused_f7ab:			rs.b 1
v_256x256_with_loop_1:		rs.b 1 ; $FFFFF7AC ; 256x256 level tile which contains a loop (GHZ/SLZ)
v_256x256_with_loop_2:		rs.b 1 ; $FFFFF7AD ; 256x256 level tile which contains a loop (GHZ/SLZ)
v_256x256_with_tunnel_1:	rs.b 1 ; $FFFFF7AE ; 256x256 level tile which contains a roll tunnel (GHZ)
v_256x256_with_tunnel_2:	rs.b 1 ; $FFFFF7AF ; 256x256 level tile which contains a roll tunnel (GHZ)
v_levelani_0_frame:		rs.b 1 ; $FFFFF7B0 ; level graphics animation 0 - current frame
v_levelani_0_time:		rs.b 1 ; $FFFFF7B1 ; level graphics animation 0 - time until next frame
v_levelani_1_frame:		rs.b 1 ; $FFFFF7B2 ; level graphics animation 1 - current frame
v_levelani_1_time:		rs.b 1 ; $FFFFF7B3 ; level graphics animation 1 - time until next frame
v_levelani_2_frame:		rs.b 1 ; $FFFFF7B4 ; level graphics animation 2 - current frame
v_levelani_2_time:		rs.b 1 ; $FFFFF7B5 ; level graphics animation 2 - time until next frame
v_levelani_3_frame:		rs.b 1 ; $FFFFF7B6 ; level graphics animation 3 - current frame
v_levelani_3_time:		rs.b 1 ; $FFFFF7B7 ; level graphics animation 3 - time until next frame
v_levelani_4_frame:		rs.b 1 ; $FFFFF7B8 ; level graphics animation 4 - current frame
v_levelani_4_time:		rs.b 1 ; $FFFFF7B9 ; level graphics animation 4 - time until next frame
v_levelani_5_frame:		rs.b 1 ; $FFFFF7BA ; level graphics animation 5 - current frame
v_levelani_5_time:		rs.b 1 ; $FFFFF7BB ; level graphics animation 5 - time until next frame
unused_f7bc:			rs.b 2
v_giantring_gfx_offset:		rs.w 1 ; $FFFFF7BE ; address of art for next giant ring frame, relative to Art_BigRing (counts backwards from $C40; 0 means no more art)
f_convey_reverse:		rs.b 1 ; $FFFFF7C0 ; flag set to reverse conveyor belts in LZ/SBZ
v_convey_init_list:		rs.b 6 ; $FFFFF7C1 ; LZ/SBZ conveyor belt platform flags set when the parent object is loaded - 1 byte per conveyor set
f_water_tunnel_now:		rs.b 1 ; $FFFFF7C7 ; flag set when Sonic is in a LZ water tunnel
v_lock_multi:			rs.b 1 ; $FFFFF7C8 ; +1 = lock controls, lock Sonic's position & animation; +$80 = no collision with objects
f_water_tunnel_disable:		rs.b 1 ; $FFFFF7C9 ; flag set to disable LZ water tunnels
f_jump_only:			rs.b 1 ; $FFFFF7CA ; flag set to lock controls except jumping
f_stomp_sbz3_init:		rs.b 1 ; $FFFFF7CB ; flag set when huge sliding platform in SBZ3 is loaded
f_lock_controls:		rs.b 1 ; $FFFFF7CC ; flag set to lock player controls
f_giantring_collected:		rs.b 1 ; $FFFFF7CD ; flag set when Sonic collects a giant ring
f_fblock_finish:		rs.b 1 ; $FFFFF7CE ; flag set when FloatingBlock subtype $37 reaches its destination (REV01 only)
unused_f7cf:			rs.b 1
v_enemy_combo:			rs.w 1 ; $FFFFF7D0 ; number of enemies/blocks broken in a row, times 2
v_time_bonus:			rs.w 1 ; $FFFFF7D2 ; time bonus at the end of an act
v_ring_bonus:			rs.w 1 ; $FFFFF7D4 ; ring bonus at the end of an act
f_pass_bonus_update:		rs.b 1 ; $FFFFF7D6 ; flag set to update time/ring bonus at the end of an act
v_end_sonic_routine:		rs.b 1 ; $FFFFF7D7 ; routine counter for Sonic in the ending sequence
v_water_ripple_y_pos:		rs.w 1 ; $FFFFF7D8 ; y position of bg/fg water ripple effects; $80 added every frame, meaning high byte increments every 2 frames
unused_f7da:			rs.b 6
v_button_state:			rs.b $10 ; $FFFFF7E0 ; flags set when Sonic stands on a button
v_scroll_block_1_height:	rs.w 1 ; $FFFFF7F0 ; scroll block height - $70 for GHZ; $800 for all others
v_scroll_block_2_height:	rs.w 1 ; $FFFFF7F2 ; scroll block height - always $100, unused
v_scroll_block_3_height:	rs.w 1 ; $FFFFF7F4 ; scroll block height - always $100, unused
v_scroll_block_4_height:	rs.w 1 ; $FFFFF7F6 ; scroll block height - $100 for GHZ; 0 for all others, unused

v_sprite_buffer:		equ $FFFFF800 ; sprite table ($280 bytes, last $80 bytes are overwritten by v_pal_water_next)
				rsset $FFFFFA00
v_pal_water_next:		rs.w $10*4 ; $FFFFFA00 ; duplicate underwater palette, used for transitions
v_pal_water:			rs.w $10*4 ; $FFFFFA80 ; main underwater palette
v_pal_dry:			rs.w $10*4 ; $FFFFFB00 ; main palette
v_pal_dry_next:			rs.w $10*4 ; $FFFFFB80 ; duplicate palette, used for transitions
v_respawn_list:			rs.w $100 ; $FFFFFC00 ; object state list

v_stack:			equ $FFFFFD00 ; stack
v_stack_pointer:		equ $FFFFFE00 ; initial stack pointer - items are added to the stack backwards from this address

v_keep_after_reset:		equ $FFFFFE00 ; everything after this address is kept in RAM after a soft reset

				rsset $FFFFFE02
f_restart:			rs.w 1 ; $FFFFFE02 ; flag set to end/restart level
v_frame_counter:		rs.w 1 ; $FFFFFE04 ; frame counter, increments every frame
v_frame_counter_low:		equ v_frame_counter+1 ; low byte for frame counter
v_debug_item_index:		rs.b 1 ; $FFFFFE06 ; debug item currently selected (NOT the object id of the item)
unused_fe07:			rs.b 1
v_debug_active:			rs.w 1 ; $FFFFFE08 ; xx01 when debug mode is in use and Sonic is an item; 0 otherwise
v_debug_active_hi:		equ v_debug_active ; high byte of v_debug_active, routine counter for DebugMode (00/02)
v_debug_x_speed:		rs.b 1 ; $FFFFFE0A ; debug mode - horizontal speed
v_debug_y_speed:		rs.b 1 ; $FFFFFE0B ; debug mode - vertical speed
v_vblank_counter:		rs.l 1 ; $FFFFFE0C ; vertical interrupt counter, increments every VBlank
v_vblank_counter_word:		equ v_vblank_counter+2 ; low word for v_vblank_counter
v_vblank_counter_byte:		equ v_vblank_counter_word+1 ; low byte for v_vblank_counter
v_zone:				rs.b 1 ; $FFFFFE10 ; current zone number
v_act:				rs.b 1 ; $FFFFFE11 ; current act number
v_lives:			rs.b 1 ; $FFFFFE12 ; number of lives
unused_fe13:			rs.b 1
v_air:				rs.w 1 ; $FFFFFE14 ; air remaining while underwater (2 bytes)
v_last_ss_levelid:		rs.b 1 ; $FFFFFE16 ; level id of most recent special stage played
unused_fe17:			rs.b 1
v_continues:			rs.b 1 ; $FFFFFE18 ; number of continues
unused_fe19:			rs.b 1
f_time_over:			rs.b 1 ; $FFFFFE1A ; time over flag
v_ring_reward:			rs.b 1 ; $FFFFFE1B ; tracks which rewards have been given for rings - bit 0 = 50 rings (Special Stage); bit 1 = 100 rings; bit 2 = 200 rings
f_hud_lives_update:		rs.b 1 ; $FFFFFE1C ; lives counter update flag
v_hud_rings_update:		rs.b 1 ; $FFFFFE1D ; ring counter update flag - 1 = general update; $80 = reset to 0
f_hud_time_update:		rs.b 1 ; $FFFFFE1E ; time counter update flag
f_hud_score_update:		rs.b 1 ; $FFFFFE1F ; score counter update flag
v_rings:			rs.w 1 ; $FFFFFE20 ; rings
v_time:				rs.l 1 ; $FFFFFE22 ; time
v_time_min:			equ v_time+1 ; time - minutes
v_time_sec:			equ v_time+2 ; time - seconds
v_time_frames:			equ v_time+3 ; time - frames
v_score:			rs.l 1 ; $FFFFFE26 ; score
unused_fe2a:			rs.b 2
v_shield:			rs.b 1 ; $FFFFFE2C ; shield status - 00 = no; 01 = yes
v_invincibility:		rs.b 1 ; $FFFFFE2D ; invinciblity status - 00 = no; 01 = yes
v_shoes:			rs.b 1 ; $FFFFFE2E ; speed shoes status - 00 = no; 01 = yes
v_unused_powerup:		rs.b 1 ; $FFFFFE2F ; unused power up status
v_last_lamppost:		rs.b 1 ; $FFFFFE30 ; id of the last lamppost you hit

; Lamppost copied variables:

v_last_lamppost_lampcopy:	rs.b 1 ; $FFFFFE31 ; lamppost copy of v_last_lamppost
v_sonic_x_pos_lampcopy:		rs.w 1 ; $FFFFFE32 ; lamppost copy of Sonic's x position
v_sonic_y_pos_lampcopy:		rs.w 1 ; $FFFFFE34 ; lamppost copy of Sonic's y position
v_rings_lampcopy:		rs.w 1 ; $FFFFFE36 ; lamppost copy of v_rings
v_time_lampcopy:		rs.l 1 ; $FFFFFE38 ; lamppost copy of v_time
v_dle_routine_lampcopy:		rs.b 1 ; $FFFFFE3C ; lamppost copy of v_dle_routine
unused_fe3d:			rs.b 1
v_boundary_bottom_lampcopy:	rs.w 1 ; $FFFFFE3E ; lamppost copy of v_boundary_bottom
v_camera_x_pos_lampcopy:	rs.w 1 ; $FFFFFE40 ; lamppost copy of v_camera_x_pos
v_camera_y_pos_lampcopy:	rs.w 1 ; $FFFFFE42 ; lamppost copy of v_camera_y_pos
v_bg1_x_pos_lampcopy:		rs.w 1 ; $FFFFFE44 ; lamppost copy of v_bg1_x_pos
v_bg1_y_pos_lampcopy:		rs.w 1 ; $FFFFFE46 ; lamppost copy of v_bg1_y_pos
v_bg2_x_pos_lampcopy:		rs.w 1 ; $FFFFFE48 ; lamppost copy of v_bg2_x_pos
v_bg2_y_pos_lampcopy:		rs.w 1 ; $FFFFFE4A ; lamppost copy of v_bg2_y_pos
v_bg3_x_pos_lampcopy:		rs.w 1 ; $FFFFFE4C ; lamppost copy of v_bg3_x_pos
v_bg3_y_pos_lampcopy:		rs.w 1 ; $FFFFFE4E ; lamppost copy of v_bg3_y_pos
v_water_height_normal_lampcopy:	rs.w 1 ; $FFFFFE50 ; lamppost copy of v_water_height_normal
v_water_routine_lampcopy:	rs.b 1 ; $FFFFFE52 ; lamppost copy of v_water_routine
f_water_pal_full_lampcopy:	rs.b 1 ; $FFFFFE53 ; lamppost copy of f_water_pal_full
v_ring_reward_lampcopy:		rs.b 1 ; $FFFFFE54 ; lamppost copy of v_ring_reward
unused_fe55:			rs.b 2

v_emeralds:			rs.b 1 ; $FFFFFE57 ; number of chaos emeralds
v_emerald_list:			rs.b 6 ; $FFFFFE58 ; which individual emeralds you have, 1 byte per emerald - 00 = no; 01 = yes
v_oscillating_direction:	rs.w 1 ; $FFFFFE5E ; bitfield for the direction values in the table below are moving - 0 = up; 1 = down
v_oscillating_table:		rs.l $10 ; $FFFFFE60 ; table of 16 oscillating values, for platform movement - 1 word for rate, 1 word for current value
unused_fea0:			rs.b $20
v_syncani_0_time:		rs.b 1 ; $FFFFFEC0 ; synchronised sprite animation 0 - time until next frame
v_syncani_0_frame:		rs.b 1 ; $FFFFFEC1 ; synchronised sprite animation 0 - current frame
v_syncani_1_time:		rs.b 1 ; $FFFFFEC2 ; synchronised sprite animation 1 - time until next frame
v_syncani_1_frame:		rs.b 1 ; $FFFFFEC3 ; synchronised sprite animation 1 - current frame
v_syncani_2_time:		rs.b 1 ; $FFFFFEC4 ; synchronised sprite animation 2 - time until next frame
v_syncani_2_frame:		rs.b 1 ; $FFFFFEC5 ; synchronised sprite animation 2 - current frame
v_syncani_3_time:		rs.b 1 ; $FFFFFEC6 ; synchronised sprite animation 3 - time until next frame
v_syncani_3_frame:		rs.b 1 ; $FFFFFEC7 ; synchronised sprite animation 3 - current frame
v_syncani_3_accumulator:	rs.w 1 ; $FFFFFEC8 ; synchronised sprite animation 3 - v_syncani_3_time added to this value every frame
unused_feca:			rs.b $26
v_boundary_top_debugcopy:	rs.w 1 ; $FFFFFEF0 ; top level boundary, buffered while debug mode is in use
v_boundary_bottom_debugcopy:	rs.w 1 ; $FFFFFEF2 ; bottom level boundary, buffered while debug mode is in use
unused_fef4:			rs.b $1C

; Variables copied during VBlank and used by LoadTilesAsYouMove:

v_camera_x_pos_copy:		rs.l 1 ; $FFFFFF10 ; copy of v_camera_x_pos
v_camera_y_pos_copy:		rs.l 1 ; $FFFFFF14 ; copy of v_camera_y_pos
v_bg1_x_pos_copy:		rs.l 1 ; $FFFFFF18 ; copy of v_bg1_x_pos
v_bg1_y_pos_copy:		rs.l 1 ; $FFFFFF1C ; copy of v_bg1_y_pos
v_bg2_x_pos_copy:		rs.l 1 ; $FFFFFF20 ; copy of v_bg2_x_pos
v_bg2_y_pos_copy:		rs.l 1 ; $FFFFFF24 ; copy of v_bg2_y_pos
v_bg3_x_pos_copy:		rs.l 1 ; $FFFFFF28 ; copy of v_bg3_x_pos
v_bg3_y_pos_copy:		rs.l 1 ; $FFFFFF2C ; copy of v_bg3_y_pos
v_fg_redraw_direction_copy:	rs.w 1 ; $FFFFFF30 ; copy of v_fg_redraw_direction
v_bg1_redraw_direction_copy:	rs.w 1 ; $FFFFFF32 ; copy of v_bg1_redraw_direction
v_bg2_redraw_direction_copy:	rs.w 1 ; $FFFFFF34 ; copy of v_bg2_redraw_direction
v_bg3_redraw_direction_copy:	rs.w 1 ; $FFFFFF36 ; copy of v_bg3_redraw_direction
unused_ff38:			rs.b $48

v_levelselect_hold_delay:	rs.w 1 ; $FFFFFF80 ; level select - time until change when up/down is held
v_levelselect_item:		rs.w 1 ; $FFFFFF82 ; level select - item selected
v_levelselect_sound:		rs.w 1 ; $FFFFFF84 ; level select - sound selected
unused_ff86:			rs.b $3A
v_highscore:			rs.l 1 ; $FFFFFFC0 ; highest score so far (REV00 only)
v_score_next_life:		equ v_highscore	; points required for next extra life (REV01 only)
unused_ffc4:			rs.b $1C
f_levelselect_cheat:		rs.b 1 ; $FFFFFFE0 ; flag set when level select cheat has been entered
f_slowmotion_cheat:		rs.b 1 ; $FFFFFFE1 ; flag set when slow motion & frame advance cheat has been entered
f_debug_cheat:			rs.b 1 ; $FFFFFFE2 ; flag set when debug mode cheat has been entered
f_credits_cheat:		rs.b 1 ; $FFFFFFE3 ; flag set when hidden credits & press start cheat has been entered
v_title_d_count:		rs.w 1 ; $FFFFFFE4 ; number of times the d-pad is pressed on title screen, but only in the order UDLR
v_title_c_count:		rs.w 1 ; $FFFFFFE6 ; number of times C is pressed on title screen
unused_ffe8:			rs.b 2
v_title_unused:			rs.w 1 ; $FFFFFFEA
v_sonic_angle1_unused:		rs.b 1 ; $FFFFFFEC ; Sonic's direction of movement as an angle - unused
v_sonic_angle2_unused:		rs.b 1 ; $FFFFFFED ; v_sonic_angle1_unused-$20 - unused
v_sonic_angle3_unused:		rs.b 1 ; $FFFFFFEE ; v_sonic_angle2_unused&$C0 - unused
v_sonic_floor_dist_unused:	rs.b 1 ; $FFFFFFEF ; distance of Sonic from floor - unused
v_demo_mode:			rs.w 1 ; $FFFFFFF0 ; demo mode flag - 0 = no; 1 = yes; $8001 = ending
v_demo_num:			rs.w 1 ; $FFFFFFF2 ; demo level number (not the same as the level number)
v_credits_num:			rs.w 1 ; $FFFFFFF4 ; credits index number
unused_fff6:			rs.b 2
v_console_region:		rs.b 1 ; $FFFFFFF8 ; Mega Drive console type - 0 = JP; $80 = US/EU; +0 = NTSC; +$40 = PAL
unused_fff9:			rs.b 1
f_debug_enable:			rs.w 1 ; $FFFFFFFA ; flag set when debug mode is enabled (high byte is set to 1, but it's read as a word)
v_checksum_pass:		rs.l 1 ; $FFFFFFFC ; set to the text string "init" when checksum is passed

; Special Stages

v_ss_layout:			equ $FF0000 ; special stage layout with space added to top and sides
v_ss_enidec_buffer:		equ $FF0000 ; special stage background mappings are stored here before being moved to VRAM
v_ss_layout_buffer:		equ $FF4000 ; unprocessed special stage layout - overwritten later ($1000 bytes)
v_ss_sprite_info:		equ $FF4000 ; sprite info for each item type - mappings pointer (4 bytes); frame id (2 bytes); tile id (2 bytes) (total $278 bytes)
v_ss_sprite_update_list:	equ $FF4400 ; list of items currently being updated - 8 bytes each ($100 bytes)
v_ss_sprite_grid_plot:		equ $FFFF8000 ; x/y positions of cells in a 16x16 grid centered around Sonic, updates as it rotates ($400 bytes)
v_ss_bubble_x_pos:		equ $FFFFAA00 ; x position of background bubbles
v_ss_cloud_x_pos:		equ $FFFFAB00 ; x position of background clouds - 4 bytes per block, 7 blocks ($1C bytes)

		popo		; restore options
