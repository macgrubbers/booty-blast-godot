extends CanvasLayer

# References
@onready var pause_screen = $PauseScreen
@onready var dead_screen = $DeadScreen
@onready var health_bar = $HealthBar
@onready var interact = $Interact
@onready var interact_label = $Interact/Label

@onready var player_ref : CharacterBody3D = $".."
@onready var cam_holder = $"../OrbitView"
@onready var health_component = $"../HealthComponent"
@onready var interact_raycast = $"../Raycasts/InteractRaycast"

@onready var info_screen = $InfoScreen

@onready var collection_component = $"../CollectionComponent"
@onready var collectables_bar = $CollectablesBar


func _ready() -> void:
	# Connect signals
	cam_holder.connect("paused", on_game_paused)
	health_component.connect("kill",on_player_died)
	health_component.connect("update_health", on_health_updated)
	interact_raycast.connect("new_collider_found", _on_new_collider_found)
	
	collection_component.connect("just_collected", _on_collectable_update)
	
	# Update collectables
	collectables_bar.update_moneys()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_game_paused():
	if get_tree().paused:
		pause_screen.visible = false
		get_tree().paused = false
		info_screen.visible = false
	else:
		pause_screen.visible = true
		get_tree().paused = true

func on_player_died():
	dead_screen.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_respawn_button_pressed() -> void:
	get_tree().get_current_scene().respawn_player()
	dead_screen.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _on_info_screen_button_pressed() -> void:
	info_screen.visible = true
	pause_screen.visible = false
	
func on_health_updated(new_health:int)->void:
	health_bar.update_player_health(new_health)

func _on_new_collider_found(collider):
	if collider:
		interact.visible = true
		interact_label.text = "[F] Interact with " + collider.get_parent().get_name()
	else:
		interact.visible = false


func _on_collectable_update(body:Node3D):
	if body is CoinCollectable:
		collectables_bar.update_moneys()
