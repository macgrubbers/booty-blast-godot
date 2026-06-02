class_name BaseCollectable extends RigidBody3D

var num_ticks_skip:int = 5
var num_ticks:int = 0
@export var spin_rate : float = 720
var physicsable:bool = false

func collect():
	cleanup()

func cleanup():
	queue_free()

func _physics_process(delta: float) -> void:
	if num_ticks >= num_ticks_skip and !physicsable:
		rotation.y -= deg_to_rad(spin_rate) * delta
		num_ticks = 0
	num_ticks+=1

func set_physicsable(val:bool):
	if val:
		physicsable = true
		set_gravity_scale(1.0)
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, true)
		set_collision_mask_value(3, true)
	else:
		physicsable = false
		set_gravity_scale(0.0)
