extends Area3D

var player_ref: CharacterBody3D
var player_pos: Vector3

var player_found:bool = false
var max_num_missed_pings:int = 3
var missed_pings:int = 0

@export var los_length:float
@export var los_vertical_angle:float
@export var los_horizontal_angle:float = 90

@onready var collision_shape = $PerceptionCollisionShape3D
@onready var nav_timer = $NavigationTimer


# MCKAYS NOTES
# On area entered:
#	1. "ping" player, determine if they're within our LOS
#	2. If within LOS, set player_found to true


# On three missed "pings"
#	1. set player_found to false
#	2. set player_ref to null


func _ready() -> void:
	pass

func _on_body_entered(body: CharacterBody3D) -> void:
	if body.is_in_group("Player"):
		player_ref = body
		nav_timer.start()

func _on_body_exited(body: Node3D) -> void:
	pass
	#if body.is_in_group("Player"):
		#player_ref = null

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



# At a time interval, attempt a raycast
func _on_navigation_timer_timeout() -> void:
	check_player_raycast()


func check_player_raycast():
	# Perform raycast
	if !player_ref:
		print("No player ref when trying to raycast")
		return
	var dir_to_player = global_position.direction_to(player_ref.get_global_position())
	var space_state = get_world_3d().direct_space_state
	var origin = get_global_position()
	var end = origin + dir_to_player * los_length
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = false
	query.set_collision_mask(1 | 2 | 20)
	var result = space_state.intersect_ray(query)
	
	# Process raycast result
	# If we have found the player but fail to this iteration, add a strike
	if player_found and (!result or !result.collider.is_in_group("Player")):
		missed_pings += 1
		if missed_pings >= max_num_missed_pings:
			player_found = false
			player_pos = Vector3.ZERO
			nav_timer.stop()
		return
	
	# If we haven't found the player and there's no result, no consequence
	if !player_found and !result:
		print("player not found and no result")
		return
		
	# Check if the player is within the FOV
	var forward_vec = global_basis * Vector3.FORWARD
	var forward_vec_2d = Vector2(forward_vec.x, forward_vec.z)
	var local_player_pos = to_local(result.position)
	var local_player_pos_2d = Vector2(local_player_pos.x, local_player_pos.z).normalized()
	var horiz_angle = fposmod(rad_to_deg(forward_vec_2d.angle_to(local_player_pos_2d)), 360.0)
	
	print(horiz_angle)
	
	if (horiz_angle > (360 - los_horizontal_angle/2) or
		horiz_angle < (los_horizontal_angle/2)):
		return
	else:
		print("player found!")
		player_found = true
		player_pos = result.position
