class_name PropHealthComponent extends HealthComponent

func _ready():
	is_alive = true
	current_health = max_health

# TODO: renamed successful/unsuccessful to 'hit' and 'block' to not confuse signals w/ hitboxes
func attack(amount : int,
			attack_level : int,
			attacker:Node3D, 
			knockback:Vector3 = Vector3.ZERO, 
			hitstun_duration:float = 0):
	var is_armor_blocked = (defense_level > attack_level)
	# ignore changing health if immune or dead
	if !is_alive or (is_armor_blocked):
		emit_signal("attack_unsuccessful", attacker)
	else:
		current_health -= amount
		emit_signal("update_health", current_health)
		emit_signal("attack_successful", attacker)
	
	# apply knockback if possible
	var block_attack = armor_blocks_knockback and is_armor_blocked
	if !block_attack:
		apply_knockback(knockback, false)

	if current_health <= 0:
		current_health = 0
		is_alive = false
		#get_parent().kill()
		await get_tree().process_frame # TODO: added to let ragdolls be created after enemy death, maybe remove later
		emit_signal("kill")
		monitorable = false
	return

func apply_knockback(amount:Vector3, start_timer:bool = false, reset_velocity:bool = false):
	# ignore knockback if immune
	last_applied_knockback = amount
	get_owner().apply_impulse(amount)
