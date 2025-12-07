extends Node

@export var initial_state : State

var current_state : State
var current_state_name  : String
var States : Dictionary = {}

@onready var character_ref : CharacterBody3D = $".."

func _ready():	
	#get all the state childrens
	for child in get_children():
		if child is State:
			States[child.name.to_upper()] = child
			child.transitioned.connect(on_state_child_transition)
			
	#if initial state, transition to it
	if initial_state:
		await get_tree().create_timer(0.1).timeout
		initial_state.enter(character_ref)
		current_state = initial_state
		current_state_name = current_state.state_name
		
func _process(delta : float):
	if current_state: current_state.update(delta)
	
func _physics_process(delta: float):
	if current_state: current_state.physics_update(delta)
	
func on_state_child_transition(state : State, new_state_name : String):
	#manage the transition from one state to another
	
	if state != current_state: return
	
	var new_state = States.get(new_state_name.to_upper())
	if !new_state: return
	
	#exit the current state
	if current_state: current_state.exit()
	
	#enter the new state
	new_state.enter(character_ref)
	
	current_state = new_state
	current_state_name = current_state.state_name
