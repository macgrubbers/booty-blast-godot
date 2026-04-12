extends Area3D

var player_ref : CharacterBody3D

var player_found:bool = false

@export var fov_length:float
@export var fov_vertical_angle:float
@export var fov_horizontal_angle:float = 90

@onready var collision_shape = $PerceptionCollisionShape3D
@onready var nav_timer = $NavigationTimer


func _ready() -> void:
	pass

func _on_body_entered(body: CharacterBody3D) -> void:
	if body.is_in_group("Player"):
		player_ref = body
		nav_timer.start()

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_ref = null

func get_player_position()->Vector3:
	if player_ref:
		return player_ref.get_position()
	else:
		print("Player was not detected, or ref was not found!")
		return Vector3.ZERO

#func get_player_velocity()->Vector3:
	#if player_ref:
		#return player_ref.get_velocity()
	#else:
		#print("Player was not detected, or ref was not found!")
		#return Vector3.ZERO

func set_perception_radius(new_radius):
	collision_shape.shape.set_radius(new_radius)


func check_player_raycast():
	if !player_ref:
		return
	var dir_to_player = global_position.direction_to(player_ref.get_global_position())
	var space_state = get_world_3d().direct_space_state
	var origin = get_global_position()
	var end = origin + dir_to_player * fov_length
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = false
	query.set_collision_mask(1 | 2 | 20)

	return space_state.intersect_ray(query)


func _on_navigation_timer_timeout() -> void:
	var result = check_player_raycast()
	if !result or !result.collider.is_in_group("Player"):
		return
		
	# TODO: Check if it's within our FOV
	var forward_vec = global_basis * Vector3.FORWARD
	var forward_vec_2d = Vector2(forward_vec.x, forward_vec.z)
	var player_pos = to_local(result.position)
	var player_pos_2d = Vector2(player_pos.x, player_pos.z).normalized()
	var horiz_angle = fposmod(rad_to_deg(forward_vec_2d.angle_to(player_pos_2d)), 360.0)
	
	print(horiz_angle)
	
	if (horiz_angle > (360 - fov_horizontal_angle) or
		horiz_angle < (fov_horizontal_angle)):
		return
	else:
		print("within range!")
	
	
