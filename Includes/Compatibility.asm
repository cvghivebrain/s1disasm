; Sonic 1 Github
obRender:		equ ost_render
obGfx:			equ ost_tile
obMap:			equ ost_mappings
obX:			equ ost_x_pos
obScreenY:		equ ost_y_screen
obY:			equ ost_y_pos
obVelX:			equ ost_x_vel
obVelY:			equ ost_y_vel
obInertia:		equ ost_inertia
obWidth:		equ ost_width
obHeight:		equ ost_height
obPriority:		equ ost_priority
obActWid:		equ ost_displaywidth
obFrame:		equ ost_frame
obAniFrame:		equ ost_anim_frame
obAnim:			equ ost_anim
obNextAni:		equ ost_anim_restart
obTimeFrame:		equ ost_anim_time
obDelayAni:		equ ost_anim_delay
obColType:		equ ost_col_type
obColProp:		equ ost_col_property
obStatus:		equ ost_status
obRespawnNo:		equ ost_respawn
obRoutine:		equ ost_routine
ob2ndRout:		equ ost_routine2
obAngle:		equ ost_angle
obSubtype:		equ ost_subtype
obSolid:		equ ost_solid
v_256x256:		equ v_256x256_tiles
v_lvllayout:		equ v_level_layout
v_ngfx_buffer:		equ v_nem_gfx_buffer
v_spritequeue:		equ v_sprite_queue
v_16x16:		equ v_16x16_tiles
v_sgfx_buffer:		equ v_sonic_gfx_buffer
v_tracksonic:		equ v_sonic_pos_tracker
v_hscrolltablebuffer:	equ v_hscroll_buffer
v_objspace:		equ v_ost_all
v_player:		equ v_ost_player
v_lvlobjspace:		equ v_ost_level_obj
v_jpadhold2:		equ v_joypad_hold
v_jpadpress2:		equ v_joypad_press
v_jpadhold1:		equ v_joypad_hold_actual
v_jpadpress1:		equ v_joypad_press_actual
v_vdp_buffer1:		equ v_vdp_mode_buffer
v_demolength:		equ v_countdown
v_scrposy_dup:		equ v_fg_y_pos_vsram
v_scrposx_dup:		equ v_fg_x_pos_hscroll
v_hbla_hreg:		equ v_vdp_hint_counter
v_hbla_line:		equ v_vdp_hint_line
v_pfade_start:		equ v_palfade_start
v_pfade_size:		equ v_palfade_size
v_vbla_routine:		equ v_vblank_routine
v_pcyc_num:		equ v_palcycle_num
v_pcyc_time:		equ v_palcycle_time
v_vdp_buffer2:		equ v_vdp_dma_buffer
f_hbla_pal:		equ f_hblank_pal_change
v_waterpos1:		equ v_water_height_actual
v_waterpos2:		equ v_water_height_normal
v_waterpos3:		equ v_water_height_next
f_water:		equ v_water_direction
v_wtr_routine:		equ v_water_routine
f_wtr_state:		equ f_water_pal_full
v_pal_buffer:		equ v_palcycle_buffer
v_ptrnemcode:		equ v_nem_mode_ptr
f_plc_execute:		equ v_nem_tile_count
v_screenposx:		equ v_camera_x_pos
v_screenposy:		equ v_camera_y_pos
v_limitleft1:		equ v_boundary_left_next
v_limitright1:		equ v_boundary_right_next
v_limittop1:		equ v_boundary_top_next
v_limitbtm1:		equ v_boundary_bottom_next
v_limitleft2:		equ v_boundary_left
v_limitright2:		equ v_boundary_right
v_limittop2:		equ v_boundary_top
v_limitbtm2:		equ v_boundary_bottom
v_limitleft3:		equ v_boundary_left_unused
v_scrshiftx:		equ v_camera_x_diff
v_lookshift:		equ v_camera_y_shift
f_nobgscroll:		equ f_disable_scrolling
v_bgscroll1:		equ v_fg_redraw_direction
v_bgscroll2:		equ v_bg1_redraw_direction
v_bgscroll3:		equ v_bg2_redraw_direction
f_bgscrollvert:		equ f_boundary_bottom_change
v_sonspeedmax:		equ v_sonic_max_speed
v_sonspeedacc:		equ v_sonic_acceleration
v_sonspeeddec:		equ v_sonic_deceleration
v_sonframenum:		equ v_sonic_last_frame_id
f_sonframechg:		equ f_sonic_dma_gfx
v_anglebuffer:		equ v_angle_right
v_opl_screen:		equ v_opl_screen_x_pos
v_opl_data:		equ v_opl_ptr_right
v_ssangle:		equ v_ss_angle
v_ssrotate:		equ v_ss_rotation_speed
v_btnpushtime1:		equ v_demo_input_counter
v_btnpushtime2:		equ v_demo_input_time
v_palchgspeed:		equ v_palfade_time
v_collindex:		equ v_collision_index_ptr
v_palss_num:		equ v_palcycle_ss_num
v_palss_time:		equ v_palcycle_ss_time
v_obj31ypos:		equ v_cstomp_y_pos
v_bossstatus:		equ v_boss_status
v_trackpos:		equ v_sonic_pos_tracker_num
v_trackbyte:		equ v_sonic_pos_tracker_num_low
f_lockscreen:		equ f_boss_boundary
v_256loop1:		equ v_256x256_with_loop_1
v_256loop2:		equ v_256x256_with_loop_2
v_256roll1:		equ v_256x256_with_tunnel_1
v_256roll2:		equ v_256x256_with_tunnel_2
v_lani0_frame:		equ v_levelani_0_frame
v_lani0_time:		equ v_levelani_0_time
v_lani1_frame:		equ v_levelani_1_frame
v_lani1_time:		equ v_levelani_1_time
v_lani2_frame:		equ v_levelani_2_frame
v_lani2_time:		equ v_levelani_2_time
v_lani3_frame:		equ v_levelani_3_frame
v_lani3_time:		equ v_levelani_3_time
v_lani4_frame:		equ v_levelani_4_frame
v_lani4_time:		equ v_levelani_4_time
v_lani5_frame:		equ v_levelani_5_frame
v_lani5_time:		equ v_levelani_5_time
v_gfxbigring:		equ v_giantring_gfx_offset
f_conveyrev:		equ f_convey_reverse
v_obj63:		equ v_convey_init_list
f_wtunnelmode:		equ f_water_tunnel_now
f_lockmulti:		equ v_lock_multi
f_wtunnelallow:		equ f_water_tunnel_disable
f_jumponly:		equ f_jump_only
v_obj6B:		equ f_stomp_sbz3_init
f_lockctrl:		equ f_lock_controls
f_bigring:		equ f_giantring_collected
v_itembonus:		equ v_enemy_combo
v_timebonus:		equ v_time_bonus
v_ringbonus:		equ v_ring_bonus
f_endactbonus:		equ f_pass_bonus_update
v_sonicend:		equ v_end_sonic_routine
f_switch:		equ v_button_state
v_spritetablebuffer:	equ v_sprite_buffer
v_pal_water_dup:	equ v_pal_water_next
v_pal_dry_dup:		equ v_pal_dry_next
v_objstate:		equ v_respawn_list
v_framecount:		equ v_frame_counter
v_framebyte:		equ v_frame_counter_low
v_debugitem:		equ v_debug_item_index
v_debuguse:		equ v_debug_active
v_debugxspeed:		equ v_debug_move_delay
v_debugyspeed:		equ v_debug_move_speed
v_vbla_count:		equ v_vblank_counter
v_vbla_word:		equ v_vblank_counter_word
v_vbla_byte:		equ v_vblank_counter_byte
v_airbyte:		equ v_air+1
v_lastspecial:		equ v_last_ss_levelid
f_timeover:		equ f_time_over
v_lifecount:		equ v_ring_reward
f_lifecount:		equ f_hud_lives_update
f_ringcount:		equ v_hud_rings_update
f_timecount:		equ f_hud_time_update
f_scorecount:		equ f_hud_score_update
v_ringbyte:		equ v_rings+1
v_timemin:		equ v_time_min
v_timesec:		equ v_time_sec
v_timecent:		equ v_time_frames
v_invinc:		equ v_invincibility
v_lastlamp:		equ v_last_lamppost
v_lamp_xpos:		equ v_sonic_x_pos_lampcopy
v_lamp_ypos:		equ v_sonic_y_pos_lampcopy
v_lamp_rings:		equ v_rings_lampcopy
v_lamp_time:		equ v_time_lampcopy
v_lamp_dle:		equ v_dle_routine_lampcopy
v_lamp_limitbtm:	equ v_boundary_bottom_lampcopy
v_lamp_scrx:		equ v_camera_x_pos_lampcopy
v_lamp_scry:		equ v_camera_y_pos_lampcopy
v_lamp_wtrpos:		equ v_water_height_normal_lampcopy
v_lamp_wtrrout:		equ v_water_routine_lampcopy
v_lamp_wtrstat:		equ f_water_pal_full_lampcopy
v_lamp_lives:		equ v_ring_reward_lampcopy
v_emldlist:		equ v_emerald_list
v_oscillate:		equ v_oscillating_direction
v_ani0_time:		equ v_syncani_0_time
v_ani0_frame:		equ v_syncani_0_frame
v_ani1_time:		equ v_syncani_1_time
v_ani1_frame:		equ v_syncani_1_frame
v_ani2_time:		equ v_syncani_2_time
v_ani2_frame:		equ v_syncani_2_frame
v_ani3_time:		equ v_syncani_3_time
v_ani3_frame:		equ v_syncani_3_frame
v_ani3_buf:		equ v_syncani_3_accumulator
v_limittopdb:		equ v_boundary_top_debugcopy
v_limitbtmdb:		equ v_boundary_bottom_debugcopy
v_levseldelay:		equ v_levelselect_hold_delay
v_levselitem:		equ v_levelselect_item
v_levselsound:		equ v_levelselect_sound
v_scorecopy:		equ v_highscore
v_scorelife:		equ v_score_next_life
f_levselcheat:		equ f_levelselect_cheat
f_slomocheat:		equ f_slowmotion_cheat
f_debugcheat:		equ f_debug_cheat
f_creditscheat:		equ f_credits_cheat
v_title_dcount:		equ v_title_d_count
v_title_ccount:		equ v_title_c_count
f_demo:			equ v_demo_mode
v_demonum:		equ v_demo_num
v_creditsnum:		equ v_credits_num
v_megadrive:		equ v_console_region
f_debugmode:		equ f_debug_enable
v_init:			equ v_checksum_pass
;AddPoints
;AnimateSprite
;CalcSine
;CalcAngle
ChkObjectVisible:	equ CheckOffScreen
ChkPartiallyVisible:	equ CheckOffScreen_Wide
;CollectRing
;DebugMode
;DeleteObject
;DeleteChild
RememberState:		equ DespawnObject
PlatformObject:		equ DetectPlatform
;Plat_NoXCheck
Platform3:		equ Plat_NoXCheck_AltY
loc_74AE:		equ Plat_NoCheck
;DisplaySprite
DisplaySprite1:		equ DisplaySprite_a1
;ExitPlatform
;ExitPlatform2
ObjFloorDist:		equ FindFloorObj
ObjFloorDist2:		equ FindFloorObj2
ObjHitWallRight:	equ FindWallRightObj
ObjHitCeiling:		equ FindCeilingObj
ObjHitWallLeft:		equ FindWallLeftObj
;FindFreeObj
;FindNextFreeObj
;FindNearestTile
;FindFloor
;FindFloor2
;FindWall
;FindWall2
MvSonicOnPtfm:		equ MoveWithPlatform
MvSonicOnPtfm2:		equ MoveWithPlatform2
;ObjectFall
;SpeedToPos
;RandomNumber
;ReactToItem
;HurtSonic
;KillSonic
;ResumeMusic
;SlopeObject
SlopeObject2:		equ SlopeObject_NoChk
;SolidObject
SolidObject71:		equ SolidObject_NoRenderChk
SolidObject2F:		equ SolidObject_Heightmap
;SmashObject
;Sonic_Main
;Sonic_Control
;Sonic_Hurt
;Sonic_Death
;Sonic_ResetLevel
Sonic_MdNormal:		equ Sonic_Mode_Normal
Sonic_MdJump:		equ Sonic_Mode_Air
Sonic_MdRoll:		equ Sonic_Mode_Roll
Sonic_MdJump2:		equ Sonic_Mode_Jump
;Sonic_Display
;Sonic_RecordPosition
;Sonic_Water
;Sonic_Animate
Sonic_Loops:		equ Sonic_LoopPlane
;Sonic_LoadGfx
;Sonic_Jump
;Sonic_SlopeResist
;Sonic_Move
;Sonic_Roll
;Sonic_LevelBound
;Sonic_AnglePos
;Sonic_SlopeRepel
;Sonic_JumpHeight
;Sonic_JumpDirection
;Sonic_JumpAngle
Sonic_Floor:		equ Sonic_JumpCollision
;Sonic_RollRepel
;Sonic_RollSpeed
;Sonic_ResetOnFloor
;Sonic_HurtStop
;GameOver
;Sonic_Angle
;Sonic_WalkVertR
;Sonic_WalkCeiling
;Sonic_WalkVertL
Sonic_WalkSpeed:	equ Sonic_CalcRoomAhead
sub_14D48:		equ Sonic_CalcHeadroom
Sonic_HitFloor:		equ Sonic_FindFloor
loc_14DF0:		equ Sonic_FindFloor_Quick
loc_14E0A:		equ Sonic_SnapAngle
sub_14E50:		equ Sonic_FindWallRight
sub_14EB4:		equ Sonic_FindWallRight_Quick_UsePos
loc_14EBC:		equ Sonic_FindWallRight_Quick
Sonic_DontRunOnWalls:	equ Sonic_FindCeiling
loc_14F7C:		equ Sonic_FindCeiling_Quick
loc_14FD6:		equ Sonic_FindWallLeft
Sonic_HitWall:		equ Sonic_FindWallLeft_Quick_UsePos
loc_1504A:		equ Sonic_FindWallLeft_Quick

; Sonic 1 2005
ChkObjOnScreen:		equ CheckOffScreen
ChkObjOnScreen2:	equ CheckOffScreen_Wide
DeleteObject2:		equ DeleteChild
MarkObjGone:		equ DespawnObject
Platform2:		equ Plat_NoXCheck
DisplaySprite2:		equ DisplaySprite_a1
ObjHitFloor:		equ FindFloorObj
ObjHitFloor2:		equ FindFloorObj2
SingleObjLoad:		equ FindFreeObj
SingleObjLoad2:		equ FindNextFreeObj
Floor_ChkTile:		equ FindNearestTile
TouchResponse:		equ ReactToItem
Obj01_Main:		equ Sonic_Main
Obj01_Control:		equ Sonic_Control
Obj01_Hurt:		equ Sonic_Hurt
Obj01_Death:		equ Sonic_Death
Obj01_ResetLevel:	equ Sonic_ResetLevel
Obj01_MdNormal:		equ Sonic_Mode_Normal
Obj01_MdJump:		equ Sonic_Mode_Air
Obj01_MdRoll:		equ Sonic_Mode_Roll
Obj01_MdJump2:		equ Sonic_Mode_Jump
Sonic_RecordPos:	equ Sonic_RecordPosition
LoadSonicDynPLC:	equ Sonic_LoadGfx
Sonic_ChgJumpDir:	equ Sonic_JumpDirection

; Sonic 1 2021
ost_actwidth:		equ ost_displaywidth

; Sonic 2 Github
id:			equ ost_id
render_flags:		equ ost_render
art_tile:		equ ost_tile
mappings:		equ ost_mappings
x_pos:			equ ost_x_pos
x_sub:			equ ost_x_sub
y_pos:			equ ost_y_pos
y_sub:			equ ost_y_sub
priority:		equ ost_priority
width_pixels:		equ ost_displaywidth
mapping_frame:		equ ost_frame
x_vel:			equ ost_x_vel
y_vel:			equ ost_y_vel
y_radius:		equ ost_height
x_radius:		equ ost_width
anim_frame:		equ ost_anim_frame
anim:			equ ost_anim
prev_anim:		equ ost_anim_restart
anim_frame_duration:	equ ost_anim_time
status:			equ ost_status
routine:		equ ost_routine
routine_secondary:	equ ost_routine2
angle:			equ ost_angle
collision_flags:	equ ost_col_type
collision_property:	equ ost_col_property
respawn_index:		equ ost_respawn
subtype:		equ ost_subtype
inertia:		equ ost_inertia
flip_angle:		equ ost_angle+1
air_left:		equ ost_subtype
flip_turned:		equ $29
obj_control:		equ $2A
status_secondary:	equ $2B
flips_remaining:	equ $2C
flip_speed:		equ $2D
move_lock:		equ $2E
invulnerable_time:	equ ost_sonic_flash_time
invincibility_time:	equ ost_sonic_inv_time
speedshoes_time:	equ ost_sonic_shoe_time
next_tilt:		equ ost_sonic_angle_right
tilt:			equ ost_sonic_angle_left
stick_to_convex:	equ ost_sonic_sbz_disc
spindash_flag:		equ $39
pinball_mode:		equ spindash_flag
spindash_counter:	equ ost_sonic_restart_time
restart_countdown:	equ ost_sonic_restart_time
jumping:		equ ost_sonic_jump
interact:		equ ost_sonic_on_obj
top_solid_bit:		equ $3E
lrb_solid_bit:		equ $3F
y_pixel:		equ ost_y_screen
x_pixel:		equ ost_x_pos
parent:			equ $3E
button_up:		equ bitUp
button_down:		equ bitDn
button_left:		equ bitL
button_right:		equ bitR
button_B:		equ bitB
button_C:		equ bitC
button_A:		equ bitA
button_start:		equ bitStart
button_up_mask:		equ btnUp
button_down_mask:	equ btnDn
button_left_mask:	equ btnL
button_right_mask:	equ btnR
button_B_mask:		equ btnB
button_C_mask:		equ btnC
button_A_mask:		equ btnA
button_start_mask:	equ btnStart
object_size		equ sizeof_ost
next_object		equ sizeof_ost
Chunk_Table:		equ v_256x256_tiles
Level_Layout:		equ v_level_layout
Block_Table:		equ v_16x16_tiles
Object_RAM:		equ v_ost_all
MainCharacter:		equ v_ost_player
Horiz_Scroll_Buf:	equ v_hscroll_buffer
Sonic_Pos_Record_Buf:	equ v_sonic_pos_tracker
Camera_X_pos:		equ v_camera_x_pos
Camera_Y_pos:		equ v_camera_y_pos
Camera_BG_X_pos:	equ v_bg1_x_pos
Camera_BG_Y_pos:	equ v_bg1_y_pos
Camera_BG2_X_pos:	equ v_bg2_x_pos
Camera_BG2_Y_pos:	equ v_bg2_y_pos
Camera_BG3_X_pos:	equ v_bg3_x_pos
Camera_BG3_Y_pos:	equ v_bg3_y_pos
Horiz_block_crossed_flag:	equ v_fg_x_redraw_flag
Verti_block_crossed_flag:	equ v_fg_y_redraw_flag
Horiz_block_crossed_flag_BG:	equ v_bg1_x_redraw_flag
Verti_block_crossed_flag_BG:	equ v_bg1_y_redraw_flag
Horiz_block_crossed_flag_BG2:	equ v_bg2_x_redraw_flag
Scroll_flags:		equ v_fg_redraw_direction
Scroll_flags_BG:	equ v_bg1_redraw_direction
Scroll_flags_BG2:	equ v_bg2_redraw_direction
Scroll_flags_BG3:	equ v_bg3_redraw_direction
Camera_X_pos_diff:	equ v_camera_x_diff
Camera_Y_pos_diff:	equ v_camera_y_diff
Camera_Max_Y_pos:	equ v_boundary_bottom_next
Camera_Min_X_pos:	equ v_boundary_left_next
Camera_Max_X_pos:	equ v_boundary_right_next
Camera_Min_Y_pos:	equ v_boundary_top_next
Camera_Max_Y_pos_now:	equ v_boundary_bottom
Sonic_Pos_Record_Index:	equ v_sonic_pos_tracker_num
Camera_Y_pos_bias:	equ v_camera_y_shift
Deform_lock:		equ f_disable_scrolling
Camera_Max_Y_Pos_Changing:	equ f_boundary_bottom_change
Dynamic_Resize_Routine:	equ v_dle_routine
Underwater_target_palette:	equ v_pal_water_next
Underwater_target_palette_line2:	equ v_pal_water_next+sizeof_pal
Underwater_target_palette_line3:	equ v_pal_water_next+(sizeof_pal*2)
Underwater_target_palette_line4:	equ v_pal_water_next+(sizeof_pal*3)
Underwater_palette:	equ v_pal_water
Underwater_palette_line2:	equ v_pal_water_line2
Underwater_palette_line3:	equ v_pal_water_line3
Underwater_palette_line4:	equ v_pal_water_line4
Game_Mode:		equ v_gamemode
Ctrl_1_Logical:		equ v_joypad_hold
Ctrl_1_Held_Logical:	equ v_joypad_hold
Ctrl_1_Press_Logical:	equ v_joypad_press
Ctrl_1:			equ v_joypad_hold_actual
Ctrl_1_Held:		equ v_joypad_hold_actual
Ctrl_1_Press:		equ v_joypad_press_actual
Ctrl_2:			equ v_joypad2_hold_actual
Ctrl_2_Held:		equ v_joypad2_hold_actual
Ctrl_2_Press:		equ v_joypad2_press_actual
VDP_Reg1_val:		equ v_vdp_mode_buffer
Demo_Time_left:		equ v_countdown
Vscroll_Factor:		equ v_fg_y_pos_vsram
Vscroll_Factor_FG:	equ v_fg_y_pos_vsram
Vscroll_Factor_BG:	equ v_bg_y_pos_vsram
Palette_fade_range:	equ v_palfade_start
Palette_fade_start:	equ v_palfade_start
Palette_fade_length:	equ v_palfade_size
VIntSubE_RunCount:	equ v_vblank_0e_counter
Vint_routine:		equ v_vblank_routine
Sprite_count:		equ v_spritecount
PalCycle_Frame:		equ v_palcycle_num
PalCycle_Timer:		equ v_palcycle_time
RNG_seed:		equ v_random
Game_paused:		equ f_pause
DMA_data_thunk:		equ v_vdp_dma_buffer
Hint_flag:		equ f_hblank_pal_change
Water_Level_1:		equ v_water_height_actual
Water_Level_2:		equ v_water_height_normal
Water_Level_3:		equ v_water_height_next
Water_on:		equ v_water_direction
Water_routine:		equ v_water_routine
Water_fullscreen_flag:	equ f_water_pal_full
Do_Updates_in_H_int:	equ f_hblank_run_snd
Plc_Buffer:		equ v_plc_buffer
Plc_Buffer_Reg0:	equ v_nem_mode_ptr
Plc_Buffer_Reg4:	equ v_nem_repeat
Plc_Buffer_Reg8:	equ v_nem_pixel
Plc_Buffer_RegC:	equ v_nem_d2
Plc_Buffer_Reg10:	equ v_nem_header
Plc_Buffer_Reg14:	equ v_nem_shift
Plc_Buffer_Reg18:	equ v_nem_tile_count
Plc_Buffer_Reg1A:	equ v_nem_tile_count_frame
Sonic_top_speed:	equ v_sonic_max_speed
;Sonic_acceleration:	equ v_sonic_acceleration
;Sonic_deceleration:	equ v_sonic_deceleration
Sonic_LastLoadedDPLC:	equ v_sonic_last_frame_id
Primary_Angle:		equ v_angle_right
Secondary_Angle:	equ v_angle_left
Obj_placement_routine:	equ v_opl_routine
Camera_X_pos_last:	equ v_opl_screen_x_pos
Obj_load_addr_right:	equ v_opl_ptr_right
Obj_load_addr_left:	equ v_opl_ptr_left
Obj_load_addr_2:	equ v_opl_ptr_alt_right
Obj_load_addr_3:	equ v_opl_ptr_alt_left
Demo_button_index:	equ v_demo_input_counter
Demo_press_counter:	equ v_demo_input_time
PalChangeSpeed:		equ v_palfade_time
Collision_addr:		equ v_collision_index_ptr
Boss_defeated_flag:	equ v_boss_status
BigRingGraphics:	equ v_giantring_gfx_offset
WindTunnel_flag:	equ f_water_tunnel_now
WindTunnel_holding_flag:	equ f_water_tunnel_disable
Control_Locked:		equ f_lock_controls
Chain_Bonus_counter:	equ v_enemy_combo
Bonus_Countdown_1:	equ v_time_bonus
Update_Bonus_score:	equ f_pass_bonus_update
ButtonVine_Trigger:	equ v_button_state
Sprite_Table:		equ v_sprite_buffer
Normal_palette:		equ v_pal_dry
Normal_palette_line2:	equ v_pal_dry_line2
Normal_palette_line3:	equ v_pal_dry_line3
Normal_palette_line4:	equ v_pal_dry_line4
Target_palette:		equ v_pal_dry_next
Target_palette_line2:	equ v_pal_dry_next+sizeof_pal
Target_palette_line3:	equ v_pal_dry_next+(sizeof_pal*2)
Target_palette_line4:	equ v_pal_dry_next+(sizeof_pal*3)
Object_Respawn_Table:	equ v_respawn_list
Obj_respawn_index:	equ v_respawn_list
Obj_respawn_data:	equ v_respawn_list+2
System_Stack:		equ v_stack
Timer_frames:		equ v_frame_counter
Debug_object:		equ v_debug_item_index
Debug_placement_mode:	equ v_debug_active
Debug_Accel_Timer:	equ v_debug_move_delay
Debug_Speed:		equ v_debug_move_speed
Vint_runcount:		equ v_vblank_counter
Current_ZoneAndAct:	equ v_zone
Current_Zone:		equ v_zone
Current_Act:		equ v_act
Life_count:		equ v_lives
Continue_count:		equ v_continues
Time_Over_flag:		equ f_time_over
Extra_life_flags:	equ v_ring_reward
Update_HUD_lives:	equ f_hud_lives_update
Update_HUD_rings:	equ v_hud_rings_update
Update_HUD_timer:	equ f_hud_time_update
Update_HUD_score:	equ f_hud_score_update
Ring_count:		equ v_rings
Timer:			equ v_time
Timer_minute_word:	equ v_time
Timer_minute:		equ v_time_min
Timer_second:		equ v_time_sec
Timer_centisecond:	equ v_time_frames
Timer_frame:		equ v_time_frames
Score:			equ v_score
Last_star_pole_hit:	equ v_last_lamppost
Saved_Last_star_pole_hit:	equ v_last_lamppost_lampcopy
Saved_x_pos:		equ v_sonic_x_pos_lampcopy
Saved_y_pos:		equ v_sonic_y_pos_lampcopy
Saved_Ring_count:	equ v_rings_lampcopy
Saved_Timer:		equ v_time_lampcopy
Saved_Camera_X_pos:	equ v_camera_x_pos_lampcopy
Saved_Camera_Y_pos:	equ v_camera_y_pos_lampcopy
Saved_Camera_BG_X_pos:	equ v_bg1_x_pos_lampcopy
Saved_Camera_BG_Y_pos:	equ v_bg1_y_pos_lampcopy
Saved_Camera_BG2_X_pos:	equ v_bg2_x_pos_lampcopy
Saved_Camera_BG2_Y_pos:	equ v_bg2_y_pos_lampcopy
Saved_Camera_BG3_X_pos:	equ v_bg3_x_pos_lampcopy
Saved_Camera_BG3_Y_pos:	equ v_bg3_y_pos_lampcopy
Saved_Water_Level:	equ v_water_height_normal_lampcopy
Saved_Water_routine:	equ v_water_routine_lampcopy
Saved_Water_move:	equ f_water_pal_full_lampcopy
Saved_Extra_life_flags:	equ v_ring_reward_lampcopy
Saved_Camera_Max_Y_pos:	equ v_boundary_bottom_lampcopy
Saved_Dynamic_Resize_Routine:	equ v_dle_routine_lampcopy
Oscillating_Numbers:	equ v_oscillating_direction
Oscillation_Control:	equ v_oscillating_direction
Oscillating_variables:	equ v_oscillating_table
Oscillating_Data:	equ v_oscillating_table
Logspike_anim_counter:	equ v_syncani_0_time
Logspike_anim_frame:	equ v_syncani_0_frame
Rings_anim_counter:	equ v_syncani_1_time
Rings_anim_frame:	equ v_syncani_1_frame
Unknown_anim_counter:	equ v_syncani_2_time
Unknown_anim_frame:	equ v_syncani_2_frame
Ring_spill_anim_counter:	equ v_syncani_3_time
Ring_spill_anim_frame:	equ v_syncani_3_frame
Ring_spill_anim_accum:	equ v_syncani_3_accumulator
LevSel_HoldTimer:	equ v_levelselect_hold_delay
Level_select_zone:	equ v_levelselect_item
Sound_test_sound:	equ v_levelselect_sound
Emerald_count:		equ v_emeralds
Got_Emeralds_array:	equ v_emerald_list
Next_Extra_life_score:	equ v_score_next_life
Camera_Min_Y_pos_Debug_Copy:	equ v_boundary_top_debugcopy
Camera_Max_Y_pos_Debug_Copy:	equ v_boundary_bottom_debugcopy
Level_select_flag:	equ f_levelselect_cheat
Slow_motion_flag:	equ f_slowmotion_cheat
Debug_options_flag:	equ f_debug_cheat
S1_hidden_credits_flag:	equ f_credits_cheat
Correct_cheat_entries:	equ v_title_d_count
Correct_cheat_entries_2:	equ v_title_c_count
Demo_mode_flag:		equ v_demo_mode
Demo_number:		equ v_demo_num
Ending_demo_number:	equ v_credits_num
Debug_mode_flag:	equ f_debug_enable
Checksum_fourcc:	equ v_checksum_pass
loc_16F16:		equ CheckOffScreen
loc_16F3E:		equ CheckOffScreen_Wide
loc_19DD8:		equ Plat_NoXCheck
PlatformObject_ChkYRange:	equ Plat_NoXCheck_AltY
RideObject_SetRide:	equ Plat_NoCheck
ObjCheckFloorDist:	equ FindFloorObj
ObjCheckRightWallDist:	equ FindWallRightObj
ObjCheckCeilingDist	equ FindCeilingObj
ObjCheckLeftWallDist:	equ FindWallLeftObj
Find_Tile:		equ FindNearestTile
ObjectMoveAndFall:	equ ObjectFall
ObjectMove:		equ SpeedToPos
HurtCharacter:		equ HurtSonic
KillCharacter:		equ KillSonic
SlopedPlatform:		equ SlopeObject
SolidObject_Always:	equ SolidObject_NoRenderChk
SlopedSolid:		equ SolidObject_Heightmap
BreakObjectToPieces:	equ SmashObject
Obj01_Init:		equ Sonic_Main
Obj01_Dead:		equ Sonic_Death
Obj01_Gone:		equ Sonic_ResetLevel
Obj01_MdNormal_Checks:	equ Sonic_Mode_Normal
Obj01_MdAir:		equ Sonic_Mode_Air
AnglePos:		equ Sonic_AnglePos
Sonic_DoLevelCollision:	equ Sonic_JumpCollision
CheckGameOver:		equ GameOver
CalcRoomInFront:	equ Sonic_CalcRoomAhead
CalcRoomOverHead:	equ Sonic_CalcHeadroom
Sonic_CheckFloor:	equ Sonic_FindFloor
CheckFloorDist_Part2:	equ Sonic_FindFloor_Quick
loc_1ECFE:		equ Sonic_SnapAngle
CheckRightCeilingDist:	equ Sonic_FindWallRight
CheckRightWallDist:	equ Sonic_FindWallRight_Quick_UsePos
CheckRightWallDist_Part2:	equ Sonic_FindWallRight_Quick
Sonic_CheckCeiling:	equ Sonic_FindCeiling
CheckCeilingDist_Part2:	equ Sonic_FindCeiling_Quick
CheckLeftCeilingDist:	equ Sonic_FindWallLeft
CheckLeftWallDist:	equ Sonic_FindWallLeft_Quick_UsePos
CheckLeftWallDist_Part2:	equ Sonic_FindWallLeft_Quick

; Sonic 3 & Knuckles Github
anim_frame_timer:	equ ost_anim_time
respawn_addr:		equ ost_respawn
ground_vel:		equ ost_inertia
invulnerability_timer:	equ ost_sonic_flash_time
invincibility_timer:	equ ost_sonic_inv_time
speed_shoes_timer:	equ ost_sonic_shoe_time