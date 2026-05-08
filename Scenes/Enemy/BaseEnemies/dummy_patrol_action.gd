@tool
class_name DummyPatrolAction extends ActionLeaf

var patrol_speed:float = 10.0
var patrol_acceleration:float = 50.0

@onready var actor = $"../../../../.."
@onready var path_follow:PathFollow3D

func _ready() -> void:
	actor.connect("ready",_on_actor_ready)

func _on_actor_ready():
	path_follow = actor.path_follow

func tick(actor: Node, blackboard: Blackboard) -> int:
	var delta = get_physics_process_delta_time()
	path_follow.progress += patrol_speed * delta

	var new_velocity: Vector3 = actor.global_position.direction_to(path_follow.global_position) * patrol_speed * delta
	actor.velocity = actor.velocity.move_toward(new_velocity, patrol_acceleration)
	print(new_velocity)

	return SUCCESS
