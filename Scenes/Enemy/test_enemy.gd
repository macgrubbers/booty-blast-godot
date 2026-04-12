extends CharacterBody3D

var perception_radius : float = 30

const SPEED = 8.0
var gravity_velocity : Vector3 = Vector3.ZERO
var knockback_vector : Vector3 = Vector3.ZERO

@onready var perception_component = $EnemyPerceptionComponent
@onready var nav_agent = $NavigationAgent3D
@onready var nav_timer = $NavigationTimer
@onready var health_component = $HealthComponent
@onready var weapon = $EnemyWeapon
@onready var ragdoll = preload("res://Scenes/Enemy/Ragdoll_TestEnemy.tscn")
@onready var weapon_ragdoll = preload("res://Scenes/Enemy/EnemyComponents/Ragdoll_EnemyWeapon.tscn")


func _ready() -> void:
	if health_component:
		health_component.connect("kill", _on_enemy_dead)
		health_component.kill_timer.connect("timeout", _on_kill_timer_timeout)
	
	if perception_component:
		perception_component.set_perception_radius(perception_radius)


func _physics_process(_delta: float) -> void:
	move_and_slide()


func gravity_apply(delta):
	# apply gravity
	if !is_on_floor():
		velocity += get_gravity() * delta
	#elif is_on_floor() and gravity_velocity.length() > 0:
		#restart_gravity()
#
#
#func restart_gravity():
	#gravity_velocity = Vector3.ZERO


# Start tracking the player by starting the timer
#	TODO: Timer must cycle start once before player is tracked, change this
func start_tracking_player()->void:
	if nav_agent.is_navigation_finished():
		nav_agent.set_target_position(perception_component.player_ref.global_position)


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
	# Create enemy ragdoll
	var enemy_ragdoll:RigidBody3D = ragdoll.instantiate()
	enemy_ragdoll.set_global_transform(get_global_transform())
	var rand_hit = Vector3(randf_range(-50,50), randf_range(-50,50), randf_range(-50,50))
	enemy_ragdoll.apply_impulse(health_component.last_applied_knockback*1.5)
	enemy_ragdoll.apply_torque(rand_hit)
	get_tree().current_scene.add_child(enemy_ragdoll)
	
	# Create enemy weapon ragdoll
	var new_weapon_ragdoll = weapon_ragdoll.instantiate()
	new_weapon_ragdoll.set_global_transform(weapon.get_global_transform())
	var rand_hit2 = Vector3(randf_range(-50,50), randf_range(-50,50), randf_range(-50,50))
	new_weapon_ragdoll.apply_impulse(health_component.last_applied_knockback*1.5)
	new_weapon_ragdoll.apply_torque(rand_hit2)
	get_tree().current_scene.add_child(new_weapon_ragdoll)
	
	queue_free()
	#health_component.set_monitoring(false)
	#health_component.set_monitorable(false)
	#health_component.start_kill_timer()

func _on_kill_timer_timeout():
	pass
