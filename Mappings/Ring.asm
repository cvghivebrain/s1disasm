; ---------------------------------------------------------------------------
; Sprite mappings - rings
; ---------------------------------------------------------------------------
Map_Ring:	index *
		ptr frame_ring_front
		ptr frame_ring_angle1
		ptr frame_ring_edge
		ptr frame_ring_angle2
		ptr frame_ring_sparkle1
		ptr frame_ring_sparkle2
		ptr frame_ring_sparkle3
		ptr frame_ring_sparkle4
		if Revision>0
		ptr frame_ring_blank
		endc
		
frame_ring_front:
		spritemap					; ring front
		piece	-8, -8, 2x2, 0
		endsprite
		
frame_ring_angle1:
		spritemap					; ring angle
		piece	-8, -8, 2x2, 4
		endsprite
		
frame_ring_edge:
		spritemap					; ring perpendicular
		piece	-4, -8, 1x2, 8
		endsprite
		
frame_ring_angle2:
		spritemap					; ring angle
		piece	-8, -8, 2x2, 4, xflip
		endsprite
		
frame_ring_sparkle1:
		spritemap					; sparkle
		piece	-8, -8, 2x2, $A
		endsprite
		
frame_ring_sparkle2:
		spritemap					; sparkle
		piece	-8, -8, 2x2, $A, xflip, yflip
		endsprite
		
frame_ring_sparkle3:
		spritemap					;sparkle
		piece	-8, -8, 2x2, $A, xflip
		endsprite
		
frame_ring_sparkle4:
		spritemap					; sparkle
		piece	-8, -8, 2x2, $A, yflip
		endsprite
		
		if Revision>0
frame_ring_blank:
		spritemap
		endsprite
		endc
		even
