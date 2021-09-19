; ---------------------------------------------------------------------------
; Sprite mappings - cylinders Eggman hides in (FZ)
; ---------------------------------------------------------------------------
Map_EggCyl:	index *
		ptr frame_cylinder_flat
		ptr frame_cylinder_extending1
		ptr frame_cylinder_extending2
		ptr frame_cylinder_extending3
		ptr frame_cylinder_extending4
		ptr frame_cylinder_extendedfully
		ptr frame_cylinder_extendedfully
		ptr frame_cylinder_extendedfully
		ptr frame_cylinder_extendedfully
		ptr frame_cylinder_extendedfully
		ptr frame_cylinder_extendedfully
		ptr frame_cylinder_controlpanel
		
frame_cylinder_flat:
		spritemap
		piece	-$20, -$60, 4x2, 0, pal3
		piece	0, -$60, 4x2, 0, xflip, pal3
		piece	-$20, -$50, 4x1, 8, pal2
		piece	0, -$50, 4x1, $C, pal2
		piece	-$20, -$48, 4x4, $10, pal3
		piece	0, -$48, 4x4, $10, xflip, pal3
		endsprite
		
frame_cylinder_extending1:
		spritemap
		piece	-$20, -$60, 4x2, 0, pal3
		piece	0, -$60, 4x2, 0, xflip, pal3
		piece	-$20, -$50, 4x1, 8, pal2
		piece	0, -$50, 4x1, $C, pal2
		piece	-$20, -$48, 4x4, $10, pal3
		piece	0, -$48, 4x4, $10, xflip, pal3
		piece	-$20, -$28, 4x4, $20, pal3
		piece	0, -$28, 4x4, $20, xflip, pal3
		endsprite
		
frame_cylinder_extending2:
		spritemap
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
		
frame_cylinder_extending3:
		spritemap
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
		
frame_cylinder_extending4:
		spritemap
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
		
frame_cylinder_extendedfully:
		spritemap
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
		
frame_cylinder_controlpanel:
		spritemap
		piece	-$10, -8, 2x1, $68
		piece	-$10, 0, 4x1, $6A
		endsprite
		even
