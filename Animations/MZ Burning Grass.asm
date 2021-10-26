; ---------------------------------------------------------------------------
; Animation script - burning grass that sits on the floor (MZ)
; ---------------------------------------------------------------------------
Ani_GFire:	index *
		ptr @burn
		
@burn:		dc.b 5,	0, 0+afxflip, 1, 1+afxflip, afEnd
		even
