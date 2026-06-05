extends AnimatableBody3D

var open:bool = false
@export var contained_coins: int = 30
@export var contained_gems: int = 10
@export var num_frames_between_spawn: int = 2
var frames: int = 0

@onready var spawner: Spawner = $Spawner
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var coin_scene:PackedScene = preload("res://Scenes/Collectables/CoinCollectable.tscn")
@onready var gem_scene:PackedScene = preload("res://Scenes/Collectables/GemCollectable.tscn")

@onready var top_collision_shape: CollisionShape3D = $CollisionShape3D2

@onready var start_spawning:bool = false

func _ready() -> void:
	spawner.set_spawn_method(Spawner.spawn_methods.SCATTER, 
						true,
						Vector2(-0.1,0.1),
						Vector2(1,1.5),
						Vector2(-0.1,0.1))

func interact():
	if !open:
		animation_player.play("open")
		await animation_player.animation_finished
		top_collision_shape.disabled = true
		open = true

func _physics_process(delta: float) -> void:
	if open:
		if frames == num_frames_between_spawn:
			frames = 0
			var spawned_object
			# 1-in-4 probability we spawn a diamond instead
			if (randi_range(0,3) > 2 and contained_gems > 0) or contained_coins <= 0:
				spawned_object = gem_scene
				contained_gems -= 1
			else:
				spawned_object = coin_scene
				contained_coins -= 1

			spawner.spawn(spawned_object, 1)

		else:
			frames += 1

	if contained_gems <= 0 and contained_coins <= 0:
		set_physics_process(false)
		cleanup()

func cleanup():
	await await get_tree().create_timer(2.0).timeout
	queue_free()
