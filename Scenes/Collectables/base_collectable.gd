class_name BaseCollectable extends RigidBody3D

@export var physicsable:bool = false

func _ready() -> void:
	if physicsable:
		set_gravity_scale(1.0)
		set_collision_mask_value(1, true)
		print(global_position)

func collect():
	cleanup()


func cleanup():
	queue_free()
