; ---------------------------------------------------------------------------
; Sprite mappings - "SONIC TEAM	PRESENTS" and credits
; ---------------------------------------------------------------------------
Map_Cred:	index offset(*)
		ptr frame_cred_staff
		ptr frame_cred_gameplan
		ptr frame_cred_program
		ptr frame_cred_character
		ptr frame_cred_design
		ptr frame_cred_soundproduce
		ptr frame_cred_soundprogram
		ptr frame_cred_thanks
		ptr frame_cred_presentedby
		ptr frame_cred_tryagain
		ptr frame_cred_sonicteam
		
frame_cred_staff:
		spritemap					; SONIC TEAM STAFF
		piece	-$78, -8, 2x2, $2E
		piece	-$68, -8, 2x2, $26
		piece	-$58, -8, 2x2, $1A
		piece	-$48, -8, 1x2, $46
		piece	-$40, -8, 2x2, $1E
		piece	-$28, -8, 2x2, $3E
		piece	-$18, -8, 2x2, $E
		piece	-8, -8, 2x2, 4
		piece	8, -8, 3x2, 8
		piece	$28, -8, 2x2, $2E
		piece	$38, -8, 2x2, $3E
		piece	$48, -8, 2x2, 4
		piece	$58, -8, 2x2, $5C
		piece	$68, -8, 2x2, $5C
		endsprite
		
frame_cred_gameplan:
		spritemap					; GAME PLAN CAROL YAS
		piece	-$80, -$28, 2x2, 0
		piece	-$70, -$28, 2x2, 4
		piece	-$60, -$28, 3x2, 8
		piece	-$4C, -$28, 2x2, $E
		piece	-$30, -$28, 2x2, $12
		piece	-$20, -$28, 2x2, $16
		piece	-$10, -$28, 2x2, 4
		piece	0, -$28, 2x2, $1A
		piece	-$38, 8, 2x2, $1E
		piece	-$28, 8, 2x2, 4
		piece	-$18, 8, 2x2, $22
		piece	-8, 8, 2x2, $26
		piece	8, 8, 2x2, $16
		piece	$20, 8, 2x2, $2A
		piece	$30, 8, 2x2, 4
		piece	$44, 8, 2x2, $2E
		endsprite
		
frame_cred_program:
		spritemap					; PROGRAM YU 2
		piece	-$80, -$28, 2x2, $12
		piece	-$70, -$28, 2x2, $22
		piece	-$60, -$28, 2x2, $26
		piece	-$50, -$28, 2x2, 0
		piece	-$40, -$28, 2x2, $22
		piece	-$30, -$28, 2x2, 4
		piece	-$20, -$28, 3x2, 8
		piece	-$18, 8, 2x2, $2A
		piece	-8, 8, 2x2, $32
		piece	8, 8, 2x2, $36
		endsprite
		
frame_cred_character:
		spritemap					; CHARACTER DESIGN BIGISLAND
		piece	-$78, -$28, 2x2, $1E
		piece	-$68, -$28, 2x2, $3A
		piece	-$58, -$28, 2x2, 4
		piece	-$48, -$28, 2x2, $22
		piece	-$38, -$28, 2x2, 4
		piece	-$28, -$28, 2x2, $1E
		piece	-$18, -$28, 2x2, $3E
		piece	-8, -$28, 2x2, $E
		piece	8, -$28, 2x2, $22
		piece	$20, -$28, 2x2, $42
		piece	$30, -$28, 2x2, $E
		piece	$40, -$28, 2x2, $2E
		piece	$50, -$28, 1x2, $46
		piece	$58, -$28, 2x2, 0
		piece	$68, -$28, 2x2, $1A
		piece	-$40, 8, 2x2, $48
		piece	-$30, 8, 1x2, $46
		piece	-$28, 8, 2x2, 0
		piece	-$18, 8, 1x2, $46
		piece	-$10, 8, 2x2, $2E
		piece	0, 8, 2x2, $16
		piece	$10, 8, 2x2, 4
		piece	$20, 8, 2x2, $1A
		piece	$30, 8, 2x2, $42
		endsprite
		
frame_cred_design:
		spritemap					; DESIGN JINYA	PHENIX RIE
		piece	-$60, -$30, 2x2, $42
		piece	-$50, -$30, 2x2, $E
		piece	-$40, -$30, 2x2, $2E
		piece	-$30, -$30, 1x2, $46
		piece	-$28, -$30, 2x2, 0
		piece	-$18, -$30, 2x2, $1A
		piece	-$18, 0, 2x2, $4C
		piece	-8, 0, 1x2, $46
		piece	4, 0, 2x2, $1A
		piece	$14, 0, 2x2, $2A
		piece	$24, 0, 2x2, 4
		piece	-$30, $20, 2x2, $12
		piece	-$20, $20, 2x2, $3A
		piece	-$10, $20, 2x2, $E
		piece	0, $20, 2x2, $1A
		piece	$10, $20, 1x2, $46
		piece	$18, $20, 2x2, $50
		piece	$30, $20, 2x2, $22
		piece	$40, $20, 1x2, $46
		piece	$48, $20, 2x2, $E
		endsprite
		
frame_cred_soundproduce:
		spritemap					; SOUND PRODUCE MASATO	NAKAMURA
		piece	-$68, -$28, 2x2, $2E
		piece	-$58, -$28, 2x2, $26
		piece	-$48, -$28, 2x2, $32
		piece	-$38, -$28, 2x2, $1A
		piece	-$28, -$28, 2x2, $54
		piece	-8, -$28, 2x2, $12
		piece	8, -$28, 2x2, $22
		piece	$18, -$28, 2x2, $26
		piece	$28, -$28, 2x2, $42
		piece	$38, -$28, 2x2, $32
		piece	$48, -$28, 2x2, $1E
		piece	$58, -$28, 2x2, $E
		piece	-$78, 8, 3x2, 8
		piece	-$64, 8, 2x2, 4
		piece	-$54, 8, 2x2, $2E
		piece	-$44, 8, 2x2, 4
		piece	-$34, 8, 2x2, $3E
		piece	-$24, 8, 2x2, $26
		piece	-8, 8, 2x2, $1A
		piece	8, 8, 2x2, 4
		piece	$18, 8, 2x2, $58
		piece	$28, 8, 2x2, 4
		piece	$38, 8, 3x2, 8
		piece	$4C, 8, 2x2, $32
		piece	$5C, 8, 2x2, $22
		piece	$6C, 8, 2x2, 4
		endsprite
		
frame_cred_soundprogram:
		spritemap					; SOUND PROGRAM JIMITA	MACKY
		piece	-$68, -$30, 2x2, $2E
		piece	-$58, -$30, 2x2, $26
		piece	-$48, -$30, 2x2, $32
		piece	-$38, -$30, 2x2, $1A
		piece	-$28, -$30, 2x2, $54
		piece	-8, -$30, 2x2, $12
		piece	8, -$30, 2x2, $22
		piece	$18, -$30, 2x2, $26
		piece	$28, -$30, 2x2, 0
		piece	$38, -$30, 2x2, $22
		piece	$48, -$30, 2x2, 4
		piece	$58, -$30, 3x2, 8
		piece	-$30, 0, 2x2, $4C
		piece	-$20, 0, 1x2, $46
		piece	-$18, 0, 3x2, 8
		piece	-4, 0, 1x2, $46
		piece	4, 0, 2x2, $3E
		piece	$14, 0, 2x2, 4
		piece	-$30, $20, 3x2, 8
		piece	-$1C, $20, 2x2, 4
		piece	-$C, $20, 2x2, $1E
		piece	4, $20, 2x2, $58
		piece	$14, $20, 2x2, $2A
		endsprite
		
frame_cred_thanks:
		spritemap					; SPECIAL THANKS FUJIO	MINEGISHI PAPA
		piece	-$80, -$28, 2x2, $2E
		piece	-$70, -$28, 2x2, $12
		piece	-$60, -$28, 2x2, $E
		piece	-$50, -$28, 2x2, $1E
		piece	-$40, -$28, 1x2, $46
		piece	-$38, -$28, 2x2, 4
		piece	-$28, -$28, 2x2, $16
		piece	-8, -$28, 2x2, $3E
		piece	8, -$28, 2x2, $3A
		piece	$18, -$28, 2x2, 4
		piece	$28, -$28, 2x2, $1A
		piece	$38, -$28, 2x2, $58
		piece	$48, -$28, 2x2, $2E
		piece	-$50, 0, 2x2, $5C
		piece	-$40, 0, 2x2, $32
		piece	-$30, 0, 2x2, $4C
		piece	-$20, 0, 1x2, $46
		piece	-$18, 0, 2x2, $26
		piece	0, 0, 3x2, 8
		piece	$14, 0, 1x2, $46
		piece	$1C, 0, 2x2, $1A
		piece	$2C, 0, 2x2, $E
		piece	$3C, 0, 2x2, 0
		piece	$4C, 0, 1x2, $46
		piece	$54, 0, 2x2, $2E
		piece	$64, 0, 2x2, $3A
		piece	$74, 0, 1x2, $46
		piece	-8, $20, 2x2, $12
		piece	8, $20, 2x2, 4
		piece	$18, $20, 2x2, $12
		piece	$28, $20, 2x2, 4
		endsprite
		
frame_cred_presentedby:
		spritemap					; PRESENTED BY SEGA
		piece	-$80, -8, 2x2, $12
		piece	-$70, -8, 2x2, $22
		piece	-$60, -8, 2x2, $E
		piece	-$50, -8, 2x2, $2E
		piece	-$40, -8, 2x2, $E
		piece	-$30, -8, 2x2, $1A
		piece	-$20, -8, 2x2, $3E
		piece	-$10, -8, 2x2, $E
		piece	0, -8, 2x2, $42
		piece	$18, -8, 2x2, $48
		piece	$28, -8, 2x2, $2A
		piece	$40, -8, 2x2, $2E
		piece	$50, -8, 2x2, $E
		piece	$60, -8, 2x2, 0
		piece	$70, -8, 2x2, 4
		endsprite
		
frame_cred_tryagain:
		spritemap					; TRY AGAIN
		piece	-$40, $30, 2x2, $3E
		piece	-$30, $30, 2x2, $22
		piece	-$20, $30, 2x2, $2A
		piece	-8, $30, 2x2, 4
		piece	8, $30, 2x2, 0
		piece	$18, $30, 2x2, 4
		piece	$28, $30, 1x2, $46
		piece	$30, $30, 2x2, $1A
		endsprite
		
frame_cred_sonicteam:
		spritemap					; SONIC TEAM PRESENTS
		piece	-$4C, -$18, 2x2, $2E
		piece	-$3C, -$18, 2x2, $26
		piece	-$2C, -$18, 2x2, $1A
		piece	-$1C, -$18, 1x2, $46
		piece	-$14, -$18, 2x2, $1E
		piece	4, -$18, 2x2, $3E
		piece	$14, -$18, 2x2, $E
		piece	$24, -$18, 2x2, 4
		piece	$34, -$18, 3x2, 8
		piece	-$40, 0, 2x2, $12
		piece	-$30, 0, 2x2, $22
		piece	-$20, 0, 2x2, $E
		piece	-$10, 0, 2x2, $2E
		piece	0, 0, 2x2, $E
		piece	$10, 0, 2x2, $1A
		piece	$20, 0, 2x2, $3E
		piece	$30, 0, 2x2, $2E
		endsprite
		even
