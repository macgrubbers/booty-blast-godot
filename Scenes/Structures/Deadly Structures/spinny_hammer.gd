extends Node3D

@export var spin_rate : float

func _physics_process(delta: float) -> void:
	rotation.z -= deg_to_rad(spin_rate) * delta
