extends Node3D

# References
@onready var player_ref:CharacterBody3D = $Player
@export var current_checkpoint:Checkpoint


# Preloads
#@onready var player_node = preload("res://addons/PlayerCharacter/PlayerCharacterScene.tscn")


func _ready() -> void:
	respawn_player()


func respawn_player():
	if player_ref:
		player_ref.queue_free()
	player_ref = current_checkpoint.spawn_player()
	player_ref.collection_component.connect("checkpoint_reached", _on_new_checkpoint_reached)

# Sets the new checkpoint as the current checkpoint
func _on_new_checkpoint_reached(new_checkpoint:Area3D):
	#current_checkpoint.is_current_checkpoint = false
	current_checkpoint = new_checkpoint
	current_checkpoint.is_current_checkpoint = true
	current_checkpoint.play_particles()
	print("new checkpoint!")
