extends Area3D
class_name HealthComponent

@export var is_alive = true
@export var max_health : float = 3
@export var current_health : float
@export var collision_shape : Node3D

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
	emit_signal("update_health", current_health)


func change_health(amount : float):
	current_health += amount
	emit_signal("update_health", current_health)
	
	if current_health <= 0:
		current_health = 0
		is_alive = false
		#get_parent().kill()
		emit_signal("kill")

func apply_knockback(amount:Vector3, restart_gravity:bool):
	get_parent().knockback_apply(amount,restart_gravity)

func get_current_health()->float:
	return current_health
	
func set_max_health(new_max:float):
	max_health = new_max
	if current_health > max_health:
		current_health = max_health
