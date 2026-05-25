class_name BaseCollectable extends Area3D


func consume():
	print("Consooom")
	cleanup()


func cleanup():
	queue_free()
