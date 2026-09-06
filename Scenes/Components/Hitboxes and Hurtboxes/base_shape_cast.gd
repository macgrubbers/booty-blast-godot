class_name HurtShapeCast extends ShapeCast3D

@export var shape_radius:float
@export var damage:int
@export var knockback_magnitude:float
@export var extra_vertical_knockback: Vector3 = Vector3(0,1,0)

var explosion_shape:SphereShape3D


func _ready() -> void:
	shape = SphereShape3D.new()
	shape.set_radius(shape_radius)
