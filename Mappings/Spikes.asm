; ---------------------------------------------------------------------------
; Sprite mappings - spikes
; ---------------------------------------------------------------------------
Map_Spike:	index *
		ptr frame_spike_3up
		ptr frame_spike_3left
		ptr frame_spike_1up
		ptr frame_spike_3upwide
		ptr frame_spike_6upwide
		ptr frame_spike_1left
		
frame_spike_3up:
		spritemap			; 3 spikes
		piece	-$14, -$10, 1x4, 4
		piece	-4, -$10, 1x4, 4
		piece	$C, -$10, 1x4, 4
		endsprite
		
frame_spike_3left:
		spritemap			; 3 spikes facing sideways
		piece	-$10, -$14, 4x1, 0
		piece	-$10, -4, 4x1, 0
		piece	-$10, $C, 4x1, 0
		endsprite
		
frame_spike_1up:
		spritemap			; 1 spike
		piece	-4, -$10, 1x4, 4
		endsprite
		
frame_spike_3upwide:
		spritemap			; 3 spikes widely spaced
		piece	-$1C, -$10, 1x4, 4
		piece	-4, -$10, 1x4, 4
		piece	$14, -$10, 1x4, 4
		endsprite
		
frame_spike_6upwide:
		spritemap			; 6 spikes
		piece	-$40, -$10, 1x4, 4
		piece	-$28, -$10, 1x4, 4
		piece	-$10, -$10, 1x4, 4
		piece	8, -$10, 1x4, 4
		piece	$20, -$10, 1x4, 4
		piece	$38, -$10, 1x4, 4
		endsprite
		
frame_spike_1left:
		spritemap			; 1 spike facing sideways
		piece	-$10, -4, 4x1, 0
		endsprite
		even
