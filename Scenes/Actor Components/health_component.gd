extends Area3D
class_name HealthComponent

@export var is_alive = true
@export var max_health : float = 3
@export var current_health : float
@export var collision_shape : Node3D


@onready var damage_immunity_timer = $DamageImmunityTimer
@onready var knockback_immunity_timer = $KnockbackImmunityTimer

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
	damage_immunity_timer.set_wait_time(1.0)
	damage_immunity_timer.set_one_shot(true)
	knockback_immunity_timer.set_wait_time(1.0)
	knockback_immunity_timer.set_one_shot(true)
	emit_signal("update_health", current_health)


func change_health(amount : float):
	# ignore changing health if immune
	if !damage_immunity_timer.is_stopped():
		return
	
	if amount <= 0:
		if !can_damage():
			return
	
	current_health += amount
	damage_immunity_timer.start()
	emit_signal("update_health", current_health)
	
	if current_health <= 0:
		current_health = 0
		is_alive = false
		#get_parent().kill()
		emit_signal("kill")

func apply_knockback(amount:Vector3, restart_gravity:bool):
	# ignore knockback if immune
	if !knockback_immunity_timer.is_stopped():
		return
	get_parent().knockback_apply(amount,restart_gravity)
	knockback_immunity_timer.start()

func get_current_health()->float:
	return current_health
	
func set_max_health(new_max:float):
	max_health = new_max
	if current_health > max_health:
		current_health = max_health

func can_damage()->bool:
	return true
