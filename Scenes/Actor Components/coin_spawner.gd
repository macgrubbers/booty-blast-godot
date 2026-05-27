class_name CoinSpawner extends Spawner

func _ready() -> void:
	spawning_object = preload("res://Scenes/Collectables/CoinCollectable.tscn")

func spawn(amount:int = 1):
	for i in range(amount):
		var new_coin:CoinCollectable = spawning_object.instantiate()
		new_coin.set_global_transform(get_global_transform())
		new_coin.apply_impulse(Vector3(randf_range(-1,1), 1, randf_range(-1,1)) * 10, Vector3(randf_range(-1,1), randf_range(-1,1), randf_range(-1,1)) * 10)
		new_coin.physicsable = true
		get_tree().current_scene.add_child(new_coin)
