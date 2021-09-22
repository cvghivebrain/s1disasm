; ---------------------------------------------------------------------------
; Sprite mappings - trapdoor (SBZ)
; ---------------------------------------------------------------------------
Map_Trap:	index *
		ptr frame_trap_closed
		ptr frame_trap_half
		ptr frame_trap_open
		
frame_trap_closed:
		spritemap
		piece	-$40, -$C, 4x3, 0
		piece	-$20, -$C, 4x3, 0, xflip
		piece	0, -$C, 4x3, 0
		piece	$20, -$C, 4x3, 0, xflip
		endsprite
		
frame_trap_half:
		spritemap
		piece	-$4A, -$E, 4x4, $C
		piece	-$2A, $1A, 4x4, $C, xflip, yflip
		piece	-$2A, 2, 3x3, $1C
		piece	-$42, $12, 3x3, $1C, xflip, yflip
		piece	$2A, -$E, 4x4, $C, xflip
		piece	$A, $1A, 4x4, $C, yflip
		piece	$12, 2, 3x3, $1C, xflip
		piece	$2A, $12, 3x3, $1C, yflip
		endsprite
		
frame_trap_open:
		spritemap
		piece	-$4C, 0, 3x4, $25
		piece	-$4C, $20, 3x4, $25, yflip
		piece	$34, 0, 3x4, $25
		piece	$34, $20, 3x4, $25, yflip
		endsprite
		even
