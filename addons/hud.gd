extends CanvasLayer

# References
@onready var root_node = $".."
@onready var pause_screen = $PauseScreen
@onready var dead_screen = $DeadScreen
@onready var health_bar = $HealthBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_player_signals(get_parent().get_node("Player"))

func connect_player_signals(player_ref:CharacterBody3D):
	if player_ref:
		player_ref.cam_holder.connect("paused", on_game_paused)
		player_ref.health_component.connect("kill",on_player_died)
		player_ref.health_component.connect("update_health", on_health_updated)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_game_paused():
	if get_tree().paused:
		pause_screen.visible = false
		get_tree().paused = false
	else:
		pause_screen.visible = true
		get_tree().paused = true

func on_player_died():
	dead_screen.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_respawn_button_pressed() -> void:
	root_node.respawn_player()
	dead_screen.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func on_health_updated(new_health:int)->void:
	health_bar.update_player_health(new_health)
