
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

; Harpoon
type_harp_h:		equ id_ani_harp_h_extending	; 0 - horizontal
type_harp_v:		equ id_ani_harp_v_extending	; 2 - vertical

; LabyrinthBlock
type_lblock_sink:	equ (id_frame_lblock_sinkblock<<4)+1	; 1 - sinks when stood on
type_lblock_rise:	equ (id_frame_lblock_riseplatform<<4)+3	; $13 - rises when stood on
type_lblock_cork:	equ (id_frame_lblock_cork<<4)+7		; $27 - floats on water
type_lblock_solid:	equ id_frame_lblock_block<<4		; $30 - doesn't move