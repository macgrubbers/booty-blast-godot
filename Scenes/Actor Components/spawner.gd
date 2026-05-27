class_name Spawner extends Node3D

@export var spawning_object:PackedScene

func spawn(amount:int = 1):
	for i in range(amount):
		var new_object = spawning_object.instantiate()
		setup_object(new_object)
		get_tree().current_scene.add_child(new_object)

func setup_object(new_object):
	pass
