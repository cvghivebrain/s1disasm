; ---------------------------------------------------------------------------
; Animation script - Sonic
; ---------------------------------------------------------------------------
		index *
		ptr Walk
		ptr Run
		ptr Roll
		ptr Roll2
		ptr Pushing
		ptr Wait
		ptr Balance
		ptr LookUp
		ptr Duck
		ptr Warp1
		ptr Warp2
		ptr Warp3
		ptr Warp4
		ptr Stop
		ptr Float1
		ptr Float2
		ptr Spring
		ptr Hang
		ptr Leap1
		ptr Leap2
		ptr Surf
		ptr GetAir
		ptr Burnt
		ptr Drown
		ptr Death
		ptr Shrink
		ptr Hurt
		ptr WaterSlide
		ptr Blank
		ptr Float3
		ptr Float4

Walk:		dc.b $FF, id_frame_walk13, id_frame_walk14, id_frame_walk15, id_frame_walk16, id_frame_walk11, id_frame_walk12, afEnd
		even
Run:		dc.b $FF, id_frame_run11, id_frame_run12, id_frame_run13, id_frame_run14, afEnd, afEnd, afEnd
		even
Roll:		dc.b $FE, id_frame_Roll1, id_frame_Roll2, id_frame_Roll3, id_frame_Roll4, id_frame_Roll5, afEnd, afEnd
		even
Roll2:		dc.b $FE, id_frame_Roll1, id_frame_Roll2, id_frame_Roll5, id_frame_Roll3, id_frame_Roll4, id_frame_Roll5, afEnd
		even
Pushing:	dc.b $FD, id_frame_push1, id_frame_push2, id_frame_push3, id_frame_push4, afEnd, afEnd, afEnd
		even
Wait:		dc.b $17, id_frame_stand, id_frame_stand, id_frame_stand, id_frame_stand, id_frame_stand, id_frame_stand, id_frame_stand, id_frame_stand, id_frame_stand
		dc.b id_frame_stand, id_frame_stand, id_frame_stand, id_frame_wait2, id_frame_wait1, id_frame_wait1, id_frame_wait1, id_frame_wait2, id_frame_wait3, afBack, 2
		even
Balance:	dc.b $1F, id_frame_balance1, id_frame_balance2, afEnd
		even
LookUp:		dc.b $3F, id_frame_lookup, afEnd
		even
Duck:		dc.b $3F, id_frame_duck, afEnd
		even
Warp1:		dc.b $3F, id_frame_warp1, afEnd
		even
Warp2:		dc.b $3F, id_frame_warp2, afEnd
		even
Warp3:		dc.b $3F, id_frame_warp3, afEnd
		even
Warp4:		dc.b $3F, id_frame_warp4, afEnd
		even
Stop:		dc.b 7,	id_frame_stop1, id_frame_stop2, afEnd
		even
Float1:		dc.b 7,	id_frame_float1, id_frame_float4, afEnd
		even
Float2:		dc.b 7,	id_frame_float1, id_frame_float2, id_frame_float5, id_frame_float3, id_frame_float6, afEnd
		even
Spring:		dc.b $2F, id_frame_spring, afChange, id_Walk
		even
Hang:		dc.b 4,	id_frame_hang1, id_frame_hang2, afEnd
		even
Leap1:		dc.b $F, id_frame_leap1, id_frame_leap1, id_frame_leap1, afBack, 1
		even
Leap2:		dc.b $F, id_frame_leap1, id_frame_leap2, afBack, 1
		even
Surf:		dc.b $3F, id_frame_surf, afEnd
		even
GetAir:		dc.b $B, id_frame_getair, id_frame_getair, id_frame_walk15, id_frame_walk16, afChange, id_Walk
		even
Burnt:		dc.b $20, id_frame_burnt, afEnd
		even
Drown:		dc.b $2F, id_frame_drown, afEnd
		even
Death:		dc.b 3,	id_frame_death, afEnd
		even
Shrink:		dc.b 3,	id_frame_shrink1, id_frame_shrink2, id_frame_shrink3, id_frame_shrink4, id_frame_shrink5, id_frame_blank, afBack, 1
		even
Hurt:		dc.b 3,	id_frame_injury, afEnd
		even
WaterSlide:	dc.b 7, id_frame_injury, id_frame_waterslide, afEnd
		even
Blank:		dc.b $77, id_frame_blank, afChange, id_Walk
		even
Float3:		dc.b 3,	id_frame_float1, id_frame_float2, id_frame_float5, id_frame_float3, id_frame_float6, afEnd
		even
Float4:		dc.b 3,	id_frame_float1, afChange, id_Walk
		even
