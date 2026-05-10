@tool
class_name DummyPatrolAction extends ActionLeaf

@onready var actor = $"../../../../.."
@onready var path_follow:PathFollow3D

func _ready() -> void:
	actor.connect("ready",_on_actor_ready)

func _on_actor_ready():
	path_follow = actor.path_follow

# TODO: maybe move this by velocity instead of on a hard path?
#	TODO: could be reused for other enemies
func tick(actor: Node, blackboard: Blackboard) -> int:
	var delta = get_physics_process_delta_time()
	path_follow.progress_ratio += actor.patrol_speed * delta
	if !actor.visual_root.rotation.cross(path_follow.global_position).is_zero_approx():
		actor.visual_root.look_at(path_follow.global_position)
	actor.visual_root.rotation.x = 0
	actor.visual_root.rotation.z = 0
	actor.global_position = path_follow.global_position

	return SUCCESS
