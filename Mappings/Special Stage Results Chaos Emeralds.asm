; ---------------------------------------------------------------------------
; Sprite mappings - chaos emeralds from	the special stage results screen
; ---------------------------------------------------------------------------
Map_SSRC:	index *
		ptr frame_ssrc_blue
		ptr frame_ssrc_yellow
		ptr frame_ssrc_pink
		ptr frame_ssrc_green
		ptr frame_ssrc_red
		ptr frame_ssrc_grey
		ptr frame_ssrc_blank
		
frame_ssrc_blue:
		spritemap
		piece -8, -8, 2x2, 4, pal2
		endsprite
		
frame_ssrc_yellow:
		spritemap
		piece -8, -8, 2x2, 0
		endsprite
		
frame_ssrc_pink:
		spritemap
		piece -8, -8, 2x2, 4, pal3
		endsprite
		
frame_ssrc_green:
		spritemap
		piece -8, -8, 2x2, 4, pal4
		endsprite
		
frame_ssrc_red:
		spritemap
		piece -8, -8, 2x2, 8, pal2
		endsprite
		
frame_ssrc_grey:
		spritemap
		piece -8, -8, 2x2, $C, pal2
		endsprite
		
frame_ssrc_blank:
		spritemap			; Blank frame
		endsprite
		even
