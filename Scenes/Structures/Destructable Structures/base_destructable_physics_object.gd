class_name BaseDestructablePhysicsObject extends RigidBody3D

func attack(damage:int, knokcback:Vector3):
	kill()
	
func kill():
	queue_free()
