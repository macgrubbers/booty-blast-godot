class_name DestructableRigidBody3D extends RigidBody3D

@export var health: int = 1
@export var armor: int = 0


func attack(damage:int, knockback:Vector3, collision_point:Vector3):
	apply_impulse(knockback,to_local(collision_point))
	kill()
	
func kill():
	pass
