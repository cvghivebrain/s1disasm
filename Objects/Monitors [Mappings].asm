; ---------------------------------------------------------------------------
; Sprite mappings - monitors
; ---------------------------------------------------------------------------
Map_Monitor:	index offset(*)
		ptr frame_monitor_static0
		ptr frame_monitor_static1
		ptr frame_monitor_static2
		ptr frame_monitor_eggman
		ptr frame_monitor_sonic
		ptr frame_monitor_shoes
		ptr frame_monitor_shield
		ptr frame_monitor_invincible
		ptr frame_monitor_rings
		ptr frame_monitor_s
		ptr frame_monitor_goggles
		ptr frame_monitor_broken
		
frame_monitor_static0:
		spritemap					; static monitor
		piece	-$10, -$11, 4x4, 0
		endsprite
		
frame_monitor_static1:
		spritemap					; static monitor
		piece	-8, -$B, 2x2, $10
		piece	-$10, -$11, 4x4, 0
		endsprite
		
frame_monitor_static2:
		spritemap					; static monitor
		piece	-8, -$B, 2x2, $14
		piece	-$10, -$11, 4x4, 0
		endsprite
		
frame_monitor_eggman:
		spritemap					; Eggman monitor
		piece	-8, -$B, 2x2, $18
		piece	-$10, -$11, 4x4, 0
		endsprite
		
frame_monitor_sonic:
		spritemap					; Sonic	monitor
		piece	-8, -$B, 2x2, $1C
		piece	-$10, -$11, 4x4, 0
		endsprite
		
frame_monitor_shoes:
		spritemap					; speed	shoes monitor
		piece	-8, -$B, 2x2, $24
		piece	-$10, -$11, 4x4, 0
		endsprite
		
frame_monitor_shield:
		spritemap					; shield monitor
		piece	-8, -$B, 2x2, $28
		piece	-$10, -$11, 4x4, 0
		endsprite
		
frame_monitor_invincible:
		spritemap					; invincibility	monitor
		piece	-8, -$B, 2x2, $2C
		piece	-$10, -$11, 4x4, 0
		endsprite
		
frame_monitor_rings:
		spritemap					; 10 rings monitor
		piece	-8, -$B, 2x2, $30
		piece	-$10, -$11, 4x4, 0
		endsprite
		
frame_monitor_s:
		spritemap					; 'S' monitor
		piece	-8, -$B, 2x2, $34
		piece	-$10, -$11, 4x4, 0
		endsprite
		
frame_monitor_goggles:
		spritemap					; goggles monitor
		piece	-8, -$B, 2x2, $20
		piece	-$10, -$11, 4x4, 0
		endsprite
		
frame_monitor_broken:
		spritemap					; broken monitor
		piece	-$10, -1, 4x2, $38
		endsprite
		even
