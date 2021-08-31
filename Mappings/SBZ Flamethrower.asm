; ---------------------------------------------------------------------------
; Sprite mappings - flame thrower (SBZ)
; ---------------------------------------------------------------------------
		index *
		ptr @pipe1
		ptr @pipe2
		ptr @pipe3
		ptr @pipe4
		ptr @pipe5
		ptr @pipe6
		ptr @pipe7
		ptr @pipe8
		ptr @pipe9
		ptr @pipe10
		ptr @pipe11	; $A
		ptr @valve1
		ptr @valve2
		ptr @valve3
		ptr @valve4
		ptr @valve5
		ptr @valve6
		ptr @valve7
		ptr @valve8
		ptr @valve9
		ptr @valve10
		ptr @valve11	; $15
@pipe1:		spritemap			; broken pipe style flamethrower
		piece	-5, $28, 2x2, $14, pal3
		endsprite
		
@pipe2:		spritemap
		piece	-3, $20, 1x2, 0
		piece	-5, $28, 2x2, $14, pal3
		endsprite
		
@pipe3:		spritemap
		piece	-4, $20, 1x2, 0, xflip
		piece	-5, $28, 2x2, $14, pal3
		endsprite
		
@pipe4:		spritemap
		piece	-8, $10, 2x3, 2
		piece	-3, $20, 1x2, 0
		piece	-5, $28, 2x2, $14, pal3
		endsprite
		
@pipe5:		spritemap
		piece	-8, $10, 2x3, 2, xflip
		piece	-4, $20, 1x2, 0, xflip
		piece	-5, $28, 2x2, $14, pal3
		endsprite
		
@pipe6:		spritemap
		piece	-8, 8, 2x3, 2
		piece	-8, $10, 2x3, 2
		piece	-3, $20, 1x2, 0
		piece	-5, $28, 2x2, $14, pal3
		endsprite
		
@pipe7:		spritemap
		piece	-8, 8, 2x3, 2, xflip
		piece	-8, $10, 2x3, 2, xflip
		piece	-4, $20, 1x2, 0, xflip
		piece	-5, $28, 2x2, $14, pal3
		endsprite
		
@pipe8:		spritemap
		piece	-$C, -8, 3x4, 8
		piece	-8, 8, 2x3, 2
		piece	-8, $10, 2x3, 2
		piece	-3, $20, 1x2, 0
		piece	-5, $28, 2x2, $14, pal3
		endsprite
		
@pipe9:		spritemap
		piece	-$C, -8, 3x4, 8, xflip
		piece	-8, 8, 2x3, 2, xflip
		piece	-8, $10, 2x3, 2, xflip
		piece	-4, $20, 1x2, 0, xflip
		piece	-5, $28, 2x2, $14, pal3
		endsprite
		
@pipe10:	spritemap
		piece	-$C, -$18, 3x4, 8
		piece	-$C, -9, 3x4, 8
		piece	-8, 8, 2x3, 2
		piece	-8, $F, 2x3, 2
		piece	-3, $20, 1x2, 0
		piece	-5, $28, 2x2, $14, pal3
		endsprite
		
@pipe11:	spritemap
		piece	-$C, -$19, 3x4, 8, xflip
		piece	-$C, -8, 3x4, 8, xflip
		piece	-8, 7, 2x3, 2, xflip
		piece	-8, $10, 2x3, 2, xflip
		piece	-4, $20, 1x2, 0, xflip
		piece	-5, $28, 2x2, $14, pal3
		endsprite
		
@valve1:	spritemap			; valve style flamethrower
		piece	-7, $28, 2x2, $18, pal3
		endsprite
		
@valve2:	spritemap
		piece	-7, $28, 2x2, $18, pal3
		piece	-3, $20, 1x2, 0
		endsprite
		
@valve3:	spritemap
		piece	-7, $28, 2x2, $18, pal3
		piece	-4, $20, 1x2, 0, xflip
		endsprite
		
@valve4:	spritemap
		piece	-8, $10, 2x3, 2
		piece	-7, $28, 2x2, $18, pal3
		piece	-3, $20, 1x2, 0
		endsprite
		
@valve5:	spritemap
		piece	-8, $10, 2x3, 2, xflip
		piece	-7, $28, 2x2, $18, pal3
		piece	-4, $20, 1x2, 0, xflip
		endsprite
		
@valve6:	spritemap
		piece	-8, 8, 2x3, 2
		piece	-8, $10, 2x3, 2
		piece	-7, $28, 2x2, $18, pal3
		piece	-3, $20, 1x2, 0
		endsprite
		
@valve7:	spritemap
		piece	-8, 8, 2x3, 2, xflip
		piece	-8, $10, 2x3, 2, xflip
		piece	-7, $28, 2x2, $18, pal3
		piece	-4, $20, 1x2, 0, xflip
		endsprite
		
@valve8:	spritemap
		piece	-$C, -8, 3x4, 8
		piece	-8, 8, 2x3, 2
		piece	-8, $10, 2x3, 2
		piece	-7, $28, 2x2, $18, pal3
		piece	-3, $20, 1x2, 0
		endsprite
@valve9:	spritemap

		piece	-$C, -8, 3x4, 8, xflip
		piece	-8, 8, 2x3, 2, xflip
		piece	-8, $10, 2x3, 2, xflip
		piece	-7, $28, 2x2, $18, pal3
		piece	-4, $20, 1x2, 0, xflip
		endsprite
		
@valve10:	spritemap
		piece	-$C, -$18, 3x4, 8
		piece	-$C, -9, 3x4, 8
		piece	-8, 8, 2x3, 2
		piece	-8, $F, 2x3, 2
		piece	-7, $28, 2x2, $18, pal3
		piece	-3, $20, 1x2, 0
		endsprite
		
@valve11:	spritemap
		piece	-$C, -$19, 3x4, 8, xflip
		piece	-$C, -8, 3x4, 8, xflip
		piece	-8, 7, 2x3, 2, xflip
		piece	-8, $10, 2x3, 2, xflip
		piece	-7, $28, 2x2, $18, pal3
		piece	-4, $20, 1x2, 0, xflip
		endsprite
		even
