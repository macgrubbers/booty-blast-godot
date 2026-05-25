class_name BaseDestructablePlatform extends StaticBody3D

func attack(damage:int, knockback:Vector3, collision_point:Vector3):
	kill()
	
func kill():
	queue_free()
