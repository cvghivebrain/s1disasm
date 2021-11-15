; ---------------------------------------------------------------------------
; Sprite mappings - "PRESS START BUTTON" and "TM" from title screen
; ---------------------------------------------------------------------------
Map_PSB:	index *
		ptr frame_psb_blank
		ptr frame_psb_psb
		ptr frame_psb_mask
		ptr frame_psb_tm
		
frame_psb_psb:	spritemap					; "PRESS START BUTTON"
frame_psb_blank:
		piece	0, 0, 4x1, $F0
		piece	$20, 0, 1x1, $F3
		piece	$30, 0, 1x1, $F3
		piece	$38, 0, 4x1, $F4
		piece	$60, 0, 3x1, $F8
		piece	$78, 0, 3x1, $FB
		endsprite
		
frame_psb_mask:	spritemap					; sprite line limit mask
		piece	-$80, -$48, 4x4, 0
		piece	-$80, -$48, 4x4, 0
		piece	-$80, -$48, 4x4, 0
		piece	-$80, -$48, 4x4, 0
		piece	-$80, -$48, 4x4, 0
		piece	-$80, -$48, 4x4, 0
		piece	-$80, -$48, 4x4, 0
		piece	-$80, -$48, 4x4, 0
		piece	-$80, -$48, 4x4, 0
		piece	-$80, -$48, 4x4, 0
		piece	-$80, -$28, 4x4, 0
		piece	-$80, -$28, 4x4, 0
		piece	-$80, -$28, 4x4, 0
		piece	-$80, -$28, 4x4, 0
		piece	-$80, -$28, 4x4, 0
		piece	-$80, -$28, 4x4, 0
		piece	-$80, -$28, 4x4, 0
		piece	-$80, -$28, 4x4, 0
		piece	-$80, -$28, 4x4, 0
		piece	-$80, -$28, 4x4, 0
		piece	-$80, -8, 4x4, 0
		piece	-$80, -8, 4x4, 0
		piece	-$80, -8, 4x4, 0
		piece	-$80, -8, 4x4, 0
		piece	-$80, -8, 4x4, 0
		piece	-$80, -8, 4x4, 0
		piece	-$80, -8, 4x4, 0
		piece	-$80, -8, 4x4, 0
		piece	-$80, -8, 4x4, 0
		piece	-$80, -8, 4x4, 0
		endsprite
		
frame_psb_tm:	spritemap					; "TM"
		piece	-8, -4, 2x1, 0
		endsprite
		even
