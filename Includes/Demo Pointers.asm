; ---------------------------------------------------------------------------
; Demo level list
; ---------------------------------------------------------------------------

include_demo_list:	macro
DemoLevelArray:
		dc.w id_GHZ_act1				; Green Hill Zone, act 1
		dc.w id_MZ_act1					; Marble Zone, act 1
		dc.w id_SYZ_act1				; Spring Yard Zone, act 1
		dc.w id_Demo_SS					; Special Stage ($0600)
		endm

; ---------------------------------------------------------------------------
; Demo data pointers (these are hardcoded to match zone numbers)
; ---------------------------------------------------------------------------

include_demo_pointers:	macro
DemoDataPtr:	index.l 0,,$100					; longword, absolute, ids multiplied by $100
		ptr Demo_GHZ					; 0 - GHZ act 1
		ptr Demo_GHZ					; 1 - unused
		ptr Demo_MZ					; 2 - MZ act 1
		ptr Demo_MZ					; 3 - unused
		ptr Demo_SYZ					; 4 - SYZ act 1
		ptr Demo_SYZ					; 5 - unused
		ptr Demo_SS					; 6 - Special Stage
		ptr Demo_SS					; 7 - unused

; ---------------------------------------------------------------------------
; Ending demo data pointers
; ---------------------------------------------------------------------------

DemoEndDataPtr:	index.l 0
		ptr Demo_EndGHZ1
		ptr Demo_EndMZ
		ptr Demo_EndSYZ
		ptr Demo_EndLZ
		ptr Demo_EndSLZ
		ptr Demo_EndSBZ1
		ptr Demo_EndSBZ2
		ptr Demo_EndGHZ2
		endm

; ---------------------------------------------------------------------------
; Ending demo level list
; ---------------------------------------------------------------------------

include_enddemo_list:	macro
EndDemoList:
		dc.w id_GHZ_act1				; Green Hill Zone, act 1
		dc.w id_MZ_act2					; Marble Zone, act 2
		dc.w id_SYZ_act3				; Spring Yard Zone, act 3
		dc.w id_LZ_act3					; Labyrinth Zone, act 3
		dc.w id_SLZ_act3				; Star Light Zone, act 3
		dc.w id_SBZ_act1				; Scrap Brain Zone, act 1
		dc.w id_SBZ_act2				; Scrap Brain Zone, act 2
		dc.w id_GHZ_act1				; Green Hill Zone, act 1
	EndDemoList_end:
		endm

sizeof_EndDemoList:	equ EndDemoList_end-EndDemoList
