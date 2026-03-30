extends RayCast3D

var old_collider

# References
@onready var player_model_rotation = %VisualRoot

signal new_collider_found(collider)

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	set_rotation(player_model_rotation.get_rotation() + Vector3(0,-PI/2,0))
	var new_collider = get_collider()
	if new_collider != old_collider:
		old_collider = new_collider
		emit_signal("new_collider_found",new_collider)
