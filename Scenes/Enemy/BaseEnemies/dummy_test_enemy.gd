extends CharacterBody3D

const SPEED = 8.0
@export var patrol_speed:float
var knockback_vector : Vector3 = Vector3.ZERO

@onready var attack_type = "melee"

@onready var health_component = $HealthComponent
@onready var visual_root = $VisualRoot
@onready var ragdoll = preload("res://Assets/Lil' Goober Hostile/Lil Goober Dummy.tscn")
@onready var blackboard : Blackboard = $EnemyBlackboard

@export var path_follow : PathFollow3D

func _ready() -> void:
	var temp_rotation = global_rotation
	global_rotation = Vector3(0,0,0)
	visual_root.global_rotation = temp_rotation

	if health_component:
		health_component.connect("dead", _on_enemy_dead)
		#health_component.kill_timer.connect("timeout", _on_kill_timer_timeout)
	
	if path_follow:
		blackboard.set_value("can_patrol", true)

func _physics_process(delta: float) -> void:
	move_and_slide()

	
func _on_enemy_dead(last_knockback:Vector3 = Vector3.ZERO):
	blackboard.set_value("is_alive", false)

func gravity_apply():
	velocity += get_gravity() * get_physics_process_delta_time()
