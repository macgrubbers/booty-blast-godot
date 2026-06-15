extends HealthComponent

var block_state:bool

func attack(amount: int, 
			attack_level: int,
			attacker: Node3D, 
			knockback:Vector3 = Vector3.ZERO, 
			hitstun_duration:float = 0):
	# if we're blocking
	if block_state:
		amount = 0
	super(amount, attack_level, attacker, knockback, hitstun_duration)
