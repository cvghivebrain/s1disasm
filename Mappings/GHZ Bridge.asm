; ---------------------------------------------------------------------------
; Sprite mappings - GHZ	bridge
; ---------------------------------------------------------------------------
Map_Bri:	index *
		ptr frame_bridge_log
		ptr frame_bridge_stump
		ptr frame_bridge_rope
		
frame_bridge_log:
		spritemap					; log
		piece	-8, -8, 2x2, 0
		endsprite
		
frame_bridge_stump:
		spritemap					; stump & rope
		piece	-$10, -8, 2x1, 4
		piece	-$10, 0, 4x1, 6
		endsprite
		
frame_bridge_rope:
		spritemap					; rope only
		piece	-8, -4, 2x1, 8
		endsprite
		even
