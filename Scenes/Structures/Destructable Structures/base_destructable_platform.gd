class_name BaseDestructablePlatform extends StaticBody3D

func attack():
	kill()
	
func kill():
	queue_free()
