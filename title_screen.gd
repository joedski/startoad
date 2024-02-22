extends CanvasLayer

var rng = RandomNumberGenerator.new()
var devices: PackedStringArray
# Called when the node enters the scene tree for the first time.
func _ready():
	_check_devices()
	_generate_twinkle_stars()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _generate_twinkle_stars():
	# We are set to 640/360
	# TwinkleStars are 16x16
	# Add 20 stars across, at various 
	for s in range(8, 640-8, 32):
		var ts = load("res://twinkle_star.tscn").instantiate()
		ts.position = Vector2(s, rng.randf_range(8, 360-8))
		$Space.add_child(ts)
	pass

func _check_devices():
	OS.open_midi_inputs()
	devices = OS.get_connected_midi_inputs()
	var device_count = devices.size()

	if device_count == 0:
		$MIDIDevicesLabel.text = "No MIDI devices found!"
		$MIDIScanButton.show()
	elif devices.bsearch("M8") >= 0:
		$MIDIDevicesLabel.text = "M8 detected!"
		$MIDIScanButton.hide()
	else:
		$MIDIDevicesLabel.text = "Non-M8 MIDI detected!"
		$MIDIScanButton.hide()
		


func _on_midi_scan_button_pressed():
	_check_devices()

# ========

func _input(event):
	if event is InputEventMIDI:
		#_print_midi_info(event)
		match event.channel:
			0:
				_input_tod_rhythm(event)
			1:
				_input_tod_lead_jig(event)
			2:
				_input_tod_lead_croak(event)
			_:
				pass

		match event.message:
			MIDI_MESSAGE_TIMING_CLOCK:
				pass
			MIDI_MESSAGE_PROGRAM_CHANGE:
				pass
			MIDI_MESSAGE_NOTE_ON:
				print(event)
			MIDI_MESSAGE_NOTE_OFF:
				print(event)
			_:
				#_print_midi_info(event)
				#print(event)
				pass
		
## Handle input events for Tod Rhythm
## pitch is mostly 33 (A-3) and 28 (E-3) but others are in there too
## velocity is always 100 because I'm boring like that
func _input_tod_rhythm(event: InputEventMIDI):
	match event.message:
		MIDI_MESSAGE_NOTE_ON:
			# print("Tod Rhythm " + str(event.pitch))
			var sprite_animation = $TodRhythm/AnimationPlayer as AnimationPlayer
			sprite_animation.play("croak")
			sprite_animation.seek(0.0)
			
			# Prepare squish animation.
			# 28 (E-3) -> -0.4
			# 33 (A-3) -> 0.1
			# delta is 5.
			var tod = $TodRhythm
			tod.squish_amplitude = ((clampf(float(event.pitch), 28.0, 35.0) - 28.0) / 10.0 - 0.5) * 1.2
			
			var squish_animation = $TodRhythm/SquishAnimationPlayer as AnimationPlayer
			squish_animation.play("squish")
			squish_animation.seek(0.0)

		# Rhythm always just one-shots, so note-off is irrelevant.
		MIDI_MESSAGE_NOTE_OFF:
			pass

## Specifically handle events for making Tod Lead just jiggy about
func _input_tod_lead_jig(event: InputEventMIDI):
	match event.message:
		MIDI_MESSAGE_NOTE_ON:
			#print("Tod Lead " + str(event.pitch))
			# - N goes from C-1 to C-9 mapping to … not quite sure what skew values are, but 0.5 ”left” (CCW) to 0.5 ”right”. (CW)
			# - V goes from 0x01 To 0x7f mapping to -0.5 Y to 0.5 Y.
			var note_skew = float(event.pitch) / 96. - 0.5
			var velo_scale = float(event.velocity) / 128. - 0.5
			var deflate_player = $Node2D/TodLead/DeflationAnimationPlayer as AnimationPlayer
			$Node2D/TodLead.dest_coords = Vector2(note_skew, velo_scale)
			deflate_player.play("deflate")
			deflate_player.seek(0.)
			
		MIDI_MESSAGE_NOTE_OFF:
			#print("Tod Lead OFF")
			$Node2D/TodLead.dest_coords = Vector2(0., 0.)
			($Node2D/TodLead/DeflationAnimationPlayer as AnimationPlayer).play("RESET")

## Specifically handle events for Tod Lead croaking.
## This is the same as Tod Lead jiggying about but more wobbly.
func _input_tod_lead_croak(event: InputEventMIDI):
	match event.message:
		MIDI_MESSAGE_NOTE_ON:
			#print("Tod Lead " + str(event.pitch))
			# - N goes from C-1 to C-9 mapping to … not quite sure what skew values are, but 0.5 ”left” (CCW) to 0.5 ”right”. (CW)
			# - V goes from 0x01 To 0x7f mapping to -0.5 Y to 0.5 Y.
			var note_skew = float(event.pitch) / 96. - 0.5
			var velo_scale = float(event.velocity) / 128. - 0.5
			var deflate_player = $Node2D/TodLead/DeflationAnimationPlayer as AnimationPlayer
			var sprite_player = $Node2D/TodLead/AnimationPlayer as AnimationPlayer
			$Node2D/TodLead.dest_coords = Vector2(note_skew, velo_scale)
			sprite_player.play("vibe")
			deflate_player.play("deflate")
			deflate_player.seek(0.)
			
		MIDI_MESSAGE_NOTE_OFF:
			#print("Tod Lead OFF")
			$Node2D/TodLead.dest_coords = Vector2(0., 0.)
			($Node2D/TodLead/DeflationAnimationPlayer as AnimationPlayer).play("RESET")
			($Node2D/TodLead/AnimationPlayer as AnimationPlayer).play("RESET")

#func _change_scene(pc):
	#pass
	
func _print_midi_info(midi_event: InputEventMIDI):
	print("--- MIDI Event from Title Screen ---")
	print(midi_event)
	print("Channel " + str(midi_event.channel))
	print("Message " + str(midi_event.message))
	print("Pitch " + str(midi_event.pitch))
	print("Velocity " + str(midi_event.velocity))
	print("Instrument " + str(midi_event.instrument))
	print("Pressure " + str(midi_event.pressure))
	print("Controller number: " + str(midi_event.controller_number))
	print("Controller value: " + str(midi_event.controller_value))
