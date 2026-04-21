extends Node3D

var player_found:bool = false
var player_ref:CharacterBody3D
var ignore_fov_distance:float = 12

@export var los_length:float
@export var los_vertical_angle:float
@export var los_horizontal_angle:float = 90

@onready var parent : CharacterBody3D = get_parent()
@onready var perception_timer : Timer = $PerceptionTimer
@onready var nav_agent : NavigationAgent3D = $"../NavigationAgent3D"

signal update_see_player


func _ready() -> void:
	await parent.ready
	player_ref = parent.blackboard.get_value("player_ref")
	perception_timer.start()


func _on_perception_timer_timeout() -> void:
	var player_pos = player_ref.get_global_position()
	check_player_raycast(player_pos)


# Emits the 'update_see_player' signal if:
#	1. We are within the Line-of-Sight area of the target (the player)
#	2. We can "see" the player with a raycast
#	3. We have not seen the player previously
func check_player_raycast(player_pos:Vector3):
	var dist_to_player = (global_position - player_pos).length()
	print(dist_to_player)
	
	# 1. Check if player is within FOV
	var forward_vec = Vector3.FORWARD
	var forward_vec_2d = Vector2(forward_vec.x, forward_vec.z)
	var local_player_pos = to_local(player_pos)
	var local_player_pos_2d = Vector2(local_player_pos.x, local_player_pos.z).normalized()
	var horiz_angle = fposmod(rad_to_deg(forward_vec_2d.angle_to(local_player_pos_2d)), 360.0)

	# Check if:
	#	1. We see the player
	#	2. We're close enough to ignore FOV
	#	3. We're inside our FOV
	if (player_found and dist_to_player >= ignore_fov_distance and 
		horiz_angle < (360 - los_horizontal_angle/2) and
		horiz_angle > (los_horizontal_angle/2)):
		if player_found:
			player_found = false
			emit_signal("update_see_player",player_found)
			print("Out of FOV")
		return

	# 2. Check if we have LOS
	var dir_to_player = global_position.direction_to(player_pos)
	var space_state = get_world_3d().direct_space_state
	var origin = get_global_position()
	var end = origin + dir_to_player * los_length
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = false
	query.set_collision_mask(1 | 2 | 20)
	var result = space_state.intersect_ray(query)
	
	# If we don't have LOS
	if !result or !result.collider.is_in_group("Player"):
		if player_found:
			player_found = false
			emit_signal("update_see_player",player_found)
			print("Lost...")
		return
	
	# We passed all checks and found the player
	if !player_found:
		player_found = true
		print("I SEE YOU")
		emit_signal("update_see_player",player_found)
	
	nav_agent.set_target_position(player_pos)
