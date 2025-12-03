extends CanvasLayer

@onready var pause_screen = $PauseScreen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player_ref = get_parent().get_node("Player")
	if player_ref:
		player_ref.cam_holder.connect("paused", on_game_paused)


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
