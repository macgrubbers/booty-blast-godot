class_name PerceptionComponent extends Area3D

var ignore_fov_distance:float = 12

var is_alive:bool = true
@onready var los_length:float = 50
@onready var los_vertical_angle:float
@export var los_horizontal_angle:float = 70
#@export var updates_per_second:float = 3

var start_updating:bool = false
var frames_skip:int = 20
var current_frame:int = 0

@onready var actor
@onready var collision_shape: CollisionShape3D
@export var blackboard: Blackboard
@export var health_component:HealthComponent
@export var nav_agent:NavigationAgent3D

func _ready() -> void:
	actor = get_owner()
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)
	health_component.connect("kill", _on_player_died)


func _on_area_entered(area:Area3D):
	if area.get_owner().is_in_group("Player"):
		blackboard.set_value("player_ref", area.get_owner())
		start_updating = true

func _on_area_exited(area:Area3D):
	if area.get_owner().is_in_group("Player"):
		blackboard.set_value("player_ref", null)
		start_updating = false

func _on_player_died():
	disconnect("area_entered", _on_area_entered)
	disconnect("area_exited", _on_area_exited)
	is_alive = false

func _physics_process(delta: float) -> void:
	if start_updating and is_alive:
		if current_frame >= frames_skip:
			check_player_raycast()
			current_frame = 0
		else:
			current_frame += 1


func check_player_raycast():
	var actor_pos = actor.get_global_position()
	var player_ref = blackboard.get_value("player_ref")
	if !player_ref:
		return
		
	var player_pos = player_ref.get_global_position()
	var dist_to_player = (actor_pos - player_pos).length()


	# Check FOV if the player hasn't been seen yet
	if !blackboard.get_value("see_player"):
		var within_fov = check_fov(player_pos, actor_pos)
		if !within_fov:
			return

	# Check if we have LOS
	var los_successful = check_los(player_pos, actor_pos)
	
	# if LOS failed
	if !los_successful:
		if blackboard.get_value("see_player"):
			blackboard.set_value("see_player", false)
			blackboard.set_value("player_just_lost", true)
			blackboard.set_value("in_attack_range", false)
		return # stop update
	
	# We passed all checks and found the player
	# Set see player and
	if !blackboard.get_value("see_player"):
		blackboard.set_value("see_player", true)
		blackboard.set_value("player_just_lost", false)
	
	# check if in attack range
	if dist_to_player <= actor.attack_range:
		blackboard.set_value("in_attack_range", true)
	
	blackboard.set_value("last_seen_player_pos", player_pos)
	
	update_navigation(player_pos)
	
	return

func check_fov(player_pos:Vector3, actor_pos:Vector3):
	# Check if player is within FOV
	var local_player_pos = actor.to_local(player_pos)
	var local_player_pos_2d = Vector2(local_player_pos.x, local_player_pos.z).normalized()
	var facing_dir = -actor.visual_root.global_transform.basis.z
	var facing_dir_2d = Vector2(facing_dir.x,facing_dir.z)
	var horiz_angle = abs(rad_to_deg(facing_dir_2d.angle_to(local_player_pos_2d)))
	
	return (horiz_angle < los_horizontal_angle/2)
	

func check_los(player_pos:Vector3, actor_pos:Vector3):
	var dir_to_player = actor_pos.direction_to(player_pos) # + Vector3(0,0.5,0))
	var space_state = actor.get_world_3d().direct_space_state
	var origin = actor_pos + Vector3(0, 0.5, 0)
	var end = origin + dir_to_player * los_length + Vector3(0, 0.5, 0)
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	query.set_collision_mask(1 << 0| 1 << 1 | 1 << 19)	# TODO: use the inspector for this
	var los_result = space_state.intersect_ray(query)
	
	DebugDraw3D.draw_ray(origin, origin.direction_to(end), los_length, Color.CRIMSON)
	# If we don't have LOS
	if !los_result or !(los_result.collider is HealthComponent):
		return false
	else:
		return true


func update_navigation(player_pos:Vector3):
	# if player seen and isn't attacking, update navigation
	# We want enemies to be dumb and attack where they last saw
	if blackboard.get_value("see_player"):
		nav_agent.set_target_position(player_pos)
		blackboard.set_value("is_navigation_finished", false)
