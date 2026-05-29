class_name BaseCollectable extends RigidBody3D

var num_ticks_skip:int = 5
var num_ticks:int = 0
@export var spin_rate : float = 720
@export var physicsable:bool = false

func _ready() -> void:
	if physicsable:
		set_gravity_scale(1.0)
		set_collision_mask_value(1, true)

func collect():
	cleanup()

func cleanup():
	queue_free()

func _physics_process(delta: float) -> void:
	if num_ticks >= num_ticks_skip and !physicsable:
		rotation.y -= deg_to_rad(spin_rate) * delta
		num_ticks = 0
	num_ticks+=1
