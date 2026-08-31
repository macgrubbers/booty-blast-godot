class_name BaseStatusEffect extends Resource

@export var effect_name: String = "Effect"
@export var duration: float = 5.0 # -1 means lasts forever
@export var stackable: bool = false

var time_remaining: float = 0.0
var target: CharacterBody3D

func apply(char: CharacterBody3D) -> void:
	target = char
	time_remaining = duration

func update(delta: float) -> void:
	if duration != -1:
		time_remaining -= delta

func remove() -> void:
	pass
