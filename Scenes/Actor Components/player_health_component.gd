extends HealthComponent

@onready var state_machine = $"../StateMachine"


func change_health(amount : float, attacker_angle:float=0):
	print(attacker_angle)
	if !can_damage(attacker_angle):
		return
	super(amount)


func can_damage(attacker_angle:float)->bool:
	# ignore damage if player is above attacker
	if state_machine.curr_state_name == "ButtSlam":
		var safe_angle = 70
		if attacker_angle <= safe_angle:
			return false
	return true
