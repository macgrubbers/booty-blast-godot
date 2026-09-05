extends DestructableRigidBody3D

@onready var audio_root = $AudioRoot
@onready var ray_cast:RayCast3D = $RayCast3D
@onready var health_component:HealthComponent = $PropHealthComponent


func _ready() -> void:
	health_component.connect("dead",kill)


func _physics_process(delta: float) -> void:
	ray_cast.set_global_position(global_position)
	if ray_cast.is_colliding():
		if !audio_root.is_playing():
			audio_root.play_sound("roll")
	else:	# Not colliding
		if audio_root.is_playing():
			audio_root.stop()

func kill():
	queue_free()
