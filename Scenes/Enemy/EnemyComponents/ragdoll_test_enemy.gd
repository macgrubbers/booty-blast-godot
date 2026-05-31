extends RigidBody3D

@onready var timer = $Timer
@onready var spawner = $Spawner
@onready var coin_scene:PackedScene = preload("res://Scenes/Collectables/CoinCollectable.tscn")

func _ready() -> void:
	timer.connect("timeout", cleanup)


func cleanup():
	spawner.set_spawn_method(spawner.spawn_methods.SCATTER, 
							true,
							Vector2(-1,1),
							Vector2(0,1),
							Vector2(-1,1))
	spawner.spawn(coin_scene,5)
	queue_free()
