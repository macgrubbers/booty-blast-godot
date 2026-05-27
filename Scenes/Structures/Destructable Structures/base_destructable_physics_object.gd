class_name BaseDestructablePhysicsObject extends RigidBody3D

@onready var health: int = 3
@export var scale_override: Vector3 = Vector3(1,1,1)

@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var mesh = $MeshInstance3D
@onready var kill_delay: Timer = $Timer
@onready var spawner: CoinSpawner = $CoinSpawner


func _ready() -> void:
	collision_shape.scale = scale_override
	mesh.scale = scale_override

func attack(damage:int, knockback:Vector3, collision_point:Vector3):
	apply_impulse(knockback,to_local(collision_point))
	kill()
	
func kill():
	if kill_delay.is_stopped():
		kill_delay.start()
	await kill_delay.timeout
	spawner.spawn(10)
	queue_free()
