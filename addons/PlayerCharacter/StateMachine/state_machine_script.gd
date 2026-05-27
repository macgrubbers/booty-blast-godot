extends Node

@export var initial_state : State

var curr_state : State
var curr_state_name  : String
var states : Dictionary = {}

@onready var char_ref : CharacterBody3D = $".."
@onready var health_component : HealthComponent = $"../HealthComponent"
@onready var godot_plush_skin : Node3D = %GodotPlushSkin
@onready var ground_attack_area : Area3D = %GroundAttackHitbox
@onready var butt_slam_falling_hitbox : Area3D = $"../ButtSlamFallingHitbox"
@onready var butt_slam_land_hitbox : Area3D = $"../ButtSlamLandHitbox"

func _ready():
	health_component.connect("hitstunned", _on_hitstunned)
	
	#get all the state childrens
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_state_child_transition)
			
			# Connect just landed signal, only a few states will use it though so TODO nitpick, only connect relevant states?
			child.just_landed.connect(_on_just_landed)
			
			if child is GroundAttackState:
				#ground_attack_area.area_entered.connect(child._on_ground_attack_area_3d_area_entered)
				godot_plush_skin.wave_done.connect(child._on_animation_finished)
				
			if child is ButtSlamState:
				butt_slam_land_hitbox.area_entered.connect(child._on_butt_slam_landing_hitbox_entered)
				butt_slam_falling_hitbox.area_entered.connect(child._on_butt_slam_falling_hitbox_entered)

	# Connect the dead state
	char_ref.get_node("HealthComponent").connect("kill", on_player_dead)
			
	#if initial state, transition to it
	if initial_state:
		await get_tree().create_timer(0.1).timeout
		initial_state.enter(char_ref)
		curr_state = initial_state
		curr_state_name = curr_state.state_name

func _process(delta : float):
	if curr_state: curr_state.update(delta)
	
func _physics_process(delta: float):
	if curr_state: curr_state.physics_update(delta)
	
func on_state_child_transition(state : State, new_state_name : String, stun_amount:float = 0):
	#manage the transition from one state to another
	
	if state != curr_state: return
	
	var new_state:State = states.get(new_state_name.to_lower())
	if !new_state: return
	
	#exit the current state
	if curr_state: curr_state.exit()
	
	#enter the new state
	if new_state is StunnedState:
		new_state.stun_timer.set_wait_time(stun_amount)
	new_state.enter(char_ref)
	
	curr_state = new_state
	curr_state_name = curr_state.state_name

func on_player_dead():
	curr_state.transitioned.emit(curr_state, "RagdollState")

func _on_hitstunned(stun_duration:float):
	curr_state.transitioned.emit(curr_state, "StunnedState", stun_duration)

# Check if we should do anything special on landing
# Liiiikke a JUMP PAD!!!!
func _on_just_landed():
	if char_ref.floor_check.is_colliding():
		var collider = char_ref.floor_check.get_collider()
		if collider is LaunchingPlatform:
			var collision_normal = char_ref.floor_check.get_collision_normal()
			collider.launch(char_ref.health_component,
							curr_state,
							curr_state.prev_in_air_velocity,
							collision_normal)
			curr_state.transitioned.emit(curr_state,"InAirState")
