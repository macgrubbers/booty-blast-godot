@tool
class_name RangedAttackAction extends ActionLeaf

@onready var attack_dir:Vector3
@onready var CHARGE_SPEED:float

var delta:float
@onready var player_pos:Vector3
@onready var charge_time:float = 0.25
var current_time:float

@onready var timer:Timer = $Timer
@onready var post_attack



func before_run(actor: Node, blackboard: Blackboard) -> void:
	post_attack = false
	current_time = 0
	CHARGE_SPEED = 20
	
	delta = get_physics_process_delta_time()

	
	#actor.weapon.toggle_hitbox(true)
	timer.start()

# Pause, lunge, pause again
func tick(actor: Node, blackboard: Blackboard) -> int:
	player_pos = blackboard.get_value("player_ref").get_global_position()
	actor.visual_root.look_at(player_pos)
	actor.gravity_apply()
	if !timer.is_stopped():
		var lerp_amount:Vector3 = actor.velocity.lerp(Vector3.ZERO,delta*5)
		actor.velocity.x = lerp_amount.x
		actor.velocity.z = lerp_amount.z
		return RUNNING
		
	if post_attack:
		return SUCCESS
		
	actor.weapon.fire(blackboard.get_value("player_ref").get_global_position())
	timer.start()
	post_attack = true
	return RUNNING

func after_run(actor: Node, blackboard: Blackboard) -> void:
	blackboard.set_value("in_attack_range", false) # Reset in attack range
	blackboard.set_value("just_attacked", true)
