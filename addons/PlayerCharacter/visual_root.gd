extends Node3D

@onready var shadow_raycast:RayCast3D = %ShadowRaycast
@onready var shadow:Decal = $Shadow


func _physics_process(delta: float) -> void:
	var raycast_result = shadow_raycast.get_collider()
	
	if shadow_raycast.is_colliding():
		var result_pos = shadow_raycast.get_collision_point()
		
		shadow.set_global_position(result_pos)
