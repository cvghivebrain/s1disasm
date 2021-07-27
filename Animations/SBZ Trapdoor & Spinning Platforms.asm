; ---------------------------------------------------------------------------
; Animation script - trapdoor (SBZ)
; ---------------------------------------------------------------------------
		index *
		ptr @trapopen
		ptr @trapclose
		ptr @spin1
		ptr @spin2
		
@trapopen:	dc.b 3,	0, 1, 2, afBack, 1
@trapclose:	dc.b 3,	2, 1, 0, afBack, 1
@spin1:		dc.b 1,	0, 1, 2, 3, 4, 3+afyflip, 2+afyflip, 1+afyflip, 0+afyflip, 1+afxflip+afyflip, 2+afxflip+afyflip, 3+afxflip+afyflip, 4+afxflip+afyflip, 3+afxflip, 2+afxflip, 1+afxflip, 0, afBack, 1
@spin2:		dc.b 1,	0, 1, 2, 3, 4, 3+afyflip, 2+afyflip, 1+afyflip, 0+afyflip, 1+afxflip+afyflip, 2+afxflip+afyflip, 3+afxflip+afyflip, 4+afxflip+afyflip, 3+afxflip, 2+afxflip, 1+afxflip, 0, afBack, 1
		even
