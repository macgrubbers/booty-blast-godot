extends AnimatableBody3D

var open:bool = false
@export var contained_barrels: int = 30
@export var num_frames_between_spawn: int = 4
var frames: int = 0

@onready var spawner: Spawner = $Spawner
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var prop_scene:PackedScene = preload("res://Scenes/Props/ExplodingBarrel.tscn")

@onready var top_collision_shape: CollisionShape3D = $CollisionShape3D2

@onready var start_spawning:bool = false

func _ready() -> void:
	spawner.set_spawn_method(Spawner.spawn_methods.SCATTER, 
						true,
						Vector2(-10.1,10.1),
						Vector2(20,40),
						Vector2(-10.1,10.1))

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

			spawner.spawn(prop_scene, 1)
			contained_barrels -= 1

		else:
			frames += 1

	if contained_barrels <= 0:
		set_physics_process(false)
		cleanup()

func cleanup():
	await await get_tree().create_timer(2.0).timeout
	queue_free()
