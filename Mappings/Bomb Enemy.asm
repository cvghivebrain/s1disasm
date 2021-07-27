; ---------------------------------------------------------------------------
; Sprite mappings - walking bomb enemy (SLZ, SBZ)
; ---------------------------------------------------------------------------
		index *
		ptr @stand1
		ptr @stand2
		ptr @walk1
		ptr @walk2
		ptr @walk3
		ptr @walk4
		ptr @activate1
		ptr @activate2
		ptr @fuse1
		ptr @fuse2
		ptr @shrapnel1
		ptr @shrapnel2
		
@stand1:	spritemap			; bomb standing still
		piece	-$C, -$F, 3x3, 0
		piece	-$C, 9, 3x1, $12
		piece	-4, -$19, 1x2, $21
		endsprite
		
@stand2:	spritemap
		piece	-$C, -$F, 3x3, 9
		piece	-$C, 9, 3x1, $12
		piece	-4, -$19, 1x2, $21
		endsprite
		
@walk1:		spritemap			; bomb walking
		piece	-$C, -$10, 3x3, 0
		piece	-$C, 8, 3x1, $15
		piece	-4, -$1A, 1x2, $21
		endsprite
		
@walk2:		spritemap
		piece	-$C, -$F, 3x3, 9
		piece	-$C, 9, 3x1, $18
		piece	-4, -$19, 1x2, $21
		endsprite
		
@walk3:		spritemap
		piece	-$C, -$10, 3x3, 0
		piece	-$C, 8, 3x1, $1B
		piece	-4, -$1A, 1x2, $21
		endsprite
		
@walk4:		spritemap
		piece	-$C, -$F, 3x3, 9
		piece	-$C, 9, 3x1, $1E
		piece	-4, -$19, 1x2, $21
		endsprite
		
@activate1:	spritemap			; bomb during detonation countdown
		piece	-$C, -$F, 3x3, 0
		piece	-$C, 9, 3x1, $12
		endsprite
		
@activate2:	spritemap
		piece	-$C, -$F, 3x3, 9
		piece	-$C, 9, 3x1, $12
		endsprite
		
@fuse1:		spritemap			; fuse (just before it explodes)
		piece	-4, -$19, 1x2, $23
		endsprite
		
@fuse2:		spritemap
		piece	-4, -$19, 1x2, $25
		endsprite
		
@shrapnel1:	spritemap			; shrapnel (after it exploded)
		piece	-4, -4, 1x1, $27
		endsprite
		
@shrapnel2:	spritemap
		piece	-4, -4, 1x1, $28
		endsprite
		even
