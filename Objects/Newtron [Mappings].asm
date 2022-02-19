; ---------------------------------------------------------------------------
; Sprite mappings - Newtron enemy (GHZ)
; ---------------------------------------------------------------------------

Map_Newt:	index *
		ptr frame_newt_trans
		ptr frame_newt_norm
		ptr frame_newt_firing
		ptr frame_newt_drop1
		ptr frame_newt_drop2
		ptr frame_newt_drop3
		ptr frame_newt_fly1a
		ptr frame_newt_fly1b
		ptr frame_newt_fly2a
		ptr frame_newt_fly2b
		ptr frame_newt_blank
		
frame_newt_trans:
		spritemap					; partially visible
		piece	-$14, -$14, 4x2, 0
		piece	$C, -$C, 1x1, 8
		piece	-$C, -4, 4x3, 9
		endsprite
		
frame_newt_norm:
		spritemap					; visible
		piece	-$14, -$14, 2x3, $15
		piece	-4, -$14, 3x2, $1B
		piece	-4, -4, 3x3, $21
		endsprite
		
frame_newt_firing:
		spritemap					; open mouth, firing
		piece	-$14, -$14, 2x3, $2A
		piece	-4, -$14, 3x2, $1B
		piece	-4, -4, 3x3, $21
		endsprite
		
frame_newt_drop1:
		spritemap					; dropping
		piece	-$14, -$14, 2x3, $30
		piece	-4, -$14, 3x2, $1B
		piece	-4, -4, 3x2, $36
		piece	$C, $C, 1x1, $3C
		endsprite
		
frame_newt_drop2:
		spritemap
		piece	-$14, -$C, 4x2, $3D
		piece	$C, -4, 1x1, $20
		piece	-4, 4, 3x1, $45
		endsprite
		
frame_newt_drop3:
		spritemap
		piece	-$14, -8, 4x2, $48
		piece	$C, -8, 1x2, $50
		endsprite
		
frame_newt_fly1a:
		spritemap					; flying
		piece	-$14, -8, 4x2, $48
		piece	$C, -8, 1x2, $50
		piece	$14, -2, 1x1, $52
		endsprite
		
frame_newt_fly1b:
		spritemap
		piece	-$14, -8, 4x2, $48
		piece	$C, -8, 1x2, $50
		piece	$14, -2, 2x1, $53
		endsprite
		
frame_newt_fly2a:
		spritemap
		piece	-$14, -8, 4x2, $48
		piece	$C, -8, 1x2, $50
		piece	$14, -2, 1x1, $52, pal4, hi
		endsprite
		
frame_newt_fly2b:
		spritemap
		piece	-$14, -8, 4x2, $48
		piece	$C, -8, 1x2, $50
		piece	$14, -2, 2x1, $53, pal4, hi
		endsprite
		
frame_newt_blank:
		spritemap
		endsprite
		even
