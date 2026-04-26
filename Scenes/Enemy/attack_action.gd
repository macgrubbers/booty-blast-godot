@tool
class_name AttackAction extends ActionLeaf

@onready var attack_dir:Vector3
@onready var CHARGE_SPEED:float

var delta:float
@onready var charge_time:float = 0.25
var current_time:float

@onready var timer:Timer = $Timer
@onready var post_attack



func before_run(actor: Node, blackboard: Blackboard) -> void:
	post_attack = false
	current_time = 0
	CHARGE_SPEED = 20
	var player_pos = blackboard.get_value("player_ref").get_global_position()
	attack_dir = actor.get_global_position().direction_to(player_pos)
	delta = get_physics_process_delta_time()

	
	#actor.weapon.toggle_hitbox(true)
	actor.weapon.activate_for_set_time(1.5)
	actor.visual_root.look_at(player_pos)
	actor.visual_root.rotation.x = 0
	actor.visual_root.rotation.z = 0
	
	timer.start()


func tick(actor: Node, blackboard: Blackboard) -> int:
	actor.gravity_apply()
	if !timer.is_stopped():
		var lerp_amount:Vector3 = actor.velocity.lerp(Vector3.ZERO,delta*5)
		actor.velocity.x = lerp_amount.x
		actor.velocity.z = lerp_amount.z
		return RUNNING
		
	if post_attack:
		return SUCCESS
		
	current_time += delta
	actor.velocity.x = attack_dir.x * CHARGE_SPEED
	actor.velocity.z = attack_dir.z * CHARGE_SPEED
	
	if current_time <= charge_time:
		return RUNNING
	else:
		timer.start()
		post_attack = true
		return RUNNING

func after_run(actor: Node, blackboard: Blackboard) -> void:
	blackboard.set_value("in_attack_range", false)
