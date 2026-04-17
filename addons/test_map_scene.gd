extends Node3D

# References
@onready var blackboard:Blackboard = $EnemyBlackboard
@onready var player_ref:CharacterBody3D = $Player

# Preloads
@onready var player_node = preload("res://addons/PlayerCharacter/PlayerCharacterScene.tscn")


# Respawn will:
#	remove the old player
#	instantiate a new character, add as a child, update its reference
#	connect signals to the new player
func respawn_player():
	player_ref.queue_free()
	var new_character = player_node.instantiate()
	add_child(new_character)
	player_ref = new_character
