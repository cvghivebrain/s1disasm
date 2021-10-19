
; Scenery
type_scen_cannon:	equ (Scen_Values_0-Scen_Values)/sizeof_scen_values	; 0 - SLZ cannon
type_scen_stump:	equ (Scen_Values_3-Scen_Values)/sizeof_scen_values	; 3 - GHZ bridge stump

; EdgeWalls
type_edge_shadow:	equ id_frame_edge_shadow	; 0
type_edge_light:	equ id_frame_edge_light		; 1
type_edge_dark:		equ id_frame_edge_dark		; 2

; CollapseLedge
type_ledge_left:	equ id_frame_ledge_left		; 0 - facing left
type_ledge_right:	equ id_frame_ledge_right	; 1 - also facing left, but always xflipped to face right

; BasicPlatform
type_plat_still:	equ id_Plat_Type_Still			; 0 - doesn't move
type_plat_sideways:	equ id_Plat_Type_Sideways		; 1 - moves side-to-side
type_plat_updown:	equ id_Plat_Type_UpDown			; 2 - moves up and down
type_plat_falls:	equ id_Plat_Type_Falls			; 3 - falls when stood on
type_plat_sideways_rev:	equ id_Plat_Type_Sideways_Rev		; 5 - moves side-to-side, reversed
type_plat_updown_rev:	equ id_Plat_Type_UpDown_Rev		; 6 - moves up and down, reversed
type_plat_rises:	equ id_Plat_Type_Rises			; 7 - rises 512 pixels 1 second after a button is pressed
type_plat_updown_large:	equ id_Plat_Type_UpDown_Large		; $A - moves up and down, large column-shaped platform
type_plat_updown_slow:	equ id_Plat_Type_UpDown_Slow		; $B - moves up and down, slow
type_plat_updown_slow_rev: equ id_Plat_Type_UpDown_Slow_Rev	; $C - moves up and down, slow reversed

; LargeGrass
type_grass_wide:	equ ((LGrass_Data_0-LGrass_Data)/sizeof_grass_data)<<4	; $0x - wide platform
type_grass_sloped:	equ ((LGrass_Data_1-LGrass_Data)/sizeof_grass_data)<<4	; $1x - sloped platform, usually sinks and catches fire
type_grass_narrow:	equ ((LGrass_Data_2-LGrass_Data)/sizeof_grass_data)<<4	; $2x - narrow platform
type_grass_still:	equ id_LGrass_Type00					; $x0 - doesn't move
type_grass_1:		equ id_LGrass_Type01					; $x1 - moves up and down 32 pixels
type_grass_2:		equ id_LGrass_Type02					; $x2 - moves up and down 48 pixels
type_grass_3:		equ id_LGrass_Type03					; $x3 - moves up and down 64 pixels
type_grass_4:		equ id_LGrass_Type04					; $x4 - moves up and down 96 pixels
type_grass_sinks:	equ id_LGrass_Type05					; $x5 - sinks and catches fire when stood on
type_grass_rev:		equ 8							; +8 - reverse movement direction

; ChainStomp
type_cstomp_wide:	equ ((CStom_Var2_0-CStom_Var2)/sizeof_cstom_var2)<<4	; $0x - wide stomper
type_cstomp_medium:	equ ((CStom_Var2_1-CStom_Var2)/sizeof_cstom_var2)<<4	; $1x - medium stomper
type_cstomp_small:	equ ((CStom_Var2_2-CStom_Var2)/sizeof_cstom_var2)<<4	; $2x - small stomper, no spikes
type_cstomp_controlled:	equ $80							; +$80 - controlled by button 0
type_cstomp_0:		equ (CStom_Length_0-CStom_Lengths)/2			; $x0 - chain length $70, rises when switch is pressed
type_cstomp_1:		equ (CStom_Length_1-CStom_Lengths)/2			; $x1 - chain length $A0
type_cstomp_2:		equ (CStom_Length_2-CStom_Lengths)/2			; $x2 - chain length $50
type_cstomp_3:		equ (CStom_Length_3-CStom_Lengths)/2			; $x3 - chain length $78, only triggers when Sonic is near
type_cstomp_4:		equ (CStom_Length_4-CStom_Lengths)/2			; $x4 - chain length $38
type_cstomp_5:		equ (CStom_Length_5-CStom_Lengths)/2			; $x5 - chain length $58, only triggers when Sonic is near
type_cstomp_6:		equ (CStom_Length_6-CStom_Lengths)/2			; $x6 - chain length $B8

; MarbleBrick
type_brick_still:	equ id_Brick_Still		; 0 - doesn't move
type_brick_wobbles:	equ id_Brick_Wobbles		; 1 - wobbles but doesn't fall
type_brick_falls:	equ id_Brick_Falls		; 2 - falls when Sonic is near
type_brick_rev:		equ 8				; +8 - reverse wobble direction

; GlassBlock
type_glass_still:	equ id_Glass_Still		; 0 - doesn't move
type_glass_updown:	equ id_Glass_UpDown		; 1 - moves up and down
type_glass_updown_rev:	equ id_Glass_UpDown_Rev		; 2 - moves up and down, reversed
type_glass_drop_jump:	equ id_Glass_Drop_Jump		; 3 - drops each time it's jumped on
type_glass_drop_button:	equ id_Glass_Drop_Button	; 4 - drops when button is pressed
type_glass_button_0:	equ 0				; $0x - button 0
type_glass_button_1:	equ $10				; $1x - button 1

; MovingBlock
type_mblock_1:		equ ((MBlock_Var_0-MBlock_Var)/sizeof_MBlock_Var)<<4	; $0x - single block
type_mblock_2:		equ ((MBlock_Var_1-MBlock_Var)/sizeof_MBlock_Var)<<4	; $1x - double block
type_mblock_sbz:	equ ((MBlock_Var_2-MBlock_Var)/sizeof_MBlock_Var)<<4	; $2x - SBZ black & yellow platform
type_mblock_sbzwide:	equ ((MBlock_Var_3-MBlock_Var)/sizeof_MBlock_Var)<<4	; $3x - SBZ red horizontal door
type_mblock_3:		equ ((MBlock_Var_4-MBlock_Var)/sizeof_MBlock_Var)<<4	; $4x - triple block
type_mblock_still:	equ id_MBlock_Still					; $x0 - doesn't move
type_mblock_leftright:	equ id_MBlock_LeftRight					; $x1 - moves side to side
type_mblock_right:	equ id_MBlock_Right					; $x2 - moves right when stood on, stops at wall
type_mblock_rightdrop:	equ id_MBlock_RightDrop					; $x4 - moves right when stood on, stops at wall and drops
type_mblock_rightdrop_button: equ id_MBlock_RightDrop_Button			; $x7 - appears when button 2 is pressed; moves right when stood on, stops at wall and drops
type_mblock_updown:	equ id_MBlock_UpDown					; $x8 - moves up and down
type_mblock_slide:	equ id_MBlock_Slide					; $x9 - quickly slides right when stood on

; PushBlock
type_pblock_single:	equ (PushB_Var_0-PushB_Var)/sizeof_PushB_Var		; 0 - single block
type_pblock_four:	equ (PushB_Var_1-PushB_Var)/sizeof_PushB_Var		; 1 - four blocks in a row
type_pblock_nograv:	equ $80							; +$80 - no gravity

; FloatingBlock
type_fblock_syz1x1:	equ id_frame_fblock_syz1x1<<4		; $0x - single 32x32 square
type_fblock_syz2x2:	equ id_frame_fblock_syz2x2<<4		; $1x - 2x2 32x32 squares
type_fblock_syz1x2:	equ id_frame_fblock_syz1x2<<4		; $2x - 1x2 32x32 squares
type_fblock_syzrect2x2:	equ id_frame_fblock_syzrect2x2<<4	; $3x - 2x2 32x26 squares
type_fblock_syzrect1x3:	equ id_frame_fblock_syzrect1x3<<4	; $4x - 1x3 32x26 squares
type_fblock_slz:	equ id_frame_fblock_slz<<4		; $5x - 32x32 square
type_fblock_lzvert:	equ id_frame_fblock_lzvert<<4		; $6x - LZ vertical door
type_fblock_lzhoriz:	equ id_frame_fblock_lzhoriz<<4		; $7x - LZ large horizontal door
type_fblock_still:	equ id_FBlock_Still			; $x0 - doesn't move
type_fblock_leftright:	equ id_FBlock_LeftRight			; $x1 - moves side to side
type_fblock_leftrightwide: equ id_FBlock_LeftRightWide		; $x2 - moves side to side, larger distance
type_fblock_updown:	equ id_FBlock_UpDown			; $x3 - moves up and down
type_fblock_updownwide:	equ id_FBlock_UpDownWide		; $x4 - moves up and down, larger distance
type_fblock_upbutton:	equ id_FBlock_UpButton			; $x5 - moves up when button is pressed
type_fblock_downbutton:	equ id_FBlock_DownButton		; $x6 - moves down when button is pressed
type_fblock_farrightbutton: equ id_FBlock_FarRightButton	; $x7 - moves far right when button $F is pressed
type_fblock_squaresmall: equ id_FBlock_SquareSmall		; $x8 - moves in a small square
type_fblock_squaremedium: equ id_FBlock_SquareMedium		; $x9 - moves in a medium square
type_fblock_squarebig:	equ id_FBlock_SquareBig			; $xA - moves in a big square
type_fblock_squarebiggest: equ id_FBlock_SquareBiggest		; $xB - moves in a bigger square
type_fblock_leftbutton:	equ id_FBlock_LeftButton		; $xC - moves left when button is pressed
type_fblock_rightbutton: equ id_FBlock_RightButton		; $xD - moves right when button is pressed
type_fblock_button:	equ $80					; +$80 - links block to button and forces it to be type_fblock_upbutton or type_fblock_leftbutton

; BigSpikeBall
type_bball_still:	equ id_BBall_Still		; 0 - doesn't move
type_bball_sideways:	equ id_BBall_Sideways		; 1 - moves side-to-side
type_bball_updown:	equ id_BBall_UpDown		; 2 - moves up and down
type_bball_circle:	equ id_BBall_Circle		; 3 - moves in a circle

; Harpoon
type_harp_h:		equ id_ani_harp_h_extending	; 0 - horizontal
type_harp_v:		equ id_ani_harp_v_extending	; 2 - vertical

; LabyrinthBlock
type_lblock_sink:	equ (id_frame_lblock_sinkblock<<4)+1	; 1 - sinks when stood on
type_lblock_rise:	equ (id_frame_lblock_riseplatform<<4)+3	; $13 - rises when stood on
type_lblock_cork:	equ (id_frame_lblock_cork<<4)+7		; $27 - floats on water
type_lblock_solid:	equ id_frame_lblock_block<<4		; $30 - doesn't move

; LabyrinthConvey
type_lcon_wheel:	equ $7F				; wheel on conveyor belt corner

; Waterfall
type_wfall_vert:	equ id_frame_wfall_vertnarrow		; 0 - vertical narrow
type_wfall_cornermedium: equ id_frame_wfall_cornermedium	; 2 - corner
type_wfall_cornernarrow: equ id_frame_wfall_cornernarrow	; 3 - corner narrow
type_wfall_cornermedium2: equ id_frame_wfall_cornermedium2	; 4 - corner
type_wfall_cornernarrow2: equ id_frame_wfall_cornernarrow2	; 5 - corner narrow
type_wfall_cornernarrow3: equ id_frame_wfall_cornernarrow3	; 6 - corner narrow
type_wfall_vertwide:	equ id_frame_wfall_vertwide		; 7 - vertical wide
type_wfall_diagonal:	equ id_frame_wfall_diagonal		; 8 - diagonal
type_wfall_splash:	equ id_frame_wfall_splash1		; 9 - splash
type_wfall_splash_match: equ id_frame_wfall_splash1+$40		; $49 - splash, matches y position to water surface
type_wfall_splash_low:	equ id_frame_wfall_splash1+$20		; $29 - splash, low priority sprite on specific level tile
type_wfall_hi:		equ $80					; +$80 - high priority sprite

; Staircase
type_stair_above:	equ id_Stair_Type00		; 0 - forms a staircase when stood on
type_stair_below:	equ id_Stair_Type02		; 2 - forms a staircase when hit from below

; Fan
type_fan_left_onoff:	equ 0				; 0 - blows left, turns on/off every 3 seconds
type_fan_right_onoff:	equ 1				; 1 - blows right, turns on/off every 3 seconds
type_fan_left_on:	equ 2				; 2 - blows left, always on
type_fan_right_on:	equ 3				; 3 - blows right, always on

; Elevator
type_elev_up_short:	equ (Elev_Var2_0-Elev_Var2)/sizeof_Elev_Var2	; 0 - rises 128px when stood on
type_elev_up_medium:	equ (Elev_Var2_1-Elev_Var2)/sizeof_Elev_Var2	; 1 - rises 256px when stood on
type_elev_down_short:	equ (Elev_Var2_3-Elev_Var2)/sizeof_Elev_Var2	; 3 - falls 128px when stood on
type_elev_upright:	equ (Elev_Var2_C-Elev_Var2)/sizeof_Elev_Var2	; $C - rises diagonally right when stood on
type_elev_up_vanish:	equ $80						; $80 - rises when stood on and vanishes