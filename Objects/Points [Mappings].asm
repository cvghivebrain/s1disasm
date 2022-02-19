; ---------------------------------------------------------------------------
; Sprite mappings - points that appear when you destroy something
; ---------------------------------------------------------------------------

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
