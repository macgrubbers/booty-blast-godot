class_name PerceptionComponent extends Area3D

var ignore_fov_distance:float = 12

@onready var los_length:float = 50
@onready var los_vertical_angle:float
@onready var los_horizontal_angle:float = 70
#@export var updates_per_second:float = 3

var start_updating:bool = false
var frames_skip:int = 20
var current_frame:int = 0

@onready var actor
@onready var collision_shape: CollisionShape3D
@export var blackboard: Blackboard

func _ready() -> void:
	actor = get_owner()
	connect("area_entered", _on_area_entered)
	connect("area_exited", _on_area_exited)


func _on_area_entered(area:Area3D):
	start_updating = true

func _on_area_exited(area:Area3D):
	start_updating = false


func _physics_process(delta: float) -> void:
	if start_updating:
		if current_frame >= frames_skip:
			check_player_raycast()
			current_frame = 0
		else:
			current_frame += 1


func check_player_raycast():
	var actor_pos = actor.get_global_position()
	var player_pos = blackboard.get_value("player_ref").get_global_position()
	var dist_to_player = (actor_pos - player_pos).length()
	var just_attacked = blackboard.get_value("just_attacked")
	var does_see_player = blackboard.get_value("see_player")

	# Check if player is within FOV
	var local_player_pos = actor.to_local(player_pos)
	var local_player_pos_2d = Vector2(local_player_pos.x, local_player_pos.z).normalized()
	var facing_dir = -actor.visual_root.global_transform.basis.z
	var facing_dir_2d = Vector2(facing_dir.x,facing_dir.z)
	var horiz_angle = abs(rad_to_deg(facing_dir_2d.angle_to(local_player_pos_2d)))
	
	# Check if player is outside FOV
	# If we see the player and are close, ignore FOV checks
	#	(this prevents the enemy from losing track of the player when very close)
	if (horiz_angle > los_horizontal_angle/2 and 
		!just_attacked):
		if !does_see_player and dist_to_player <= ignore_fov_distance:
			print("dropped track!")
			blackboard.set_value("see_player", false)
		return

	if just_attacked:
		blackboard.set_value("just_attacked", false)

	# 2. Check if we have LOS
	var dir_to_player = actor_pos.direction_to(player_pos) # + Vector3(0,0.5,0))
	var space_state = actor.get_world_3d().direct_space_state
	var origin = actor_pos + Vector3(0, 0.5, 0)
	var end = origin + dir_to_player * los_length + Vector3(0, 0.5, 0)
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = true
	query.set_collision_mask(1 << 0| 1 << 1 | 1 << 19)	# TODO: use the inspector for this
	var result = space_state.intersect_ray(query)
	
	DebugDraw3D.draw_ray(origin, origin.direction_to(end), los_length, Color.CRIMSON)
	# If we don't have LOS
	if !result or !(result.collider is HealthComponent):
		if does_see_player:
			blackboard.set_value("see_player", false)
			blackboard.set_value("in_attack_range", false)
		return
	# We passed all checks and found the player
	if !does_see_player:
		blackboard.set_value("see_player", true)
		blackboard.set_value("player_just_lost", false)
	
	if dist_to_player <= actor.attack_range:
		blackboard.set_value("in_attack_range", true)
	
	blackboard.set_value("last_seen_player_pos", player_pos)
	
	return
