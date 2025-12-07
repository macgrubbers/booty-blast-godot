extends Node3D

# References
@onready var player_ref:CharacterBody3D = $Player
@onready var hud = $HUD

# Preloads
@onready var player_node = preload("res://addons/PlayerCharacter/PlayerCharacterScene.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Respawn will:
#	remove the old player
#	instantiate a new character, add as a child, update its reference
#	connect signals to the new player
func respawn_player():
	player_ref.queue_free()
	var new_character = player_node.instantiate()
	add_child(new_character)
	player_ref = new_character
	hud.connect_player_signals(new_character)
