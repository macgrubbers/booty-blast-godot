extends DestructableRigidBody3D

var prev_velocity:Vector3 = Vector3.ZERO

@onready var audio_root = $AudioRoot
@onready var ray_cast:RayCast3D = $RayCast3D
@onready var health_component:HealthComponent = $PropHealthComponent
@onready var hitbox:BaseHitbox = $BaseHitbox


func _ready() -> void:
	health_component.connect("dead",kill)
	hitbox.connect("attack_successful", _on_attack_successful)

func _physics_process(delta: float) -> void:
	# check for collision sound
	#if get_linear_velocity() < prev_velocity:
		#audio_root.play_sound("bonk", [0.5,0.5], -10)
	prev_velocity = get_linear_velocity()
	ray_cast.set_global_position(global_position)
	if ray_cast.is_colliding():
		if !audio_root.is_playing():
			audio_root.play_sound("roll")
	else:	# Not colliding
		if audio_root.is_playing():
			audio_root.stop()

func kill():
	queue_free()

func _on_attack_successful():
	audio_root.play_sound("bonk", [0.9, 1.1], -10)
