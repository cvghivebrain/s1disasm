; ---------------------------------------------------------------------------
; Sprite mappings - helix of spikes on a pole (GHZ)
; ---------------------------------------------------------------------------
		index *
		ptr byte_7E08
		ptr byte_7E0E
		ptr byte_7E14
		ptr byte_7E1A
		ptr byte_7E20
		ptr byte_7E26
		ptr byte_7E2E
		ptr byte_7E2C
		
byte_7E08:	spritemap		; points straight up (harmful)
		piece	-4, -$10, 1x2, 0
		endsprite
		
byte_7E0E:	spritemap		; 45 degree
		piece	-8, -$B, 2x2, 2
		endsprite
		
byte_7E14:	spritemap		; 90 degree
		piece	-8, -8, 2x2, 6
		endsprite
		
byte_7E1A:	spritemap		; 45 degree
		piece	-8, -5, 2x2, $A
		endsprite
		
byte_7E20:	spritemap		; straight down
		piece	-4, 0, 1x2, $E
		endsprite
		
byte_7E26:	spritemap		; 45 degree
		piece	-3, 4, 1x1, $10
		endsprite
		
byte_7E2C:	spritemap		; 45 degree
byte_7E2E:	equ *+1			; not visible (reads 0 byte from below)
		piece	-3, -$C, 1x1, $11
		endsprite
		even
