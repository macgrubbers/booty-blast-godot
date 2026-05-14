extends CharacterBody3D

const SPEED = 8.0
var gravity_velocity : Vector3 = Vector3.ZERO
var knockback_vector : Vector3 = Vector3.ZERO

@export var attack_range : float = 30

@onready var perception_component = $EnemyPerceptionComponent
@onready var nav_agent = $NavigationAgent3D
@onready var health_component = $HealthComponent
@onready var blackboard : Blackboard = $EnemyBlackboard
@onready var weapon = $VisualRoot/EnemyRangedWeapon
@onready var visual_root = $VisualRoot

@onready var ragdoll = preload("res://Scenes/Enemy/EnemyComponents/Ragdoll_TestEnemy.tscn")

func _ready() -> void:
	if health_component:
		health_component.connect("kill", _on_enemy_dead)
		health_component.kill_timer.connect("timeout", _on_kill_timer_timeout)


func _physics_process(_delta: float) -> void:
	visual_root.global_position = global_position
	move_and_slide()

func gravity_apply():
	# apply gravity
	if !is_on_floor():
		velocity += get_gravity() * get_physics_process_delta_time()
	#elif is_on_floor() and gravity_velocity.length() > 0:
		#restart_gravity()

func _on_enemy_dead(last_knockback:Vector3 = Vector3.ZERO):
	blackboard.set_value("is_alive", false)

func _on_kill_timer_timeout():
	pass

func update_in_attack_range(status:bool):
	blackboard.set_value("in_attack_range", status)

func _on_successful_attack():
	blackboard.set_value("attack_successful", true)
