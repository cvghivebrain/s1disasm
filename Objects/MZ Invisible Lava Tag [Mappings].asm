; ---------------------------------------------------------------------------
; Sprite mappings - invisible lava tag (MZ)
; ---------------------------------------------------------------------------
Map_LTag:	index offset(*)
		ptr frame_lavatag_0
		
frame_lavatag_0:
		spritemap					; no sprite, because the tag is invisible!
		endsprite
		even
