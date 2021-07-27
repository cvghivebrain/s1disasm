; ---------------------------------------------------------------------------
; Sprite mappings - rings
; ---------------------------------------------------------------------------
		index *
		ptr @front
		ptr @angle1
		ptr @edge
		ptr @angle2
		ptr @sparkle1
		ptr @sparkle2
		ptr @sparkle3
		ptr @sparkle4
		if Revision>0
		ptr @blank
		endc
		
@front:		spritemap		; ring front
		piece	-8, -8, 2x2, 0
		endsprite
		
@angle1:	spritemap		; ring angle
		piece	-8, -8, 2x2, 4
		endsprite
		
@edge:		spritemap		; ring perpendicular
		piece	-4, -8, 1x2, 8
		endsprite
		
@angle2:	spritemap		; ring angle
		piece	-8, -8, 2x2, 4, xflip
		endsprite
		
@sparkle1:	spritemap		; sparkle
		piece	-8, -8, 2x2, $A
		endsprite
		
@sparkle2:	spritemap		; sparkle
		piece	-8, -8, 2x2, $A, xflip, yflip
		endsprite
		
@sparkle3:	spritemap		;sparkle
		piece	-8, -8, 2x2, $A, xflip
		endsprite
		
@sparkle4:	spritemap		; sparkle
		piece	-8, -8, 2x2, $A, yflip
		endsprite
		
		if Revision>0
@blank:		spritemap
		endsprite
		endc
		even
