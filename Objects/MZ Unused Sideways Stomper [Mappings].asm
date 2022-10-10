; ---------------------------------------------------------------------------
; Sprite mappings - unused sideway-facing spiked stomper (MZ)
; ---------------------------------------------------------------------------

Map_SStom:	index offset(*)
		ptr frame_mash_block
		ptr frame_mash_spikes
		ptr frame_mash_wallbracket
		ptr frame_mash_pole1
		ptr frame_mash_pole2
		ptr frame_mash_pole3
		ptr frame_mash_pole4
		ptr frame_mash_pole5
		ptr frame_mash_pole5
		
frame_mash_block:
		spritemap					; main metal block
		piece	-$C, -$20, 3x4, $1F
		piece	-$C, 0, 3x4, $1F, yflip
		piece	$C, -$10, 1x4, $2B
		endsprite
		
frame_mash_spikes:
		spritemap					; three spikes
		piece	-$10, -$18, 4x1, $21B, yflip
		piece	-$10, -4, 4x1, $21B, yflip
		piece	-$10, $10, 4x1, $21B, yflip
		endsprite
		
frame_mash_wallbracket:
		spritemap					; thing holding it to the wall
		piece	-4, -$10, 1x4, $2B, xflip
		endsprite
		
frame_mash_pole1:
		spritemap					; poles of various lengths
		piece	-$20, -8, 2x2, $41
		piece	-$10, -8, 2x2, $41
		endsprite
		
frame_mash_pole2:
		spritemap
		piece	-$20, -8, 2x2, $41
		piece	-$10, -8, 2x2, $41
		piece	0, -8, 2x2, $41
		piece	$10, -8, 2x2, $41
		endsprite
		
frame_mash_pole3:
		spritemap
		piece	-$20, -8, 2x2, $41
		piece	-$10, -8, 2x2, $41
		piece	0, -8, 2x2, $41
		piece	$10, -8, 2x2, $41
		piece	$20, -8, 2x2, $41
		piece	$30, -8, 2x2, $41
		endsprite
		
frame_mash_pole4:
		spritemap
		piece	-$20, -8, 2x2, $41
		piece	-$10, -8, 2x2, $41
		piece	0, -8, 2x2, $41
		piece	$10, -8, 2x2, $41
		piece	$20, -8, 2x2, $41
		piece	$30, -8, 2x2, $41
		piece	$40, -8, 2x2, $41
		piece	$50, -8, 2x2, $41
		endsprite
		
frame_mash_pole5:
		spritemap					; incorrect: this should be $A
		piece	-$20, -8, 2x2, $41
		piece	-$10, -8, 2x2, $41
		piece	0, -8, 2x2, $41
		piece	$10, -8, 2x2, $41
		piece	$20, -8, 2x2, $41
		piece	$30, -8, 2x2, $41
		piece	$40, -8, 2x2, $41
		piece	$50, -8, 2x2, $41
		endsprite
		piece	$60, -8, 2x2, $41
		piece	$70, -8, 2x2, $41
		; frame_mash_pole6 should be here, but it isn't...
		even
