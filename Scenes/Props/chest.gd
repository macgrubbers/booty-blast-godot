extends AnimatableBody3D

@onready var spawner: Spawner = $Spawner
@onready var coin_scene:PackedScene = preload("res://Scenes/Collectables/CoinCollectable.tscn")


func interact():
	spawn()
	queue_free()

func spawn():
	spawner.set_spawn_method(Spawner.spawn_methods.SCATTER, 
						true,
						Vector2(-0.1,0.1),
						Vector2(1,1.5),
						Vector2(-0.1,0.1))
	spawner.spawn(coin_scene, 10)
