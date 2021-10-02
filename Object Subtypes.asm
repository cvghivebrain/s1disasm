
; Scenery
type_scen_cannon:	equ (Scen_Values_0-Scen_Values)/sizeof_scen_values	; 0 - SLZ cannon
type_scen_stump:	equ (Scen_Values_3-Scen_Values)/sizeof_scen_values	; 0 - GHZ bridge stump

; EdgeWalls
type_edge_shadow:	equ id_frame_edge_shadow	; 0
type_edge_light:	equ id_frame_edge_light		; 1
type_edge_dark:		equ id_frame_edge_dark		; 2

; CollapseLedge
type_ledge_left:	equ id_frame_ledge_left		; 0 - facing left
type_ledge_right:	equ id_frame_ledge_right	; 1 - also facing left, but always xflipped to face right

; Harpoon
type_harp_h:		equ id_ani_harp_h_extending	; 0 - horizontal
type_harp_v:		equ id_ani_harp_v_extending	; 2 - vertical

; LabyrinthBlock
type_lblock_sink:	equ (id_frame_lblock_sinkblock<<4)+1	; 1 - sinks when stood on
type_lblock_rise:	equ (id_frame_lblock_riseplatform<<4)+3	; $13 - rises when stood on
type_lblock_cork:	equ (id_frame_lblock_cork<<4)+7		; $27 - floats on water
type_lblock_solid:	equ id_frame_lblock_block<<4		; $30 - doesn't move