extends Area3D

var player_ref: CharacterBody3D
var player_pos: Vector3
var player_found: bool
var max_num_missed_pings:int = 3
var missed_pings:int = 0

@onready var start_tracking_on_area_entered:bool = true

@export var los_length:float
@export var los_vertical_angle:float
@export var los_horizontal_angle:float = 90

@onready var collision_shape = $PerceptionCollisionShape3D
@onready var nav_timer = $NavigationTimer


signal player_just_found()
signal player_lost

# MCKAYS NOTES
# On track started:
#	1. Search for player within FOV


# On three missed "pings"
#	1. set player_found to false
#	2. set player_ref to null

func _ready() -> void:
	pass

# Call to start tracking
# Check area when it's enabled too
func start_tracking():
	var bodies = get_overlapping_bodies()
	for body in bodies:
		player_ref = body
	nav_timer.start()
	set_monitoring(true)

# Call to stop tracking
func stop_tracking():
	nav_timer.stop()
	set_monitoring(false)


# When the player first enters area, save its reference
func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_ref = body
		if start_tracking_on_area_entered:
			start_tracking()

# When the player leaves area, remove its reference
func _on_body_exited(_body: Node3D) -> void:
	if !player_found:
		player_ref = null
		stop_tracking()


# Get the position of the player if we found them
func get_player_position()->Vector3:
	if player_ref and player_found:
		return player_ref.get_global_position()
	else:
		print("Player not found or no ref!")
		return Vector3.ZERO


# At a time interval, attempt a raycast
func _on_navigation_timer_timeout() -> void:
	check_player_raycast()


func check_player_raycast():
	# If we don't have a player ref, return
	if !player_ref:
		print("No player ref when trying to raycast")
		return

	# 1. Check if player is within FOV
	var forward_vec = Vector3.FORWARD
	var forward_vec_2d = Vector2(forward_vec.x, forward_vec.z)
	var local_player_pos = to_local(player_ref.global_position)
	var local_player_pos_2d = Vector2(local_player_pos.x, local_player_pos.z).normalized()
	var horiz_angle = fposmod(rad_to_deg(forward_vec_2d.angle_to(local_player_pos_2d)), 360.0)

	# If we're not within the FOV, return
	if (horiz_angle < (180 - los_horizontal_angle/2) or
		horiz_angle > (180 + los_horizontal_angle/2)):
		return


	# 2. Check if we have LOS
	var dir_to_player = global_position.direction_to(player_ref.get_global_position())
	var space_state = get_world_3d().direct_space_state
	var origin = get_global_position()
	var end = origin + dir_to_player * los_length
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = false
	query.set_collision_mask(1 | 2 | 20)
	var result = space_state.intersect_ray(query)
	
	# If we don't have LOS
	if !result or !result.collider.is_in_group("Player"):
		player_found = false
		emit_signal("player_lost")
		return
	
	# We passed all checks and found the player
	if !player_found:
		print("We see player!")
		player_found = true
		player_just_found.emit()
