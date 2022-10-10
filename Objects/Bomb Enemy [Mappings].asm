; ---------------------------------------------------------------------------
; Sprite mappings - walking bomb enemy (SLZ, SBZ)
; ---------------------------------------------------------------------------
Map_Bomb:	index offset(*)
		ptr frame_bomb_stand1
		ptr frame_bomb_stand2
		ptr frame_bomb_walk1
		ptr frame_bomb_walk2
		ptr frame_bomb_walk3
		ptr frame_bomb_walk4
		ptr frame_bomb_activate1
		ptr frame_bomb_activate2
		ptr frame_bomb_fuse1
		ptr frame_bomb_fuse2
		ptr frame_bomb_shrapnel1
		ptr frame_bomb_shrapnel2
		
frame_bomb_stand1:
		spritemap					; bomb standing still
		piece	-$C, -$F, 3x3, 0
		piece	-$C, 9, 3x1, $12
		piece	-4, -$19, 1x2, $21
		endsprite
		
frame_bomb_stand2:
		spritemap
		piece	-$C, -$F, 3x3, 9
		piece	-$C, 9, 3x1, $12
		piece	-4, -$19, 1x2, $21
		endsprite
		
frame_bomb_walk1:
		spritemap					; bomb walking
		piece	-$C, -$10, 3x3, 0
		piece	-$C, 8, 3x1, $15
		piece	-4, -$1A, 1x2, $21
		endsprite
		
frame_bomb_walk2:
		spritemap
		piece	-$C, -$F, 3x3, 9
		piece	-$C, 9, 3x1, $18
		piece	-4, -$19, 1x2, $21
		endsprite
		
frame_bomb_walk3:
		spritemap
		piece	-$C, -$10, 3x3, 0
		piece	-$C, 8, 3x1, $1B
		piece	-4, -$1A, 1x2, $21
		endsprite
		
frame_bomb_walk4:
		spritemap
		piece	-$C, -$F, 3x3, 9
		piece	-$C, 9, 3x1, $1E
		piece	-4, -$19, 1x2, $21
		endsprite
		
frame_bomb_activate1:
		spritemap					; bomb during detonation countdown
		piece	-$C, -$F, 3x3, 0
		piece	-$C, 9, 3x1, $12
		endsprite
		
frame_bomb_activate2:
		spritemap
		piece	-$C, -$F, 3x3, 9
		piece	-$C, 9, 3x1, $12
		endsprite
		
frame_bomb_fuse1:
		spritemap					; fuse (just before it explodes)
		piece	-4, -$19, 1x2, $23
		endsprite
		
frame_bomb_fuse2:
		spritemap
		piece	-4, -$19, 1x2, $25
		endsprite
		
frame_bomb_shrapnel1:
		spritemap					; shrapnel (after it exploded)
		piece	-4, -4, 1x1, $27
		endsprite
		
frame_bomb_shrapnel2:
		spritemap
		piece	-4, -4, 1x1, $28
		endsprite
		even
