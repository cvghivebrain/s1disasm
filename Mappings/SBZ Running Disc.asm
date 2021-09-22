; ---------------------------------------------------------------------------
; Sprite mappings - disc that you run around (SBZ)
; (It's just a small blob that moves around in a circle. The disc itself is
; part of the level tiles.)
; ---------------------------------------------------------------------------
Map_Disc:	index *
		ptr frame_disc_spot
		
frame_disc_spot:
		spritemap
		piece	-8, -8, 2x2, 0
		endsprite
		even
