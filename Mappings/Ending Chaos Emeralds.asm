; ---------------------------------------------------------------------------
; Sprite mappings - chaos emeralds on the ending sequence
; ---------------------------------------------------------------------------
Map_ECha:	index *
		ptr frame_echaos_flash
		ptr frame_echaos_blue
		ptr frame_echaos_yellow
		ptr frame_echaos_pink
		ptr frame_echaos_green
		ptr frame_echaos_red
		ptr frame_echaos_grey
		
frame_echaos_flash:			; unused
		spritemap
		piece	-8, -8, 2x2, 0
		endsprite
		
frame_echaos_blue:
		spritemap
		piece	-8, -8, 2x2, 4
		endsprite
		
frame_echaos_yellow:
		spritemap
		piece	-8, -8, 2x2, $10, pal3
		endsprite
		
frame_echaos_pink:
		spritemap
		piece	-8, -8, 2x2, $18, pal2
		endsprite
		
frame_echaos_green:
		spritemap
		piece	-8, -8, 2x2, $14, pal3
		endsprite
		
frame_echaos_red:
		spritemap
		piece	-8, -8, 2x2, 8
		endsprite
		
frame_echaos_grey:
		spritemap
		piece	-8, -8, 2x2, $C
		endsprite
		even
