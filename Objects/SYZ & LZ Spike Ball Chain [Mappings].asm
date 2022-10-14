; ---------------------------------------------------------------------------
; Sprite mappings - chain of spiked balls (SYZ)
; ---------------------------------------------------------------------------

Map_SBall:	index offset(*)
		ptr frame_sball_syz
		
frame_sball_syz:
		spritemap
		piece	-8, -8, 2x2, 0
		endsprite
		even

; ---------------------------------------------------------------------------
; Sprite mappings - spiked ball	on a chain (LZ)
; ---------------------------------------------------------------------------

Map_SBall2:	index offset(*)
		ptr frame_sball_chain
		ptr frame_sball_spikeball
		ptr frame_sball_base
		
frame_sball_chain:
		spritemap					; chain link
		piece	-8, -8, 2x2, 0
		endsprite
		
frame_sball_spikeball:
		spritemap					; spikeball
		piece	-$10, -$10, 4x4, 4
		endsprite
		
frame_sball_base:
		spritemap					; wall attachment
		piece	-8, -8, 2x2, $14
		endsprite
		even
