extends Node3D

@export var spin_rate : float


func _ready() -> void:
	$Sketchfab_Scene/BaseHitbox.knockback_dir = Vector3(-1,0,0)

func _physics_process(delta: float) -> void:
	rotation.z -= deg_to_rad(spin_rate) * delta
	
