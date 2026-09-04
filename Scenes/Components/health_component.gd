extends Area3D
class_name HealthComponent

# health and armor
@export var max_health : int = 3
var current_health : int
@export_range(1,3) var defense_level:int = 0

# status
@onready var is_alive = true
@onready var can_be_hurt: bool = true
@export var armor_blocks_knockback:bool = false

# immunity timers
@export var knockback_immunity_timer:Timer
@export var damage_immunity_timer:Timer
@export var immunity_time: float = 1


# knockback
var last_applied_knockback:Vector3 # For ragdolls


signal attack_successful(attacker: Node3D)
signal attack_unsuccessful(attacker: Node3D)
signal hitstunned(duration:float)
signal update_health(current_health:float)
signal dead()

func _ready():
	is_alive = true
	current_health = max_health
	call_deferred("post_ready")

func post_ready():
	damage_immunity_timer.set_wait_time(1.0)
	damage_immunity_timer.set_one_shot(true)
	damage_immunity_timer.connect("timeout", _on_immunity_timer_timeout)
	knockback_immunity_timer.set_wait_time(1.0)
	knockback_immunity_timer.set_one_shot(true)
	emit_signal("update_health", current_health)

# TODO: renamed successful/unsuccessful to 'hit' and 'block' to not confuse signals w/ hitboxes
func attack(amount : int,
			attack_level : int,
			attacker:Node3D, 
			knockback:Vector3 = Vector3.ZERO, 
			hitstun_duration:float = 0):
	var is_armor_blocked = (defense_level > attack_level)
	# ignore changing health if immune or dead
	if !can_be_hurt or !is_alive or (is_armor_blocked):
		emit_signal("attack_unsuccessful", attacker)
	else:
		current_health -= amount
		emit_signal("update_health", current_health)
		emit_signal("attack_successful", attacker)

	# Start immunity timer regardless of success
	damage_immunity_timer.start()
	can_be_hurt = false
	
	# apply knockback if possible
	var block_attack = armor_blocks_knockback and is_armor_blocked
	if !block_attack:
		apply_knockback(knockback, false)
		emit_signal("hitstunned", hitstun_duration)

	if current_health <= 0:
		kill()
	return

func apply_knockback(amount:Vector3, start_timer:bool = false, reset_velocity:bool = false):
	# ignore knockback if immune
	if !knockback_immunity_timer.is_stopped():
		return
	last_applied_knockback = amount
	if reset_velocity:
		print("reset velocity to zero")
		get_owner().velocity = Vector3.ZERO
	get_owner().velocity += amount
	if start_timer:
		knockback_immunity_timer.start()

func heal(amount:int):
	current_health += amount
	emit_signal("update_health", current_health)

func get_current_health()->float:
	return current_health
	
func set_max_health(new_max:int):
	max_health = new_max
	if current_health > max_health:
		current_health = max_health

func _on_immunity_timer_timeout():
	can_be_hurt = true
	

func kill():
	current_health = 0
	is_alive = false
	#get_parent().kill()
	await get_tree().process_frame # TODO: added to let ragdolls be created after enemy death, maybe remove later
	emit_signal("dead")
	monitorable = false




#####################################################
# Status

var active_effects: Array[StatusEffect] = []

signal new_effect_applied(effect:String)
signal effect_removed(effect:String)

func _process(delta: float) -> void:
	var expired_effects: Array[StatusEffect] = []

	for effect in active_effects:
		effect.update(delta)
		if effect.is_expired:
		# Using stack or list collection to track expired items safely
			expired_effects.append(effect)
			
	for effect in expired_effects:
		remove_status_effect(effect)
		effect_removed.emit(effect.effect_name)

func apply_status_effect(new_effect: StatusEffect) -> void:
	# Check if effect already exists to refresh duration instead of stacking
	for effect in active_effects:
		if effect.get_script() == new_effect.get_script():
			effect.time_elapsed = 0.0 # Refresh duration
			return
			
	active_effects.append(new_effect)
	new_effect.apply(owner)
	new_effect_applied.emit(new_effect.effect_name)

func remove_status_effect(effect: StatusEffect) -> void:
	effect.remove()
	active_effects.erase(effect)
