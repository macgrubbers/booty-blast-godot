class_name DeathZone extends Area3D


func _ready() -> void:
	connect("area_entered", _on_area_entered)


func _on_area_entered(area:Area3D):
	if area is HealthComponent:
		area.kill()
