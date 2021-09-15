; ---------------------------------------------------------------------------
; Sprite mappings - extra boss items (e.g. swinging ball on a chain in GHZ)
; ---------------------------------------------------------------------------
Map_BossItems:	index *
		ptr frame_boss_chainanchor1
		ptr frame_boss_chainanchor2
		ptr frame_boss_cross
		ptr frame_boss_widepipe
		ptr frame_boss_pipe
		ptr frame_boss_spike
		ptr frame_boss_legmask
		ptr frame_boss_legs
		
frame_boss_chainanchor1:
		spritemap			; GHZ boss
		piece	-8, -8, 2x2, 0
		endsprite
		
frame_boss_chainanchor2:
		spritemap			; GHZ boss
		piece	-8, -4, 2x1, 4
		piece	-8, -8, 2x2, 0
		endsprite
		even
		
frame_boss_cross:
		spritemap			; unknown - unused
		piece	-4, -4, 1x1, 6
		endsprite
		
frame_boss_widepipe:
		spritemap			; SLZ boss
		piece	-$C, $14, 3x2, 7
		endsprite
		
frame_boss_pipe:
		spritemap			; MZ boss
		piece	-8, $14, 2x2, $D
		endsprite
		
frame_boss_spike:
		spritemap			; SYZ boss
		piece	-8, -$10, 2x1, $11
		piece	-8, -8, 1x2, $13
		piece	0, -8, 1x2, $13, xflip
		piece	-8, 8, 2x1, $15
		endsprite
		even
		
frame_boss_legmask:
		spritemap			; FZ post-boss: sprite covering part of legs - unused
		piece	0, 0, 2x2, $17
		piece	$10, 0, 1x1, $1B
		endsprite
		even
		
frame_boss_legs:
		spritemap			; FZ post-boss - unused
		piece	0, $18, 2x1, $1C
		piece	$10, 0, 3x4, $1E
		endsprite
		even
