class_name CollectionComponent extends Area3D

@onready var health_component: HealthComponent = $"../HealthComponent"

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area:Area3D):
	if area is HealthCollectable:
		health_component.heal(area.heal_amount)
		area.consume()
