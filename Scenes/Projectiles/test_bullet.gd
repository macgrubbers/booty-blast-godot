extends Area3D

@onready var speed:float = 20
@onready var direction:Vector3
@onready var shooter:Node3D
@onready var reflect_speed_multiplier:float

func setup(start_position:Vector3, target:Vector3):
	global_position = start_position
	direction = -global_position.direction_to(target)
	print(direction)

func _physics_process(delta: float) -> void:
	global_position += speed * direction * delta

func reflect_at_shooter():
	direction = global_position.direction_to(shooter.get_global_position())
	speed *= reflect_speed_multiplier
