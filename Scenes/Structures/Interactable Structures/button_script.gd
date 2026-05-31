extends StaticBody3D

class_name button

@export var spawning_object:PackedScene
@export var spawn_point:Node3D

@onready var spawner = $Spawner

func _ready() -> void:
	spawner.set_global_transform(spawn_point.get_global_transform())

func interact():
	print("button pressed")
	spawner.spawn(spawning_object, 1)
