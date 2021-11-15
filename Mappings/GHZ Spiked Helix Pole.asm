; ---------------------------------------------------------------------------
; Sprite mappings - helix of spikes on a pole (GHZ)
; ---------------------------------------------------------------------------
Map_Hel:	index *
		ptr frame_helix_up
		ptr frame_helix_up45
		ptr frame_helix_90
		ptr frame_helix_down45
		ptr frame_helix_down
		ptr frame_helix_down45bg
		ptr frame_helix_bg
		ptr frame_helix_up45bg
		
frame_helix_up:
		spritemap					; points straight up (harmful)
		piece	-4, -$10, 1x2, 0
		endsprite
		
frame_helix_up45:
		spritemap					; 45 degree
		piece	-8, -$B, 2x2, 2
		endsprite
		
frame_helix_90:
		spritemap					; 90 degree
		piece	-8, -8, 2x2, 6
		endsprite
		
frame_helix_down45:
		spritemap					; 45 degree
		piece	-8, -5, 2x2, $A
		endsprite
		
frame_helix_down:
		spritemap					; straight down
		piece	-4, 0, 1x2, $E
		endsprite
		
frame_helix_down45bg:
		spritemap					; 45 degree
		piece	-3, 4, 1x1, $10
		endsprite
		
frame_helix_up45bg:
		spritemap					; 45 degree
frame_helix_bg:	equ *+1						; not visible (reads 0 byte from below)
		piece	-3, -$C, 1x1, $11
		endsprite
		even
