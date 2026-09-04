class_name SoundArray extends Resource
@export var sound_array:Array[AudioStream]

func pick_random():
	return sound_array.pick_random()
