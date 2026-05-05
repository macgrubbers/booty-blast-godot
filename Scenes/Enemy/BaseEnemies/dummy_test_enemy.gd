extends CharacterBody3D

const SPEED = 8.0
const PATROL_SPEED = 5.0
var gravity_velocity : Vector3 = Vector3.ZERO
var knockback_vector : Vector3 = Vector3.ZERO

@export var attack_range : float = 10
@onready var attack_type = "melee"

@onready var health_component = $HealthComponent
@onready var visual_root = $VisualRoot
@onready var ragdoll = preload("res://Scenes/Enemy/EnemyComponents/Ragdoll_TestEnemy.tscn")

var can_patrol : bool = true
@export var patrol_path : Path3D
@onready var path_follow : PathFollow3D = $PathFollow3D

func _ready() -> void:
	if patrol_path:
		move_child(path_follow, patrol_path.get_index())	# Make path follow a child
	else:
		can_patrol = false
		
	var temp_rotation = global_rotation
	global_rotation = Vector3(0,0,0)
	visual_root.global_rotation = temp_rotation

	if health_component:
		health_component.connect("kill", _on_enemy_dead)
		#health_component.kill_timer.connect("timeout", _on_kill_timer_timeout)


func _physics_process(delta: float) -> void:
	visual_root.global_position = global_position
	path_follow.progress += SPEED * delta
	print(path_follow.progress)


	
func _on_enemy_dead(last_knockback:Vector3 = Vector3.ZERO):
	# Create enemy ragdoll
	var enemy_ragdoll:RigidBody3D = ragdoll.instantiate()
	enemy_ragdoll.set_global_transform(get_global_transform())
	var rand_hit = Vector3(randf_range(-50,50), randf_range(-50,50), randf_range(-50,50))
	enemy_ragdoll.apply_impulse(health_component.last_applied_knockback*1.5)
	enemy_ragdoll.apply_torque(rand_hit)
	get_tree().current_scene.add_child(enemy_ragdoll)
	
	queue_free()
