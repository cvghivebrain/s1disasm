; ---------------------------------------------------------------------------
; Sprite mappings - explosion from a badnik or monitor
; ---------------------------------------------------------------------------
Map_ExplodeItem:
		index offset(*)
		ptr frame_ex_0
		ptr frame_ex_1
		ptr frame_ex_2
		ptr frame_ex_3
		ptr frame_ex_4
		
frame_ex_0:	spritemap
		piece	-$C, -8, 3x2, 0
		endsprite
		
frame_ex_1:	spritemap
		piece	-$10, -$10, 4x4, 6
		endsprite
		
frame_ex_2:	spritemap
		piece	-$10, -$10, 4x4, $16
		endsprite
		
frame_ex_3:	spritemap
		piece	-$14, -$14, 3x3, $26
		piece	4, -$14, 2x2, $2F
		piece	-$14, 4, 2x2, $2F, xflip, yflip
		piece	-4, -4, 3x3, $26, xflip, yflip
		endsprite
		
frame_ex_4:	spritemap
		piece	-$14, -$14, 3x3, $33
		piece	4, -$14, 2x2, $3C
		piece	-$14, 4, 2x2, $3C, xflip, yflip
		piece	-4, -4, 3x3, $33, xflip, yflip
		endsprite
		even
		
; ---------------------------------------------------------------------------
; Sprite mappings - explosion from when	a boss is destroyed
; ---------------------------------------------------------------------------
Map_ExplodeBomb:
		index offset(*)
		ptr frame_ex_0					; backwards reference
		ptr frame_exbomb_1
		ptr frame_exbomb_2
		ptr frame_ex_3					; backwards reference
		ptr frame_ex_4					; backwards reference
		
frame_exbomb_1:	spritemap
		piece	-$10, -$10, 4x4, $40
		endsprite
		
frame_exbomb_2:	spritemap
		piece	-$10, -$10, 4x4, $50
		endsprite
		even
