extends AnimatableBody3D

@export var contained_coins: int = 30
@export var contained_gems: int = 10

@onready var spawner: Spawner = $Spawner
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coin_scene:PackedScene = preload("res://Scenes/Collectables/CoinCollectable.tscn")
@onready var gem_scene:PackedScene = preload("res://Scenes/Collectables/GemCollectable.tscn")

@onready var start_spawning:bool = false

func _ready() -> void:
	spawner.set_spawn_method(Spawner.spawn_methods.SCATTER, 
						true,
						Vector2(-0.1,0.1),
						Vector2(1,1.5),
						Vector2(-0.1,0.1))

func interact():
	animation_player.play("open")
	await animation_player.animation_finished
	start_spawning = true

func _physics_process(delta: float) -> void:
	if start_spawning:
		var spawned_object = coin_scene
		# 1-in-4 probability we spawn a diamond instead
		if randi_range(0,4) > 3 and contained_gems > 0:
			spawned_object = gem_scene
		if contained_coins <= 0:
			spawned_object = gem_scene
			
		spawner.set_spawn_method(Spawner.spawn_methods.SCATTER, 
							true,
							Vector2(-0.1,0.1),
							Vector2(1,1.5),
							Vector2(-0.1,0.1))
		spawner.spawn(spawned_object, 1)
