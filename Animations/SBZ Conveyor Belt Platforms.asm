; ---------------------------------------------------------------------------
; Animation script - platform on conveyor belt (SBZ)
; ---------------------------------------------------------------------------
		index *
		ptr @spin
		ptr @still
		
@spin:		dc.b 0,	0, 1, 2, 3, 4, 3+afyflip, 2+afyflip, 1+afyflip, 0+afyflip, 1+afxflip+afyflip, 2+afxflip+afyflip, 3+afxflip+afyflip
		dc.b 4+afxflip+afyflip, 3+afxflip, 2+afxflip, 1+afxflip, 0, afEnd
		even
@still:		dc.b $F, 0, afEnd
		even
