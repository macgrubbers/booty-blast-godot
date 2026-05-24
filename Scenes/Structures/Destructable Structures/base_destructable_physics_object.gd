class_name BaseDestructablePhysicsObject extends RigidBody3D

@onready var health

func attack(damage:int, knockback:Vector3, collision_point:Vector3):
	apply_impulse(knockback,to_local(collision_point))
	
func kill():
	queue_free()
