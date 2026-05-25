extends Area3D
class_name HealthComponent

var last_applied_knockback:Vector3

@export var is_alive = true
@onready var can_be_hurt: bool = true
@export var max_health : float = 3
@export var immunity_time: float = 1
var current_health : float
@export var collision_shape : Node3D

@onready var immunity_timer = $DamageImmunityTimer
@onready var knockback_immunity_timer = $KnockbackImmunityTimer

signal attack_successful(attacker: Node3D)
signal attack_unsuccessful(attacker: Node3D)
signal hitstunned(duration:float)
signal update_health(current_health:float)
signal kill()

func _ready():
	is_alive = true
	current_health = max_health
	if collision_shape == null:
		print("ERROR: Health component attached to ", get_parent().get_name(),
				" does not have a CollisionShape3D attached!")
	call_deferred("post_ready")

func post_ready():
	immunity_timer.set_wait_time(1.0)
	immunity_timer.set_one_shot(true)
	immunity_timer.connect("timeout", _on_immunity_timer_timeout)
	knockback_immunity_timer.set_wait_time(1.0)
	knockback_immunity_timer.set_one_shot(true)
	emit_signal("update_health", current_health)

func attack(amount : float, 
			attacker:Node3D, 
			knockback:Vector3 = Vector3.ZERO, 
			hitstun_duration:float = 0):
	# ignore changing health if immune or dead
	if !can_be_hurt or !is_alive:
		emit_signal("attack_unsuccessful", attacker)
	else:
		current_health += amount
		immunity_timer.start()
		emit_signal("update_health", current_health)
		can_be_hurt = false
		immunity_timer.start()
		emit_signal("attack_successful", attacker)
		emit_signal("hitstunned", hitstun_duration)
	
	apply_knockback(knockback, false)

	if current_health <= 0:
		current_health = 0
		is_alive = false
		#get_parent().kill()
		await get_tree().process_frame # TODO: added to let ragdolls be created after enemy death, maybe remove later
		emit_signal("kill")
	return

func apply_knockback(amount:Vector3, start_timer:bool = false):
	# ignore knockback if immune
	if !knockback_immunity_timer.is_stopped():
		return
	last_applied_knockback = amount
	get_owner().velocity += amount
	if start_timer:
		knockback_immunity_timer.start()

func heal(amount:int):
	current_health += amount
	emit_signal("update_health", current_health)

func get_current_health()->float:
	return current_health
	
func set_max_health(new_max:float):
	max_health = new_max
	if current_health > max_health:
		current_health = max_health

func _on_immunity_timer_timeout():
	can_be_hurt = true
	
