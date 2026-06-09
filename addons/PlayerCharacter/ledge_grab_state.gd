class_name LedgeGrabState extends State

var state_name = "LedgeGrabState"

var cR : CharacterBody3D
@onready var raycasts: Node3D = $"../../Raycasts"
@onready var ledge_grab_raycast1: RayCast3D = $"../../Raycasts/LedgeGrabRaycast1"
@onready var ledge_grab_raycast3: RayCast3D = $"../../Raycasts/LedgeGrabRaycast3"
@onready var cam = $"../../OrbitView"

func enter(char_ref : CharacterBody3D):
	#pass play char reference
	cR = char_ref

	verifications()
	
func verifications():
	cR.cam_holder.lock_camera_vertical = false
	
	# Do a PhysicsRayQueryParameters3D that mimics ledge_grab_raycast1 to get
	#	the surface normal
	# It's inefficient but easier to use the RayCast3D nodes than it is the queries
	var space_state = cR.get_world_3d().direct_space_state
	var origin = ledge_grab_raycast1.get_global_position()
	var end = origin + (raycasts.get_global_basis() * ledge_grab_raycast1.get_target_position())
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	query.collide_with_areas = false
	query.collide_with_bodies = true
	query.set_collision_mask(ledge_grab_raycast1.get_collision_mask())
	var result = space_state.intersect_ray(query)
	var surface_normal:Vector3
	if result:
		surface_normal = result.normal
		
	cam.lock_camera_vertical = false
	
	
	# Force update raycasts
	ledge_grab_raycast1.force_raycast_update()
	var raycast1_intersect_pos = ledge_grab_raycast1.get_collision_point()

	ledge_grab_raycast3.force_raycast_update()
	var raycast3_intersect_pos = ledge_grab_raycast3.get_collision_point()
	var player_distance_from_wall = 0.6
	var player_distance_from_ledge = 1.5
	
	# Set the new wall grab positions
	var new_x = raycast1_intersect_pos.x + (surface_normal.x * player_distance_from_wall)
	var new_y = raycast3_intersect_pos.y - player_distance_from_ledge
	var new_z = raycast1_intersect_pos.z + (surface_normal.z * player_distance_from_wall)

	cR.position = Vector3(new_x, new_y, new_z)
	cR.velocity = Vector3.ZERO
	cR.visual_root.look_at(raycast1_intersect_pos + surface_normal)
	cR.visual_root.rotation.x = 0
	cR.visual_root.rotation.z = 0

	
func physics_update(_delta : float):
	input_management()

func input_management():
	if Input.is_action_just_pressed(cR.jumpAction):
		ledge_grab_raycast3.force_raycast_update()
		var raycast3_intersect_pos = ledge_grab_raycast3.get_collision_point()
		cR.position = raycast3_intersect_pos + Vector3(0,0.0,0)
		transitioned.emit(self, "InAirState")
		
