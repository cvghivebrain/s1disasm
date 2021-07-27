; ---------------------------------------------------------------------------
; Sprite mappings - Newtron enemy (GHZ)
; ---------------------------------------------------------------------------
		index *
		ptr M_Newt_Trans
		ptr M_Newt_Norm
		ptr M_Newt_Fires
		ptr M_Newt_Drop1
		ptr M_Newt_Drop2
		ptr M_Newt_Drop3
		ptr M_Newt_Fly1a
		ptr M_Newt_Fly1b
		ptr M_Newt_Fly2a
		ptr M_Newt_Fly2b
		ptr M_Newt_Blank
		
M_Newt_Trans:	spritemap			; partially visible
		piece	-$14, -$14, 4x2, 0
		piece	$C, -$C, 1x1, 8
		piece	-$C, -4, 4x3, 9
		endsprite
		
M_Newt_Norm:	spritemap			; visible
		piece	-$14, -$14, 2x3, $15
		piece	-4, -$14, 3x2, $1B
		piece	-4, -4, 3x3, $21
		endsprite
		
M_Newt_Fires:	spritemap			; open mouth, firing
		piece	-$14, -$14, 2x3, $2A
		piece	-4, -$14, 3x2, $1B
		piece	-4, -4, 3x3, $21
		endsprite
		
M_Newt_Drop1:	spritemap			; dropping
		piece	-$14, -$14, 2x3, $30
		piece	-4, -$14, 3x2, $1B
		piece	-4, -4, 3x2, $36
		piece	$C, $C, 1x1, $3C
		endsprite
		
M_Newt_Drop2:	spritemap
		piece	-$14, -$C, 4x2, $3D
		piece	$C, -4, 1x1, $20
		piece	-4, 4, 3x1, $45
		endsprite
		
M_Newt_Drop3:	spritemap
		piece	-$14, -8, 4x2, $48
		piece	$C, -8, 1x2, $50
		endsprite
		
M_Newt_Fly1a:	spritemap			; flying
		piece	-$14, -8, 4x2, $48
		piece	$C, -8, 1x2, $50
		piece	$14, -2, 1x1, $52
		endsprite
		
M_Newt_Fly1b:	spritemap
		piece	-$14, -8, 4x2, $48
		piece	$C, -8, 1x2, $50
		piece	$14, -2, 2x1, $53
		endsprite
		
M_Newt_Fly2a:	spritemap
		piece	-$14, -8, 4x2, $48
		piece	$C, -8, 1x2, $50
		piece	$14, -2, 1x1, $52, pal4, hi
		endsprite
		
M_Newt_Fly2b:	spritemap
		piece	-$14, -8, 4x2, $48
		piece	$C, -8, 1x2, $50
		piece	$14, -2, 2x1, $53, pal4, hi
		endsprite
		
M_Newt_Blank:	spritemap
		endsprite
		even
