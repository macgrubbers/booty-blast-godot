extends CharacterBody3D

var perception_radius : float = 30

const SPEED = 8.0
var gravity_velocity : Vector3 = Vector3.ZERO
var knockback_vector : Vector3 = Vector3.ZERO

@export var attack_range : float = 10

@onready var perception_component = $EnemyPerceptionComponent
@onready var nav_agent = $NavigationAgent3D
@onready var health_component = $HealthComponent
@onready var blackboard : Blackboard = $EnemyBlackboard
@onready var weapon = $VisualRoot/EnemyWeapon
@onready var visual_root = $VisualRoot
@onready var ragdoll = preload("res://Scenes/Enemy/Ragdoll_TestEnemy.tscn")
@onready var weapon_ragdoll = preload("res://Scenes/Enemy/EnemyComponents/Ragdoll_EnemyWeapon.tscn")


func _ready() -> void:
	if health_component:
		health_component.connect("kill", _on_enemy_dead)
		health_component.kill_timer.connect("timeout", _on_kill_timer_timeout)


func _physics_process(_delta: float) -> void:
	visual_root.global_position = global_position
	move_and_slide()


func gravity_apply(delta):
	# apply gravity
	if !is_on_floor():
		velocity += get_gravity() * delta
	#elif is_on_floor() and gravity_velocity.length() > 0:
		#restart_gravity()



# Start tracking the player by starting the timer
#	TODO: Timer must cycle start once before player is tracked, change this
'''
func start_tracking_player()->void:
	if nav_agent.is_navigation_finished():
		nav_agent.set_target_position(perception_component.player_ref.global_position)
'''

func _on_attack_area_area_entered(area: Area3D) -> void:
	if !health_component.is_alive:
		return
	
	if area.get_parent().is_in_group("Player"):
		var player_pos = area.get_parent().get_global_position()
		area.change_health(-1,global_position)
		var k_scale = 10
		var knockback_vec = global_position.direction_to(player_pos).normalized() * k_scale \
				 + Vector3(0,k_scale,0)
		area.apply_knockback(knockback_vec, true)
	
func _on_enemy_dead(last_knockback:Vector3 = Vector3.ZERO):
	blackboard.set_value("is_dead", true)

func _on_kill_timer_timeout():
	pass

func update_see_player(status:bool):
	print("See player: ", status)
	blackboard.set_value("see_player", status)

func update_in_attack_range(status:bool):
	print("In range: ", status)
	blackboard.set_value("in_attack_range", status)
