extends Node3D

@onready var hitbox = $WeaponHitbox
@export var damage:int = 1

func _ready() -> void:
	hitbox.damage = damage

func toggle_hitbox(toggle:bool):
	hitbox.monitoring = toggle

func activate_for_set_time(duration:float):
	hitbox.activate_for_set_time(duration)
