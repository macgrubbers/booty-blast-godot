extends Control

var tick_amount:float
@onready var progress_bar:TextureProgressBar = $TextureProgressBar
@onready var player_ref: CharacterBody3D = $"../.."

func _ready() -> void:
	player_ref.connect("just_got_big", start_big_bar)

func start_big_bar(duration:float):
	tick_amount = 100 / duration
	progress_bar.value = 100

func _physics_process(delta: float) -> void:
	progress_bar.value -= (tick_amount * delta)
