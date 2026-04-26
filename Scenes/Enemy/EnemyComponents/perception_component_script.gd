extends Node3D

var player_found:bool = false
var player_ref:CharacterBody3D
var ignore_fov_distance:float = 12

@export var los_length:float
@export var los_vertical_angle:float
@export var los_horizontal_angle:float = 70

@onready var parent : CharacterBody3D = get_parent()
@onready var perception_timer : Timer = $PerceptionTimer
@onready var nav_agent : NavigationAgent3D = $"../NavigationAgent3D"
@onready var visual_root = $"../VisualRoot"
@onready var blackboard = $"../EnemyBlackboard"

signal update_see_player
signal update_can_attack


func _ready() -> void:
	await parent.ready
	perception_timer.start()


func _on_perception_timer_timeout() -> void:
	player_ref = parent.blackboard.get_value("player_ref")
	if player_ref:
		var player_pos = player_ref.get_global_position()
		check_player_raycast(player_pos)
	else:
		print("no player ref!")
		player_found = false
		parent.update_see_player(player_found)
		#parent.update_in_attack_range(false)
		
		


# Calls update_see_player if:
#	1. We are within the Line-of-Sight area of the target (the player)
#	2. We can "see" the player with a raycast
#	3. We have not seen the player previously

# Calls update_in_attack_range if:
#	1. The distance to the player is within the parent's attack range
func check_player_raycast(player_pos:Vector3):
	var dist_to_player = (global_position - player_pos).length()
	if dist_to_player <= parent.attack_range:
		parent.update_in_attack_range(true)
	#else:
		#parent.update_in_attack_range(false)

	# 1. Check if player is within FOV
	var local_player_pos = to_local(player_pos)
	var local_player_pos_2d = Vector2(local_player_pos.x, local_player_pos.z).normalized()
	var facing_dir = -visual_root.global_transform.basis.z
	var facing_dir_2d = Vector2(facing_dir.x,facing_dir.z)
	var horiz_angle = abs(rad_to_deg(facing_dir_2d.angle_to(local_player_pos_2d)))

	# Check if:
	#	1. We see the player
	#	2. We're close enough to ignore FOV
	#	3. We're inside our FOV
	if (dist_to_player >= ignore_fov_distance and 
		horiz_angle > los_horizontal_angle/2):
		if player_found:
			player_found = false
			parent.update_see_player(player_found)
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
			parent.update_see_player(player_found)
		return
	
	# We passed all checks and found the player
	if !player_found:
		player_found = true
		parent.update_see_player(player_found)
	
	nav_agent.set_target_position(player_pos)
	blackboard.set_value("is_navigation_finished", false)
