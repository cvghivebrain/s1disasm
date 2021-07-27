; ---------------------------------------------------------------------------
; Sprite mappings - metal pylons in foreground (SLZ)
; ---------------------------------------------------------------------------
		index *
		ptr @pylon
		
@pylon:		spritemap
		piece	-$10, -$80, 4x4, 0
		piece	-$10, -$60, 4x4, 0, yflip
		piece	-$10, -$40, 4x4, 0
		piece	-$10, -$20, 4x4, 0, yflip
		piece	-$10, 0, 4x4, 0
		piece	-$10, $20, 4x4, 0, yflip
		piece	-$10, $40, 4x4, 0
		piece	-$10, $60, 4x4, 0, yflip
		piece	-$10, $7F, 4x4, 0
		endsprite
		even
