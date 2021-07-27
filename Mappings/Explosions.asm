; ---------------------------------------------------------------------------
; Sprite mappings - explosion from a badnik or monitor
; ---------------------------------------------------------------------------
		index *
		ptr byte_8ED0
		ptr byte_8ED6
		ptr byte_8EDC
		ptr byte_8EE2
		ptr byte_8EF7
		
byte_8ED0:	spritemap
		piece	-$C, -8, 3x2, 0
		endsprite
		
byte_8ED6:	spritemap
		piece	-$10, -$10, 4x4, 6
		endsprite
		
byte_8EDC:	spritemap
		piece	-$10, -$10, 4x4, $16
		endsprite
		
byte_8EE2:	spritemap
		piece	-$14, -$14, 3x3, $26
		piece	4, -$14, 2x2, $2F
		piece	-$14, 4, 2x2, $2F, xflip, yflip
		piece	-4, -4, 3x3, $26, xflip, yflip
		endsprite
		
byte_8EF7:	spritemap
		piece	-$14, -$14, 3x3, $33
		piece	4, -$14, 2x2, $3C
		piece	-$14, 4, 2x2, $3C, xflip, yflip
		piece	-4, -4, 3x3, $33, xflip, yflip
		endsprite
		even
		
; ---------------------------------------------------------------------------
; Sprite mappings - explosion from when	a boss is destroyed
; ---------------------------------------------------------------------------
Map_ExplodeBomb:index *
		ptr byte_8ED0	; backwards reference
		ptr byte_8F16
		ptr byte_8F1C
		ptr byte_8EE2	; backwards reference
		ptr byte_8EF7	; backwards reference
		
byte_8F16:	spritemap
		piece	-$10, -$10, 4x4, $40
		endsprite
		
byte_8F1C:	spritemap
		piece	-$10, -$10, 4x4, $50
		endsprite
		even
