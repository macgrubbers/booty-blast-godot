extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

enum States{IDLE, GREET, TALK, DANCE}
var initial_state = States.IDLE
var current_state = initial_state

@onready var santa = $Santa
@onready var animation_player = $Santa/AnimationPlayer
@onready var animation_tree = $Santa/AnimationTree
@onready var anim_state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")


func _ready() -> void:
	# Start in the idle state
	transition_state(current_state)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()


func transition_state(new_state:States)->void:
	current_state = new_state
	var state_name = States.keys()[current_state]
	anim_state_machine.travel(state_name.to_lower())


# Triggered when the player interacts with this NPC
func interact():
	transition_state(States.GREET)
