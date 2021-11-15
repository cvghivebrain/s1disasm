; ---------------------------------------------------------------------------
; Sprite mappings - flame thrower (SBZ)
; ---------------------------------------------------------------------------
Map_Flame:	index *
		ptr frame_flame_pipe1
		ptr frame_flame_pipe2
		ptr frame_flame_pipe3
		ptr frame_flame_pipe4
		ptr frame_flame_pipe5
		ptr frame_flame_pipe6
		ptr frame_flame_pipe7
		ptr frame_flame_pipe8
		ptr frame_flame_pipe9
		ptr frame_flame_pipe10
		ptr frame_flame_pipe11				; $A
		ptr frame_flame_valve1
		ptr frame_flame_valve2
		ptr frame_flame_valve3
		ptr frame_flame_valve4
		ptr frame_flame_valve5
		ptr frame_flame_valve6
		ptr frame_flame_valve7
		ptr frame_flame_valve8
		ptr frame_flame_valve9
		ptr frame_flame_valve10
		ptr frame_flame_valve11				; $15
frame_flame_pipe1:
		spritemap					; broken pipe style flamethrower
		piece	-5, $28, 2x2, $14, pal3
		endsprite
		
frame_flame_pipe2:
		spritemap
		piece	-3, $20, 1x2, 0
		piece	-5, $28, 2x2, $14, pal3
		endsprite
		
frame_flame_pipe3:
		spritemap
		piece	-4, $20, 1x2, 0, xflip
		piece	-5, $28, 2x2, $14, pal3
		endsprite
		
frame_flame_pipe4:
		spritemap
		piece	-8, $10, 2x3, 2
		piece	-3, $20, 1x2, 0
		piece	-5, $28, 2x2, $14, pal3
		endsprite
		
frame_flame_pipe5:
		spritemap
		piece	-8, $10, 2x3, 2, xflip
		piece	-4, $20, 1x2, 0, xflip
		piece	-5, $28, 2x2, $14, pal3
		endsprite
		
frame_flame_pipe6:
		spritemap
		piece	-8, 8, 2x3, 2
		piece	-8, $10, 2x3, 2
		piece	-3, $20, 1x2, 0
		piece	-5, $28, 2x2, $14, pal3
		endsprite
		
frame_flame_pipe7:
		spritemap
		piece	-8, 8, 2x3, 2, xflip
		piece	-8, $10, 2x3, 2, xflip
		piece	-4, $20, 1x2, 0, xflip
		piece	-5, $28, 2x2, $14, pal3
		endsprite
		
frame_flame_pipe8:
		spritemap
		piece	-$C, -8, 3x4, 8
		piece	-8, 8, 2x3, 2
		piece	-8, $10, 2x3, 2
		piece	-3, $20, 1x2, 0
		piece	-5, $28, 2x2, $14, pal3
		endsprite
		
frame_flame_pipe9:
		spritemap
		piece	-$C, -8, 3x4, 8, xflip
		piece	-8, 8, 2x3, 2, xflip
		piece	-8, $10, 2x3, 2, xflip
		piece	-4, $20, 1x2, 0, xflip
		piece	-5, $28, 2x2, $14, pal3
		endsprite
		
frame_flame_pipe10:
		spritemap
		piece	-$C, -$18, 3x4, 8
		piece	-$C, -9, 3x4, 8
		piece	-8, 8, 2x3, 2
		piece	-8, $F, 2x3, 2
		piece	-3, $20, 1x2, 0
		piece	-5, $28, 2x2, $14, pal3
		endsprite
		
frame_flame_pipe11:
		spritemap
		piece	-$C, -$19, 3x4, 8, xflip
		piece	-$C, -8, 3x4, 8, xflip
		piece	-8, 7, 2x3, 2, xflip
		piece	-8, $10, 2x3, 2, xflip
		piece	-4, $20, 1x2, 0, xflip
		piece	-5, $28, 2x2, $14, pal3
		endsprite
		
frame_flame_valve1:
		spritemap					; valve style flamethrower
		piece	-7, $28, 2x2, $18, pal3
		endsprite
		
frame_flame_valve2:
		spritemap
		piece	-7, $28, 2x2, $18, pal3
		piece	-3, $20, 1x2, 0
		endsprite
		
frame_flame_valve3:
		spritemap
		piece	-7, $28, 2x2, $18, pal3
		piece	-4, $20, 1x2, 0, xflip
		endsprite
		
frame_flame_valve4:
		spritemap
		piece	-8, $10, 2x3, 2
		piece	-7, $28, 2x2, $18, pal3
		piece	-3, $20, 1x2, 0
		endsprite
		
frame_flame_valve5:
		spritemap
		piece	-8, $10, 2x3, 2, xflip
		piece	-7, $28, 2x2, $18, pal3
		piece	-4, $20, 1x2, 0, xflip
		endsprite
		
frame_flame_valve6:
		spritemap
		piece	-8, 8, 2x3, 2
		piece	-8, $10, 2x3, 2
		piece	-7, $28, 2x2, $18, pal3
		piece	-3, $20, 1x2, 0
		endsprite
		
frame_flame_valve7:
		spritemap
		piece	-8, 8, 2x3, 2, xflip
		piece	-8, $10, 2x3, 2, xflip
		piece	-7, $28, 2x2, $18, pal3
		piece	-4, $20, 1x2, 0, xflip
		endsprite
		
frame_flame_valve8:
		spritemap
		piece	-$C, -8, 3x4, 8
		piece	-8, 8, 2x3, 2
		piece	-8, $10, 2x3, 2
		piece	-7, $28, 2x2, $18, pal3
		piece	-3, $20, 1x2, 0
		endsprite

frame_flame_valve9:
		spritemap
		piece	-$C, -8, 3x4, 8, xflip
		piece	-8, 8, 2x3, 2, xflip
		piece	-8, $10, 2x3, 2, xflip
		piece	-7, $28, 2x2, $18, pal3
		piece	-4, $20, 1x2, 0, xflip
		endsprite
		
frame_flame_valve10:
		spritemap
		piece	-$C, -$18, 3x4, 8
		piece	-$C, -9, 3x4, 8
		piece	-8, 8, 2x3, 2
		piece	-8, $F, 2x3, 2
		piece	-7, $28, 2x2, $18, pal3
		piece	-3, $20, 1x2, 0
		endsprite
		
frame_flame_valve11:
		spritemap
		piece	-$C, -$19, 3x4, 8, xflip
		piece	-$C, -8, 3x4, 8, xflip
		piece	-8, 7, 2x3, 2, xflip
		piece	-8, $10, 2x3, 2, xflip
		piece	-7, $28, 2x2, $18, pal3
		piece	-4, $20, 1x2, 0, xflip
		endsprite
		even
