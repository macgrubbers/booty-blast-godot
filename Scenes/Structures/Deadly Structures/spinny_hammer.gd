extends Node3D

@export var activatable:bool = false
@export var is_spinning:bool = false
@export var use_timer:bool = false
@export var timer_duration:float = 0
@export var spin_rate : float
@onready var hitbox : BaseHitbox = $MeshInstance3D/MeshInstance3D/BaseHitbox
@onready var timer : Timer = $Timer

func _ready() -> void:
	timer.connect("timeout", _on_timer_timeout)
	timer.set_wait_time(timer_duration)
	#hitbox.set_knockback_direction()
	#hitbox.set_knockback_amount()

func _physics_process(delta: float) -> void:
	if is_spinning:
		rotation.z -= deg_to_rad(spin_rate) * delta

func activate():
	is_spinning = true
	if use_timer:
		timer.start()

func _on_timer_timeout():
	is_spinning = false
