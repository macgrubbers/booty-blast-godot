class_name AreaOfEffect extends Area3D

@export var applied_effect:StatusEffect
@export var effect_duration:float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	
	var overlapping_areas = get_overlapping_areas()
	for overlapping_area in overlapping_areas:
		_on_area_entered(overlapping_area)


func _on_area_entered(area:Area3D):
	if area is HealthComponent:
		area.apply_status_effect(applied_effect)


func _on_area_exited(area:Area3D):
	if area is HealthComponent:
		area.remove_status_effect(applied_effect)
