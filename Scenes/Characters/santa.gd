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
	print(animation_player)
	
	transition_state(current_state, States.IDLE)

func _physics_process(delta: float) -> void:
	state_physics_process()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()

func transition_state(current_state:States, new_state:States)->void:
	match new_state:
		States.IDLE:
			set_anim_state("Santa_IdleLookAround")

func state_physics_process():
	match current_state:
		States.IDLE:
			pass

func set_anim_state(state:String):
	anim_state_machine.travel(state)
