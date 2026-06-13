class_name Checkpoint extends Area3D

var is_current_checkpoint:bool

func _ready() -> void:
	pass

func spawn_player()-> CharacterBody3D:
	return $Spawner.spawn()

func play_particles():
	$CelebrateParticles.emitting = true
