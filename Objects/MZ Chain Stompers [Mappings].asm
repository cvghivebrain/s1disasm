; ---------------------------------------------------------------------------
; Sprite mappings - metal stomping blocks on chains (MZ)
; ---------------------------------------------------------------------------
Map_CStom:	index *
		ptr frame_cstomp_wideblock			; 0
		ptr frame_cstomp_spikes				; 1
		ptr frame_cstomp_ceiling			; 2
		ptr frame_cstomp_chain1				; 3
		ptr frame_cstomp_chain2				; 4
		ptr frame_cstomp_chain3				; 5
		ptr frame_cstomp_chain4				; 6
		ptr frame_cstomp_chain5				; 7
		ptr frame_cstomp_chain5				; 8
		ptr frame_cstomp_mediumblock			; 9
		ptr frame_cstomp_smallblock			; $A
		
frame_cstomp_wideblock:
		spritemap
		piece	-$38, -$C, 2x3, 0
		piece	-$28, -$C, 3x3, 6
		piece	-$10, -$14, 4x4, $F
		piece	$10, -$C, 3x3, 6, xflip
		piece	$28, -$C, 2x3, 0, xflip
		endsprite
		
frame_cstomp_spikes:
		spritemap
		piece	-$2C, -$10, 1x4, $21F, yflip
		piece	-$18, -$10, 1x4, $21F, yflip
		piece	-4, -$10, 1x4, $21F, yflip
		piece	$10, -$10, 1x4, $21F, yflip
		piece	$24, -$10, 1x4, $21F, yflip
		endsprite
		
frame_cstomp_ceiling:
		spritemap
		piece	-$10, -$24, 4x4, $F, yflip
		endsprite
		
frame_cstomp_chain1:
		spritemap
		piece	-4, 0, 1x2, $3F
		piece	-4, $10, 1x2, $3F
		endsprite
		
frame_cstomp_chain2:
		spritemap
		piece	-4, -$20, 1x2, $3F
		piece	-4, -$10, 1x2, $3F
		piece	-4, 0, 1x2, $3F
		piece	-4, $10, 1x2, $3F
		endsprite
		
frame_cstomp_chain3:
		spritemap
		piece	-4, -$40, 1x2, $3F
		piece	-4, -$30, 1x2, $3F
		piece	-4, -$20, 1x2, $3F
		piece	-4, -$10, 1x2, $3F
		piece	-4, 0, 1x2, $3F
		piece	-4, $10, 1x2, $3F
		endsprite
		
frame_cstomp_chain4:
		spritemap
		piece	-4, -$60, 1x2, $3F
		piece	-4, -$50, 1x2, $3F
		piece	-4, -$40, 1x2, $3F
		piece	-4, -$30, 1x2, $3F
		piece	-4, -$20, 1x2, $3F
		piece	-4, -$10, 1x2, $3F
		piece	-4, 0, 1x2, $3F
		piece	-4, $10, 1x2, $3F
		endsprite
		
frame_cstomp_chain5:
		spritemap
		piece	-4, -$80, 1x2, $3F
		piece	-4, -$70, 1x2, $3F
		piece	-4, -$60, 1x2, $3F
		piece	-4, -$50, 1x2, $3F
		piece	-4, -$40, 1x2, $3F
		piece	-4, -$30, 1x2, $3F
		piece	-4, -$20, 1x2, $3F
		piece	-4, -$10, 1x2, $3F
		piece	-4, 0, 1x2, $3F
		piece	-4, $10, 1x2, $3F
		endsprite
		
frame_cstomp_mediumblock:
		spritemap
		piece	-$30, -$C, 2x3, 0
		piece	-$20, -$C, 3x3, 6
		piece	8, -$C, 3x3, 6, xflip
		piece	$20, -$C, 2x3, 0, xflip
		piece	-$10, -$14, 4x4, $F
		endsprite
		
frame_cstomp_smallblock:
		spritemap
		piece	-$10, -$14, 4x4, $2F
		endsprite
		even
