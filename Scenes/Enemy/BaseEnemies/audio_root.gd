extends Node3D

var sound_library : Dictionary = {
	"chatter": [preload("res://Sounds/Goober/chatter01.wav"),
				preload("res://Sounds/Goober/chatter02.wav"),
				preload("res://Sounds/Goober/chatter03.wav")],
	"surprise": [preload("res://Sounds/Goober/surprise.wav")],
	"death": [preload("res://Sounds/Goober/death.wav")]
	}

@onready var audio_player = $AudioStreamPlayer3D

func play_sound(name:String):
	if sound_library.has(name):
		var stream = sound_library[name]
		if stream is AudioStream:
			audio_player.stream = stream
			audio_player.play()
		else:
			push_warning("Sound '" + name + "' is empty in the library.")
	else:
		push_error("Sound '" + name + "' does not exist in the library.")
