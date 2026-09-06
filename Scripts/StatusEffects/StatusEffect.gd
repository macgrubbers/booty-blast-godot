class_name StatusEffect extends Resource

@export var effect_name: String = "Effect"
@export var duration: float = 0.0 # -1 means lasts forever
@export var stackable: bool = false

var time_remaining: float = 0.0
var is_expired:bool = false
var target: CharacterBody3D

func apply(char: CharacterBody3D) -> void:
	target = char
	time_remaining = duration

func update(delta: float) -> void:
	if duration < -0.5:
		return
	else:
		time_remaining -= delta
		if time_remaining <= 0:
			is_expired = true

func remove() -> void:
	pass
