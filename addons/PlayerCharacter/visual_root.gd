extends Node3D

@onready var small_size_scale: int = 1
@onready var large_size_scale: int = 4
@onready var current_size:sizes
@onready var changing_size:bool
@onready var transform_rate:float = 2

enum sizes {SMALL,LARGE}

func change_size(delta:float):
	if current_size == sizes.SMALL:
		scale = scale.move_toward(Vector3(1,1,1)*4, transform_rate * delta)
		if scale == Vector3(1,1,1)*4:
			current_size = sizes.LARGE
			changing_size = false
	else:
		scale = scale.move_toward(Vector3(1,1,1), transform_rate * delta)
		if scale == Vector3(1,1,1):
			current_size = sizes.SMALL
			changing_size = false


func _physics_process(delta: float) -> void:
	if changing_size:
		change_size(delta)

func toggle_size():
	changing_size = true
