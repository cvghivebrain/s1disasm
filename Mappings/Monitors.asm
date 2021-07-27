; ---------------------------------------------------------------------------
; Sprite mappings - monitors
; ---------------------------------------------------------------------------
		index *
		ptr @static0
		ptr @static1
		ptr @static2
		ptr @eggman
		ptr @sonic
		ptr @shoes
		ptr @shield
		ptr @invincible
		ptr @rings
		ptr @s
		ptr @goggles
		ptr @broken
		
@static0:	spritemap			; static monitor
		piece	-$10, -$11, 4x4, 0
		endsprite
		
@static1:	spritemap			; static monitor
		piece	-8, -$B, 2x2, $10
		piece	-$10, -$11, 4x4, 0
		endsprite
		
@static2:	spritemap			; static monitor
		piece	-8, -$B, 2x2, $14
		piece	-$10, -$11, 4x4, 0
		endsprite
		
@eggman:	spritemap			; Eggman monitor
		piece	-8, -$B, 2x2, $18
		piece	-$10, -$11, 4x4, 0
		endsprite
		
@sonic:		spritemap			; Sonic	monitor
		piece	-8, -$B, 2x2, $1C
		piece	-$10, -$11, 4x4, 0
		endsprite
		
@shoes:		spritemap			; speed	shoes monitor
		piece	-8, -$B, 2x2, $24
		piece	-$10, -$11, 4x4, 0
		endsprite
		
@shield:	spritemap			; shield monitor
		piece	-8, -$B, 2x2, $28
		piece	-$10, -$11, 4x4, 0
		endsprite
		
@invincible:	spritemap			; invincibility	monitor
		piece	-8, -$B, 2x2, $2C
		piece	-$10, -$11, 4x4, 0
		endsprite
		
@rings:		spritemap			; 10 rings monitor
		piece	-8, -$B, 2x2, $30
		piece	-$10, -$11, 4x4, 0
		endsprite
		
@s:		spritemap			; 'S' monitor
		piece	-8, -$B, 2x2, $34
		piece	-$10, -$11, 4x4, 0
		endsprite
		
@goggles:	spritemap			; goggles monitor
		piece	-8, -$B, 2x2, $20
		piece	-$10, -$11, 4x4, 0
		endsprite
		
@broken:	spritemap			; broken monitor
		piece	-$10, -1, 4x2, $38
		endsprite
		even
