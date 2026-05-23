class_name BaseDestructablePlatform extends StaticBody3D

func attack(damage:int):
	kill()
	
func kill():
	queue_free()
