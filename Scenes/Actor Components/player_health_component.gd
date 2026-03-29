extends HealthComponent

@onready var state_machine = $"../StateMachine"


func change_health(amount : float, attacker_position:Vector3=Vector3.ZERO):
	if !can_damage(attacker_position):
		return
	super(amount)


func can_damage(pos:Vector3)->bool:
	# ignore damage if player is above attacker
	if state_machine.curr_state_name == "ButtSlam":
		var player_pos = Vector2(owner.global_position.x, owner.global_position.y)
		var attacker_pos = Vector2(pos.x, pos.y)
		var angle_between = rad_to_deg(player_pos.angle_to(attacker_pos))
		print(angle_between)
	return true
