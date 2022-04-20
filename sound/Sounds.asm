; ===========================================================================
; ---------------------------------------------------------------------------
; Macro for playing a sound or a command
; ---------------------------------------------------------------------------

play:		macro	queue, command, song
		move.\0	#\song,d0				; load the song to d0

		if (\queue < 0) | (\queue > v_soundqueue_size)
		inform 2,"Invalid or undefined sound queue slot. Must be between 0 and \#v_soundqueue_size"
		endc

		\command	PlaySound\queue			; call playsound based on the slot ID
		endm

; ---------------------------------------------------------------------------
; Define background music
;
; By default, range from $81 to $9F. The first entries have lower ID.
; Files will be loaded from "sound/music/(name).bin". Must not contain spaces!
; Constants for IDs are: mus_(name)
; This special macro is used to generate pointers, includes and constants
;
; line format: \func	sound file, sound priority, speed shoes tempo
;
; NOTE: speed shoes tempo is missing in a few lines; In the original game, for
; some reason these were not filled in. This is a bug. Do not intentionally
; leave some values out whenever you modify the game!
; ---------------------------------------------------------------------------

MusicFiles:	macro	func					; TODO: Find suitable speed-up tempos for the remaining entries
		\func	GHZ, $90, $07				; Green Hill Zone music
		\func	LZ, $90, $72				; Labyrinth Zone music
		\func	MZ, $90, $73				; Marble Zone music
		\func	SLZ, $90, $26				; Star Light Zone music
		\func	SYZ, $90, $15				; Spring Yard Zone music
		\func	SBZ, $90, $08				; Scrap Brain Zone music
		\func	Invincible, $90, $FF			; Invincibility music
		\func	ExtraLife, $90, $05			; Extra Life music
		\func	SpecialStage, $90,			; $00	; Special Stage music
		\func	TitleScreen, $90,			; $00	; Title Screen music
		\func	Ending, $90,				; $00	; Ending music
		\func	Boss, $90,				; $00	; Boss music
		\func	FZ, $90,				; $00	; Final Zone music
		\func	HasPassed, $90,				; $00	; Act Finished music
		\func	GameOver, $90,				; $00	; Game Over music
		\func	Continue, $90,				; $00	; Continue music
		\func	Credits, $90,				; $00	; Credits music
		\func	Drowning, $90,				; $00	; Drowning music
		\func	Emerald, $90,				; $00	; Emerald music
		endm

; ---------------------------------------------------------------------------
; Define sound effects
;
; By default, range from $A0 to $CF. The first entries have lower ID.
; Files will be loaded from "sound/sfx/(name).bin". Must not contain spaces!
; Constants for IDs are: sfx_(name)
; This special macro is used to generate pointers, includes and constants
;
; line format: \func	sound file, sound priority
; ---------------------------------------------------------------------------

SfxFiles:	macro	func
		\func	Jump, $80				; Jumping sound effect
		\func	Lamppost, $70				; Hitting a lamp post sound effect
		\func	UnkA2, $70				; Unknown sound effect
		\func	Death, $70				; Death sound effect
		\func	Skid, $70				; Skidding sound effect
		\func	BuzzExplode, $70			; Buzzbomber projectile explosion sound effect
		\func	SpikeHit, $70				; Hitting spikes sound effect
		\func	Push, $70				; Pushing block sound effect
		\func	Goal, $70				; Special Stage goal block sound effect
		\func	ActionBlock, $70			; Special Stage action block sound effect
		\func	Splash, $68				; Splash sound effect
		\func	UnkAB, $70				; Unknown sound effect
		\func	BossHit, $70				; Hitting a boss sound effect
		\func	Bubble, $70				; Bubble sound effect
		\func	FireBall, $60				; Lava ball and gargoyle sound effect
		\func	Shield, $70				; Shield get sound effect
		\func	Saw, $70				; Saw sound effect
		\func	Electricity, $60			; Electricity sound effect
		\func	Drown, $70				; Drowning sound effect
		\func	Flame, $60				; Flame sound effect
		\func	Bumper, $70				; Hitting a bumper sound effect
		\func	Ring, $70				; Ring in the right speaker sound effect
		\func	SpikeMove, $70				; Spike moving sound effect
		\func	Rumbling, $70				; Rumbling sound effect
		\func	UnkB8, $70				; Unknown sound effect
		\func	Collapse, $70				; Collapsing sound effect
		\func	Diamonds, $70				; Special Stage diamond sound effect
		\func	Door, $70				; Door sound effect
		\func	Dash, $70				; Dashing and teleporting sound effect
		\func	ChainStomp, $70				; MZ chain stomping sound effect
		\func	Roll, $70				; Roll sound effect
		\func	Continue, $7F				; Continue sound effect
		\func	Basaran, $60				; Basaran sound effect
		\func	Break, $70				; Break items and kill enemies sound effect
		\func	Ding, $70				; Warning ding for drowining sound effect
		\func	GiantRing, $70				; Giant Ring sound effect
		\func	Bomb, $70				; Bomb explosion sound effect
		\func	Register, $70				; Cash register sound effect
		\func	RingLoss, $70				; Losing rings sound effect
		\func	ChainRise, $70				; MZ chain rising sound effect
		\func	Burning, $70				; Geyser and fireball sound effect
		\func	Bonus, $70				; Hidden bonus sound effect
		\func	EnterSS, $70				; Enter Special Stage sound effect
		\func	Smash, $70				; Wall smashing sound effect
		\func	Spring, $70				; Spring sound effect
		\func	Switch, $70				; Switch sound effect
		\func	RingLeft, $70				; Ring in the left speaker sound effect
		\func	Signpost, $70				; Signpost sound effect
		endm

; ---------------------------------------------------------------------------
; Define special sound effects
;
; By default, range from $D0 to $DF. The first entries have lower ID.
; Files will be loaded from "sound/sfx/(name).bin". Must not contain spaces!
; Constants for IDs are: sfx_(name)
; This special macro is used to generate pointers, includes and constants
;
; line format: \func	sound file, sound priority
; ---------------------------------------------------------------------------

SpecSfxFiles:	macro	func
		\func	Waterfall, $80				; Waterfall sound effect
		endm

; ---------------------------------------------------------------------------
; Define driver commands
;
; By default, range from $E0 to $E5. The first entries have lower ID.
; Must not contain spaces!
; Constants for IDs are: cmd_(name)
; This special macro is used to generate constants
;
; line format: \func	command name, command priority
; ---------------------------------------------------------------------------

DriverCmdFiles:	macro	func
		\func	Fade, $90				; Fade out music command
		\func	Sega, $90				; Sega sample command
		\func	Speedup, $90				; Speed shoes enable command
		\func	Slowdown, $90				; Speed shoes disable command
		\func	Stop, $90				; Stop all music and sfx command
		endm
