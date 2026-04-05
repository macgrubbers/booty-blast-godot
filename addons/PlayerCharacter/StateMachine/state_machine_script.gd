extends Node

@export var initial_state : State

var curr_state : State
var curr_state_name  : String
var states : Dictionary = {}

@onready var char_ref : CharacterBody3D = $".."
@onready var godot_plush_skin : Node3D = %GodotPlushSkin
@onready var ground_attack_area : Area3D = %GroundAttackHitbox
@onready var air_attack_area : Area3D = $"../VisualRoot/AirAttackHitbox"
@onready var butt_slam_falling_hitbox : Area3D = $"../ButtSlamFallingHitbox"
@onready var butt_slam_land_hitbox : Area3D = $"../ButtSlamLandHitbox"

func _ready():	
	#get all the state childrens
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_state_child_transition)
			
			if child is GroundAttackState:
				ground_attack_area.area_entered.connect(child._on_ground_attack_area_3d_area_entered)
				godot_plush_skin.wave_done.connect(child._on_animation_finished)
				
			if child is ButtSlamState:
				butt_slam_land_hitbox.area_entered.connect(child._on_butt_slam_landing_hitbox_entered)
				butt_slam_falling_hitbox.area_entered.connect(child._on_butt_slam_falling_hitbox_entered)

			if child is AirAttackState:
				air_attack_area.area_entered.connect(child._on_air_attack_area_entered)
				godot_plush_skin.wave_done.connect(child._on_animation_finished)
				

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
	
func on_state_child_transition(state : State, new_state_name : String):
	#manage the transition from one state to another
	
	if state != curr_state: return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state: return
	
	#exit the current state
	if curr_state: curr_state.exit()
	
	#enter the new state
	new_state.enter(char_ref)
	
	curr_state = new_state
	curr_state_name = curr_state.state_name

func on_player_dead():
	print("player dead")
	curr_state.transitioned.emit(curr_state, "RagdollState")
