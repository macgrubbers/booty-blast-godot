extends Node3D

# References
@onready var enemies:Node3D = $Enemies
@onready var player_ref:CharacterBody3D = $Player
@onready var player_spawn_point:Node3D = $PlayerSpawnPoint
@onready var blackboard:Blackboard = $EnemyBlackboard
# Preloads
@onready var player_node = preload("res://addons/PlayerCharacter/PlayerCharacterScene.tscn")


func _ready() -> void:
	connect("child_entered_tree", _on_new_child_added)

#func _physics_process(delta: float) -> void:
	#for node:Node3D in get_tree().get_nodes_in_group("Collectables"):
		#node.look_at(player_ref.cam_holder.cam.get_global_position())
		#node.rotation.x = 0
		#node.rotation.z = 0

# Respawn will:
#	remove the old player
#	instantiate a new character, add as a child, update its reference
#	connect signals to the new player
func respawn_player():
	player_ref.queue_free()
	var new_character = player_node.instantiate()
	new_character.global_position = player_spawn_point.global_position
	add_child(new_character)
	player_ref = new_character
	
	update_blackboards()

func update_blackboards():
	for child in get_children():
		if child.is_in_group("Enemies"):
			child.blackboard.set_value("player_ref", player_ref)

func _on_new_child_added(node:Node):
	if node.is_in_group("Enemies"):
		await node.ready
		print("blackboarded")
		node.blackboard.set_value("player_ref", player_ref)
