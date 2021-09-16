; ---------------------------------------------------------------------------
; Sprite mappings - Caterkiller	enemy (MZ, SBZ)
; ---------------------------------------------------------------------------
Map_Cat:	index *
		ptr frame_cat_head1	; 0
		ptr frame_cat_head2
		ptr frame_cat_head3
		ptr frame_cat_head4
		ptr frame_cat_head5
		ptr frame_cat_head6
		ptr frame_cat_head7
		ptr frame_cat_head8
		ptr frame_cat_body1	; 8
		ptr frame_cat_body2
		ptr frame_cat_body3
		ptr frame_cat_body4
		ptr frame_cat_body5
		ptr frame_cat_body6
		ptr frame_cat_body7
		ptr frame_cat_body8
		ptr frame_cat_mouth1	; $10
		ptr frame_cat_mouth2
		ptr frame_cat_mouth3
		ptr frame_cat_mouth4
		ptr frame_cat_mouth5
		ptr frame_cat_mouth6
		ptr frame_cat_mouth7
		ptr frame_cat_mouth8
		
frame_cat_head1:			; caterkiller head, mouth closed
		spritemap
		piece	-8, -$E, 2x3, 0
		endsprite
		
frame_cat_head2:
		spritemap
		piece	-8, -$F, 2x3, 0
		endsprite
		
frame_cat_head3:
		spritemap
		piece	-8, -$10, 2x3, 0
		endsprite
		
frame_cat_head4:
		spritemap
		piece	-8, -$11, 2x3, 0
		endsprite

frame_cat_head5:
		spritemap
		piece	-8, -$12, 2x3, 0
		endsprite
		
frame_cat_head6:
		spritemap
		piece	-8, -$13, 2x3, 0
		endsprite
		
frame_cat_head7:
		spritemap
		piece	-8, -$14, 2x3, 0
		endsprite
		
frame_cat_head8:
		spritemap
		piece	-8, -$15, 2x3, 0
		endsprite
		
frame_cat_body1:			; caterkiller body
		spritemap
		piece	-8, -8, 2x2, $C
		endsprite
		
frame_cat_body2:
		spritemap
		piece	-8, -9, 2x2, $C
		endsprite
		
frame_cat_body3:
		spritemap
		piece	-8, -$A, 2x2, $C
		endsprite
		
frame_cat_body4:
		spritemap
		piece	-8, -$B, 2x2, $C
		endsprite
		
frame_cat_body5:
		spritemap
		piece	-8, -$C, 2x2, $C
		endsprite
		
frame_cat_body6:
		spritemap
		piece	-8, -$D, 2x2, $C
		endsprite
		
frame_cat_body7:
		spritemap
		piece	-8, -$E, 2x2, $C
		endsprite
		
frame_cat_body8:
		spritemap
		piece	-8, -$F, 2x2, $C
		endsprite
		
frame_cat_mouth1:			; caterkiller head, mouth open
		spritemap
		piece	-8, -$E, 2x3, 6
		endsprite
		
frame_cat_mouth2:
		spritemap
		piece	-8, -$F, 2x3, 6
		endsprite
		
frame_cat_mouth3:
		spritemap
		piece	-8, -$10, 2x3, 6
		endsprite
		
frame_cat_mouth4:
		spritemap
		piece	-8, -$11, 2x3, 6
		endsprite
		
frame_cat_mouth5:
		spritemap
		piece	-8, -$12, 2x3, 6
		endsprite
		
frame_cat_mouth6:
		spritemap
		piece	-8, -$13, 2x3, 6
		endsprite
		
frame_cat_mouth7:
		spritemap
		piece	-8, -$14, 2x3, 6
		endsprite
		
frame_cat_mouth8:
		spritemap
		piece	-8, -$15, 2x3, 6
		endsprite
		even
