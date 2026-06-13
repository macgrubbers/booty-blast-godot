extends SpringArm3D

var active : bool = true : set = set_active

@export_group("Camera variables")
@export_range(0.0, 0.1, 0.0001) var mouse_sens : float
@export_range(-90.0, 90.0, 0.1, "radians") var min_limit_x : float
@export_range(-90.0, 90.0, 0.1, "radians") var max_limit_x : float
@export_range(0.0, 20.0, 0.01) var pan_rotation_val : float
@export var camera_position_offset:Vector3
var use_cam_y_deadzone = false
var prev_use_cam_y_deadzone = false
@export var cam_y_deadzone:float = 5

@export_group("Camera shake variables")
@export var shake_decay: float = 0.95          # How fast the shake fades out (0-1)
@export var shake_max_roll: float = 0.1       # Maximum camera roll in radians
@export var shake_max_offset: Vector3 = Vector3(1, 1, 1) # Max shake distance (X, Y, Z)

var trauma: float = 0.0                 # Current shake intensity
var trauma_power: float = 2.0           # Shape of the shake curve
var noise: FastNoiseLite = FastNoiseLite.new()
var noise_y: float = 0.0
var noise_speed: float = 20.0

@export_group("Zoom variables")
var zoom_val : float = 8.0
@export var max_zoom_val : float
@export var min_zoom_val : float
@export var zoom_speed : float

@export_group("Aim variables")
var cam_aimed : bool = false #if true, cam goes into "aim/shooter mode", above the play char shoulder
@export var aim_cam_pos : Vector3
var aim_cam_pos_side : bool = true #false = left, true = right

@export_group("Keybinding variables")
@export var mouse_mode_action : String = ""
@export var aim_cam_action : String = ""
@export var aim_cam_side_action : String = ""
@export var cam_zoom_in_action : String = ""
@export var cam_zoom_out_action : String = ""

#references variables
@onready var player : CharacterBody3D = $".."
@onready var cam : Camera3D = %Camera3D
@onready var player_ragdoll = %GodotPlushSkin.pelvis_bone

# Signals
signal paused

func _ready():
	#capture mouse cursor, and enable camera
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Input.set_use_accumulated_input(false)
	set_active(active)
	
	add_excluded_object(self)
	position = camera_position_offset
	
	# Camera shake
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	
func set_active(state : bool):
	#enable/disable play char camera
	active = state
	set_process_input(active)
	set_process(active)

func _input(event):
	#free/capture mouse cursor
	if event.is_action_pressed(mouse_mode_action):
		if get_parent().check_if_alive():
			emit_signal("paused")
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			elif Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			
	#if mouse cursor is free, can't rotate cam
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED: return
	
	# TODO: Remove or uncomment out!
	#change cam mode (default, aim)
	#if event.is_action_pressed("aim_cam"):
		#cam_aimed = !cam_aimed
		#
	##change cam side when aimed (over left shoulder, or over right shoulder)
	#if event.is_action_pressed("aim_cam_side"):
		#aim_cam_pos_side = !aim_cam_pos_side
		
	#rotate cam according to the mouse
	if event is InputEventMouseMotion: 
		var viewport_transform: Transform2D = get_tree().root.get_final_transform()
		var mouse_motion = event.xformed_by(viewport_transform).relative
		rotate_from_vector(mouse_motion * mouse_sens)
		
func _process(delta):
	if player.health_component.is_alive:
		var player_pos:Vector3 = player.get_global_position()
		var player_vel = player.get_velocity()
		var new_global_position = player_pos
		# if using deadzone
		var player_camera_pos_diff = player_pos.y - global_position.y
		
		if use_cam_y_deadzone:
			# if outside the deadzone, move towards it
			if (player_camera_pos_diff) >= 1:
				new_global_position.y = player_pos.y
			
			# force off deadzone if we're falling
			elif (player_camera_pos_diff) <= -3.51:
				use_cam_y_deadzone = false
			# if within the deadzone, stay steady
			else:
				new_global_position.y = global_position.y
		# Grounded camera
		else:
				new_global_position.y = player_pos.y + camera_position_offset.y
		# set the new camera position
		# TODO: change lerp based on veocity?
		global_position.x = lerp(global_position.x, new_global_position.x, delta*8)
		global_position.y = lerp(global_position.y, new_global_position.y, delta*4)
		global_position.z = lerp(global_position.z, new_global_position.z, delta*8)
	else:
		global_position = player_ragdoll.get_global_position() + camera_position_offset
	#get pan direction
	var joy_dir:Vector2 # = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	
	#position the cam according to her mode (default, aim (with left or right side))
	#if !cam_aimed: cam.position = Vector3(0.0, 0.0, zoom_val)
	#else: cam.position = Vector3(aim_cam_pos.x if aim_cam_pos_side else -aim_cam_pos.x, aim_cam_pos.y, zoom_val)
	
	#rotate cam
	rotate_from_vector(joy_dir * Vector2(1.0, 0.5) * pan_rotation_val * delta)
	
	#handle zoom
	zoom_handling(delta)
	
	#handle shake
	shake_handling(delta)
	
func rotate_from_vector(vector : Vector2):
	#rotate cam by the vector's amount, and clamp the rotation between max up and max down values
	#(to avoid doing 360 degree turn with the cam for example)
	if vector.length() == 0:
		return
	
	#rotation.y -= vector.x
	#rotation.x -= vector.y
	rotation = rotation.lerp(Vector3(rotation.x - vector.y, rotation.y - vector.x, 0), 0.4)
	rotation.x = clamp(rotation.x, min_limit_x, max_limit_x)
	
func zoom_handling(delta : float):
	#zoom in/out cam, and clamp zoom value between min and max zoom values
	#zoom_val += Input.get_axis(cam_zoom_in_action, cam_zoom_out_action) * zoom_speed * delta
	#zoom_val = clamp(zoom_val, min_zoom_val, max_zoom_val)
	spring_length += Input.get_axis(cam_zoom_in_action, cam_zoom_out_action) * zoom_speed * delta
	spring_length = clamp(spring_length, min_zoom_val, max_zoom_val)


func shake_handling(delta:float):
	if trauma > 0.0:
		trauma = max(trauma - shake_decay * delta, 0.0)
		shake_camera()
	#else:
		## Return to resting state smoothly
		#cam.transform.origin = transform.origin.lerp(Vector3.ZERO, delta * 10)
		#cam.rotation = rotation.lerp(Vector3.ZERO, delta * 10)

func add_trauma(amount: float) -> void:
	trauma = clamp(trauma + amount, 0.0, 1.0)
	
func reset_trauma():
	trauma = 0.0


func shake_camera() -> void:
	var shake_amount = pow(trauma, trauma_power)
	noise_y += 1.0 # Move down the noise space

	# Calculate offsets
	var offset_x = shake_max_offset.x * shake_amount * noise.get_noise_2d(noise.seed, noise_y * noise_speed)
	var offset_y = shake_max_offset.y * shake_amount * noise.get_noise_2d(noise.seed + 1, noise_y * noise_speed)
	var offset_z = shake_max_offset.z * shake_amount * noise.get_noise_2d(noise.seed + 2, noise_y * noise_speed)
	
	# Calculate rotations
	var rot_z = shake_max_roll * shake_amount * noise.get_noise_2d(noise.seed + 3, noise_y * noise_speed)
	
	# Apply local offset and rotation to the Camera3D node
	cam.transform.origin += Vector3(offset_x, offset_y, offset_z)
	cam.rotation.z = rot_z
