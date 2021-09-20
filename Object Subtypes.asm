
; Harpoon
type_harp_h:		equ id_ani_harp_h_extending	; 0 - horizontal
type_harp_v:		equ id_ani_harp_v_extending	; 2 - vertical

; LabyrinthBlock
type_lblock_sink:	equ (id_frame_lblock_sinkblock<<4)+1	; 1 - sinks when stood on
type_lblock_rise:	equ (id_frame_lblock_riseplatform<<4)+3	; $13 - rises when stood on
type_lblock_cork:	equ (id_frame_lblock_cork<<4)+7		; $27 - floats on water
type_lblock_solid:	equ id_frame_lblock_block<<4		; $30 - doesn't move