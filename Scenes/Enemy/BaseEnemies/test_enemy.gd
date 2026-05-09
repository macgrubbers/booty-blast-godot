extends CharacterBody3D

const SPEED = 8.0
const PATROL_SPEED = 5.0
var gravity_velocity : Vector3 = Vector3.ZERO
var knockback_vector : Vector3 = Vector3.ZERO

@export var attack_range : float = 10
@onready var attack_type = "melee"

@onready var perception_component = $EnemyPerceptionComponent
@onready var nav_agent = $NavigationAgent3D
@onready var health_component = $HealthComponent
@onready var behavior_tree = $BeehaveTree
@onready var blackboard : Blackboard = $EnemyBlackboard
@onready var weapon = $VisualRoot/EnemyWeapon
@onready var visual_root = $VisualRoot
@onready var ragdoll = preload("res://Scenes/Enemy/EnemyComponents/Ragdoll_TestEnemy.tscn")
@onready var weapon_ragdoll = preload("res://Scenes/Enemy/EnemyComponents/Ragdoll_EnemyWeapon.tscn")

@export var patrol_path : Path3D

func _ready() -> void:
	var temp_rotation = global_rotation
	global_rotation = Vector3(0,0,0)
	visual_root.global_rotation = temp_rotation
	nav_agent.connect("navigation_finished", _on_naviagtion_finished)
	weapon.hitbox.connect("attack_successful", _on_successful_attack)

	if health_component:
		health_component.connect("kill", _on_enemy_dead)
		#health_component.kill_timer.connect("timeout", _on_kill_timer_timeout)
	
	if patrol_path:
		blackboard.set_value("can_patrol", true)


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


func update_in_attack_range(status:bool):
	blackboard.set_value("in_attack_range", status)

func _on_successful_attack():
	blackboard.set_value("attack_successful", true)

func _on_naviagtion_finished():
	if !blackboard.get_value("see_player"):
		blackboard.set_value("player_just_lost", true)
