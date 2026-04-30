@tool
class_name PatrolAction extends ActionLeaf

var movement_acceleration : float = 0.4
var movement_velocity : Vector3 = Vector3.ZERO
@onready var current_path_index:int
@onready var path_size:int

@onready var actor = $"../../../../../.."
@onready var nav_agent:NavigationAgent3D
@onready var patrol_path:Path3D = $"../../../../../..".patrol_path

func _ready() -> void:
	await actor.ready
	nav_agent = actor.nav_agent

func before_run(actor: Node, blackboard: Blackboard) -> void:
	current_path_index = 0
	path_size = patrol_path.curve.get_point_count()
	if path_size == 0:
		print("path size zero!")

func tick(actor: Node, blackboard: Blackboard) -> int:
	actor.gravity_apply()
	
	if nav_agent.is_navigation_finished():
		var next_target_position = patrol_path.to_global(patrol_path.curve.get_point_position(current_path_index))
		nav_agent.set_target_position(next_target_position)
		nav_agent.simplify_path = true
		
		# Iterate sequentially, then reverse-sequentially
		if ((current_path_index+1) >= path_size):
			current_path_index -= 1
		else:
			current_path_index += 1

	var next_path_position: Vector3 = actor.nav_agent.get_next_path_position()
	var new_velocity: Vector3 = actor.get_global_position().direction_to(next_path_position) * actor.PATROL_SPEED
	actor.velocity = actor.velocity.move_toward(new_velocity, movement_acceleration)
	
	actor.visual_root.look_at(next_path_position)
	actor.visual_root.rotation.x = 0
	actor.visual_root.rotation.z = 0
	
	return RUNNING
