extends Area3D

@onready var speed:float = 20
@onready var direction:Vector3
@onready var shooter:Node3D
@onready var reflect_speed_multiplier:float

func setup(start_position:Vector3, target:Vector3):
	set_global_position(start_position)
	direction = global_position.direction_to(target)
	connect("area_entered", _on_area_entered)

func _physics_process(delta: float) -> void:
	global_position += speed * direction * delta
	

func reflect_at_shooter():
	direction = global_position.direction_to(shooter.get_global_position())
	speed *= reflect_speed_multiplier

func _on_area_entered(area:Area3D)->void:
	if area.get_owner() != shooter and area is HealthComponent:
		area.change_health(-1,shooter)
