class_name AudioRoot extends Node3D

@export var sound_library: Dictionary[String, SoundArray] = {}

@export var audio_player:AudioStreamPlayer3D

func play_sound(name:String, pitch_range:Array = [1.0,1.0]):
	if sound_library.has(name):
		var stream:SoundArray = sound_library[name]
		audio_player.stream = stream.pick_random()
		audio_player.set_pitch_scale(randf_range(pitch_range[0], pitch_range[1]))
		audio_player.play()
	else:
		push_error("Sound '" + name + "' does not exist in the library.")

func is_playing():
	return audio_player.is_playing()

func stop():
	audio_player.stop()
