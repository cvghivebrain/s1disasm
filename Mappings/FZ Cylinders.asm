; ---------------------------------------------------------------------------
; Sprite mappings - cylinders Eggman hides in (FZ)
; ---------------------------------------------------------------------------
		index *
		ptr @flat
		ptr @extending1
		ptr @extending2
		ptr @extending3
		ptr @extending4
		ptr @extendedfully
		ptr @extendedfully
		ptr @extendedfully
		ptr @extendedfully
		ptr @extendedfully
		ptr @extendedfully
		ptr @controlpanel
		
@flat:		spritemap
		piece	-$20, -$60, 4x2, 0, pal3
		piece	0, -$60, 4x2, 0, xflip, pal3
		piece	-$20, -$50, 4x1, 8, pal2
		piece	0, -$50, 4x1, $C, pal2
		piece	-$20, -$48, 4x4, $10, pal3
		piece	0, -$48, 4x4, $10, xflip, pal3
		endsprite
		
@extending1:	spritemap
		piece	-$20, -$60, 4x2, 0, pal3
		piece	0, -$60, 4x2, 0, xflip, pal3
		piece	-$20, -$50, 4x1, 8, pal2
		piece	0, -$50, 4x1, $C, pal2
		piece	-$20, -$48, 4x4, $10, pal3
		piece	0, -$48, 4x4, $10, xflip, pal3
		piece	-$20, -$28, 4x4, $20, pal3
		piece	0, -$28, 4x4, $20, xflip, pal3
		endsprite
		
@extending2:	spritemap
		piece	-$20, -$60, 4x2, 0, pal3
		piece	0, -$60, 4x2, 0, xflip, pal3
		piece	-$20, -$50, 4x1, 8, pal2
		piece	0, -$50, 4x1, $C, pal2
		piece	-$20, -$48, 4x4, $10, pal3
		piece	0, -$48, 4x4, $10, xflip, pal3
		piece	-$20, -$28, 4x4, $20, pal3
		piece	0, -$28, 4x4, $20, xflip, pal3
		piece	-$20, -8, 4x4, $30, pal3
		piece	0, -8, 4x4, $30, xflip, pal3
		endsprite
		
@extending3:	spritemap
		piece	-$20, -$60, 4x2, 0, pal3
		piece	0, -$60, 4x2, 0, xflip, pal3
		piece	-$20, -$50, 4x1, 8, pal2
		piece	0, -$50, 4x1, $C, pal2
		piece	-$20, -$48, 4x4, $10, pal3
		piece	0, -$48, 4x4, $10, xflip, pal3
		piece	-$20, -$28, 4x4, $20, pal3
		piece	0, -$28, 4x4, $20, xflip, pal3
		piece	-$20, -8, 4x4, $30, pal3
		piece	0, -8, 4x4, $30, xflip, pal3
		piece	-$20, $18, 4x4, $40, pal3
		piece	0, $18, 4x4, $40, xflip, pal3
		endsprite
		
@extending4:	spritemap
		piece	-$20, -$60, 4x2, 0, pal3
		piece	0, -$60, 4x2, 0, xflip, pal3
		piece	-$20, -$50, 4x1, 8, pal2
		piece	0, -$50, 4x1, $C, pal2
		piece	-$20, -$48, 4x4, $10, pal3
		piece	0, -$48, 4x4, $10, xflip, pal3
		piece	-$20, -$28, 4x4, $20, pal3
		piece	0, -$28, 4x4, $20, xflip, pal3
		piece	-$20, -8, 4x4, $30, pal3
		piece	0, -8, 4x4, $30, xflip, pal3
		piece	-$20, $18, 4x4, $40, pal3
		piece	0, $18, 4x4, $40, xflip, pal3
		piece	-$10, $38, 4x4, $50, pal3
		endsprite
		
@extendedfully:	spritemap
		piece	-$20, -$60, 4x2, 0, pal3
		piece	0, -$60, 4x2, 0, xflip, pal3
		piece	-$20, -$50, 4x1, 8, pal2
		piece	0, -$50, 4x1, $C, pal2
		piece	-$20, -$48, 4x4, $10, pal3
		piece	0, -$48, 4x4, $10, xflip, pal3
		piece	-$20, -$28, 4x4, $20, pal3
		piece	0, -$28, 4x4, $20, xflip, pal3
		piece	-$20, -8, 4x4, $30, pal3
		piece	0, -8, 4x4, $30, xflip, pal3
		piece	-$20, $18, 4x4, $40, pal3
		piece	0, $18, 4x4, $40, xflip, pal3
		piece	-$10, $38, 4x4, $50, pal3
		piece	-$10, $58, 4x4, $50, pal3
		endsprite
		
@controlpanel:	spritemap
		piece	-$10, -8, 2x1, $68
		piece	-$10, 0, 4x1, $6A
		endsprite
		even
