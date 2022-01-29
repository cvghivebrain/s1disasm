; ---------------------------------------------------------------------------
; Object 29 - points that appear when you destroy something

; spawned by:
;	Animals, SmashBlock, Bumper
; ---------------------------------------------------------------------------

Points:
		moveq	#0,d0
		move.b	ost_routine(a0),d0
		move.w	Poi_Index(pc,d0.w),d1
		jsr	Poi_Index(pc,d1.w)
		bra.w	DisplaySprite
; ===========================================================================
Poi_Index:	index *,,2
		ptr Poi_Main
		ptr Poi_Slower
; ===========================================================================

Poi_Main:	; Routine 0
		addq.b	#2,ost_routine(a0)			; goto Poi_Slower next
		move.l	#Map_Points,ost_mappings(a0)
		move.w	#tile_Nem_Points+tile_pal2,ost_tile(a0)
		move.b	#render_rel,ost_render(a0)
		move.b	#1,ost_priority(a0)
		move.b	#8,ost_actwidth(a0)
		move.w	#-$300,ost_y_vel(a0)			; move object upwards

Poi_Slower:	; Routine 2
		tst.w	ost_y_vel(a0)				; is object moving?
		bpl.w	DeleteObject				; if not, delete
		bsr.w	SpeedToPos				; update position
		addi.w	#$18,ost_y_vel(a0)			; reduce object speed
		rts	

; ---------------------------------------------------------------------------
; Sprite mappings
; ---------------------------------------------------------------------------

include_Points_mappings:	macro

Map_Points:	index *
		ptr frame_points_100
		ptr frame_points_200
		ptr frame_points_500
		ptr frame_points_1k
		ptr frame_points_10
		ptr frame_points_10k
		ptr frame_points_100k
		
frame_points_100:
		spritemap					; 100 points
		piece	-8, -4, 2x1, 0
		endsprite
		
frame_points_200:
		spritemap					; 200 points
		piece	-8, -4, 2x1, 2
		endsprite
		
frame_points_500:
		spritemap					; 500 points
		piece	-8, -4, 2x1, 4
		endsprite
		
frame_points_1k:
		spritemap					; 1000 points
		piece	-8, -4, 3x1, 6
		endsprite
		
frame_points_10:
		spritemap					; 10 points
		piece	-4, -4, 1x1, 6
		endsprite
		
frame_points_10k:
		spritemap					; 10,000 points
		piece	-$C, -4, 3x1, 6
		piece	1, -4, 2x1, 7
		endsprite
		
frame_points_100k:
		spritemap					; 100,000 points
		piece	-$C, -4, 3x1, 6
		piece	6, -4, 2x1, 7
		endsprite
		even

		endm
