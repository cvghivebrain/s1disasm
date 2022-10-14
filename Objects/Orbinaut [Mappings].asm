; ---------------------------------------------------------------------------
; Sprite mappings - Orbinaut enemy (LZ, SLZ, SBZ)
; ---------------------------------------------------------------------------

Map_Orb:	index offset(*)
		ptr frame_orb_normal
		ptr frame_orb_medium
		ptr frame_orb_angry
		ptr frame_orb_spikeball
		
frame_orb_normal:
		spritemap
		piece	-$C, -$C, 3x3, 0
		endsprite
		
frame_orb_medium:
		spritemap
		piece	-$C, -$C, 3x3, 9, pal2
		endsprite
		
frame_orb_angry:
		spritemap
		piece	-$C, -$C, 3x3, $12
		endsprite
		
frame_orb_spikeball:
		spritemap
		piece	-8, -8, 2x2, $1B
		endsprite
		even
