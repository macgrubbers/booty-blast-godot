extends RigidBody3D

@onready var timer = $Timer
@onready var coin_spawner = $CoinSpawner

func _ready() -> void:
	timer.connect("timeout", cleanup)


func cleanup():
	coin_spawner.spawn(5)
	queue_free()
