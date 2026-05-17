extends Node3D

@export var spin_rate : float
@onready var hitbox : BaseHitbox = $MeshInstance3D/MeshInstance3D/BaseHitbox

#func _ready() -> void:
	#hitbox.set_knockback_direction()
	#hitbox.set_knockback_amount()

func _physics_process(delta: float) -> void:
	rotation.z -= deg_to_rad(spin_rate) * delta
