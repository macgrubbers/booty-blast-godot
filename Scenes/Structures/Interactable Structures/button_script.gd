extends StaticBody3D

class_name button

@onready var enemy = preload("res://Scenes/Enemy/TestEnemy.tscn")

func interact():
	print(" yuo push da butoton")
	var new_enemy = enemy.instantiate()
	new_enemy.set_global_position(Vector3(0,10,40))
	get_tree().get_root().add_child(new_enemy)
