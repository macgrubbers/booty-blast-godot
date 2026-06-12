class_name BaseDestructablePhysicsObject extends RigidBody3D

@onready var health: int = 3
@export var scale_override: Vector3 = Vector3(1,1,1)

@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var mesh = $MeshInstance3D
@onready var spawner: Spawner = $Spawner


func _ready() -> void:
	collision_shape.scale = scale_override
	mesh.scale = scale_override

func _physics_process(delta: float) -> void:
	spawner.global_position = global_position

func attack(damage:int, knockback:Vector3, collision_point:Vector3):
	apply_impulse(knockback,to_local(collision_point))
	kill()
	
func kill():
	for n in range(10):
		var new_obj = spawner.spawn()
	#spawner.set_spawn_method(Spawner.spawn_methods.SCATTER, 
							#true,
							#Vector2(-1,1),
							#Vector2(0,1),
							#Vector2(-1,1))
	#spawner.spawn(coin_scene, 10)
	queue_free()
