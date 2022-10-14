; ---------------------------------------------------------------------------
; Sprite mappings - Bosses (ship, Eggman and flame)
; ---------------------------------------------------------------------------

Map_Bosses:	index offset(*)
		ptr frame_boss_ship
		ptr frame_boss_face1
		ptr frame_boss_face2
		ptr frame_boss_laugh1
		ptr frame_boss_laugh2
		ptr frame_boss_hit
		ptr frame_boss_panic
		ptr frame_boss_defeat
		ptr frame_boss_flame1
		ptr frame_boss_flame2
		ptr frame_boss_blank
		ptr frame_boss_bigflame1
		ptr frame_boss_bigflame2
		
frame_boss_ship:
		spritemap
		piece	-$1C, -$14, 1x2, $A
		piece	$C, -$14, 2x2, $C
		piece	-$1C, -4, 4x3, $10, pal2
		piece	4, -4, 4x3, $1C, pal2
		piece	-$14, $14, 4x1, $28, pal2
		piece	$C, $14, 1x1, $2C, pal2
		endsprite
		
frame_boss_face1:
		spritemap
		piece	-$C, -$1C, 2x1, 0
		piece	-$14, -$14, 4x2, 2
		endsprite
		
frame_boss_face2:
		spritemap
		piece	-$C, -$1C, 2x1, 0
		piece	-$14, -$14, 4x2, $35
		endsprite
		
frame_boss_laugh1:
		spritemap
		piece	-$C, -$1C, 3x1, $3D
		piece	-$14, -$14, 3x2, $40
		piece	4, -$14, 2x2, $46
		endsprite
		
frame_boss_laugh2:
		spritemap
		piece	-$C, -$1C, 3x1, $4A
		piece	-$14, -$14, 3x2, $4D
		piece	4, -$14, 2x2, $53
		endsprite
		
frame_boss_hit:
		spritemap
		piece	-$C, -$1C, 3x1, $57
		piece	-$14, -$14, 3x2, $5A
		piece	4, -$14, 2x2, $60
		endsprite
		
frame_boss_panic:
		spritemap
		piece	4, -$1C, 2x1, $64
		piece	-$C, -$1C, 2x1, 0
		piece	-$14, -$14, 4x2, $35
		endsprite
		
frame_boss_defeat:
		spritemap
		piece	-$C, -$1C, 3x2, $66
		piece	-$C, -$1C, 3x1, $57
		piece	-$14, -$14, 3x2, $5A
		piece	4, -$14, 2x2, $60
		endsprite
		
frame_boss_flame1:
		spritemap
		piece	$22, 4, 2x2, $2D
		endsprite
		
frame_boss_flame2:
		spritemap
		piece	$22, 4, 2x2, $31
		endsprite
		
frame_boss_blank:
		spritemap
		endsprite
		
frame_boss_bigflame1:
		spritemap
		piece	$22, 0, 3x1, $12A
		piece	$22, 8, 3x1, $12A, yflip
		endsprite
		
frame_boss_bigflame2:
		spritemap
		piece	$22, -8, 3x4, $12D
		piece	$3A, 0, 1x2, $139
		endsprite
		even

; ---------------------------------------------------------------------------
; Sprite mappings - extra boss items & weapons
; ---------------------------------------------------------------------------

Map_BossItems:	index offset(*)
		ptr frame_boss_chainanchor1
		ptr frame_boss_chainanchor2
		ptr frame_boss_cross
		ptr frame_boss_widepipe
		ptr frame_boss_pipe
		ptr frame_boss_spike
		ptr frame_boss_legmask
		ptr frame_boss_legs
		
frame_boss_chainanchor1:
		spritemap					; GHZ boss
		piece	-8, -8, 2x2, 0
		endsprite
		
frame_boss_chainanchor2:
		spritemap					; GHZ boss
		piece	-8, -4, 2x1, 4
		piece	-8, -8, 2x2, 0
		endsprite
		even
		
frame_boss_cross:
		spritemap					; unknown - unused
		piece	-4, -4, 1x1, 6
		endsprite
		
frame_boss_widepipe:
		spritemap					; SLZ boss
		piece	-$C, $14, 3x2, 7
		endsprite
		
frame_boss_pipe:
		spritemap					; MZ boss
		piece	-8, $14, 2x2, $D
		endsprite
		
frame_boss_spike:
		spritemap					; SYZ boss
		piece	-8, -$10, 2x1, $11
		piece	-8, -8, 1x2, $13
		piece	0, -8, 1x2, $13, xflip
		piece	-8, 8, 2x1, $15
		endsprite
		even
		
frame_boss_legmask:
		spritemap					; FZ post-boss: sprite covering part of legs - unused
		piece	0, 0, 2x2, $17
		piece	$10, 0, 1x1, $1B
		endsprite
		even
		
frame_boss_legs:
		spritemap					; FZ post-boss - unused
		piece	0, $18, 2x1, $1C
		piece	$10, 0, 3x4, $1E
		endsprite
		even
