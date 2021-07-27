; ---------------------------------------------------------------------------
; Sprite mappings - missile that Buzz Bomber throws
; ---------------------------------------------------------------------------
		index *
		ptr @Flare1
		ptr @Flare2
		ptr @Ball1
		ptr @Ball2
		
@Flare1:	spritemap		; buzz bomber firing flare
		piece	-8, -8, 2x2, $24
		endsprite
		
@Flare2:	spritemap
		piece	-8, -8, 2x2, $28
		endsprite
		
@Ball1:		spritemap		; missile itself
		piece	-8, -8, 2x2, $2C
		endsprite
		
@Ball2:		spritemap
		piece	-8, -8, 2x2, $33
		endsprite
		even
