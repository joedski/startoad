extends CanvasLayer

var bps = float(0)
var bps_counter = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.open_midi_inputs()
	print(OS.get_connected_midi_inputs())
	$PulseAnimation.speed_scale = bps
	$PulseAnimation.play("pulse")
	pass # Replace with function body.

func _input(event):
	if event is InputEventMIDI:
		var midi_event = event as InputEventMIDI
		#print(midi_event)
		#print("Channel " + str(midi_event.channel))
		#print("Message " + str(midi_event.message))
		match event.message:
			MIDI_MESSAGE_TIMING_CLOCK:
				bps_counter += 1
			_:
				pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_bpm_timer_timeout():
	bps = float(bps_counter) / float(48)
	#print("BPS: " + str(bps))
	#print("BPM: " + str(bps * 60))
	$PulseAnimation.speed_scale = bps	
	bps_counter = 0

