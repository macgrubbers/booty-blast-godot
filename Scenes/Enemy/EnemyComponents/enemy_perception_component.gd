extends Area3D

var player_ref : CharacterBody3D

@onready var collision_shape = $PerceptionCollisionShape3D

func _ready() -> void:
	pass

func _on_body_entered(body: CharacterBody3D) -> void:
	if body.is_in_group("Player"):
		player_ref = body
		get_parent().start_tracking_player()

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player_ref = null

func get_player_position()->Vector3:
	if player_ref:
		return player_ref.get_position()
	else:
		print("Player was not detected, or ref was not found!")
		return Vector3.ZERO

func get_player_velocity()->Vector3:
	if player_ref:
		return player_ref.get_velocity()
	else:
		print("Player was not detected, or ref was not found!")
		return Vector3.ZERO

func set_perception_radius(new_radius):
	collision_shape.shape.set_radius(new_radius)
